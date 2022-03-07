import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hex/hex.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/models/ride_request.dart';
import 'package:ride/services/crypto.dart';
import 'package:ride/services/repository.dart';
import 'package:ride/services/ride/ride_currency_registry.dart';
import 'package:ride/services/ride/ride_driver.dart';
import 'package:ride/utils/constants.dart';
import 'package:ride/utils/fire_helper.dart';

part 'driver.ride.vm.freezed.dart';

@freezed
class DriverRideState with _$DriverRideState {
  const factory DriverRideState.error(String? message) = _DriverRideError;
  const factory DriverRideState.init() = _DriverRideInit;
  const factory DriverRideState.acceptingTicket() = _DriverRideAcceptingTicket;
  const factory DriverRideState.inTrip(RideRequest rideRequest) =
      _DriverRideInTrip;
}

class DriverRideVM extends StateNotifier<DriverRideState> {
  DriverRideVM(Reader read)
      : _rideDriver = read(rideDriverProvider),
        _rideCurrencyRegistry = read(rideCurrencyRegistryProvider),
        _crypto = read(cryptoProvider),
        _repository = read(repositoryProvider),
        super(const DriverRideState.init());

  final RideDriverService _rideDriver;
  final RideCurrencyRegistryService _rideCurrencyRegistry;
  final Crypto _crypto;
  final Repository _repository;

  Future<void> acceptRideRequest(RideRequest rideRequest, String badge) async {
    try {
      state = const DriverRideState.acceptingTicket();
      final keyLocal = await _rideCurrencyRegistry.getKeyFiat();
      final keyAccept = await _rideCurrencyRegistry.getKeyCrypto();
      final useBadge = BigInt.parse(badge);
      final decodedTixId = Uint8List.fromList(HEX.decode(rideRequest.tixId));
      final txnId = await _rideDriver.acceptTicket(
          keyLocal, keyAccept, decodedTixId, useBadge);
      await updateDriverId(rideRequest.tixId);
      updateInTrip(rideRequest);
    } catch (ex) {
      state = DriverRideState.error(ex.toString());
    }
  }

  void updateInTrip(RideRequest rideRequest) {
    state = DriverRideState.inTrip(rideRequest);
  }

  void backToInit() {
    state = const DriverRideState.init();
  }

  Future<void> updateDriverId(
    String tixId,
  ) async {
    final credentials = _repository.getPrivateKey();
    final driverAddress = await _crypto.getPublicAddress(credentials!);
    await FireHelper.updateRideRequest(
      tixId,
      {
        "driver_id": driverAddress.hexEip55,
        "status": Strings.accepted,
      },
    );
  }
}

final driverRideProvider = StateNotifierProvider<DriverRideVM, DriverRideState>(
    (ref) => DriverRideVM(ref.read));
