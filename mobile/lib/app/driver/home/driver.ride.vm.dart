import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hex/hex.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/abi/RideDriver.g.dart';
import 'package:ride/models/ride_request.dart';
import 'package:ride/services/ride/ride_currency_registry.dart';
import 'package:ride/services/ride/ride_driver.dart';
import 'package:ride/utils/constants.dart';
import 'package:ride/utils/fire_helper.dart';
import 'package:web3dart/web3dart.dart';

part 'driver.ride.vm.freezed.dart';

@freezed
class DriverRideState with _$DriverRideState {
  const factory DriverRideState.error(String? message) = _DriverRideError;
  const factory DriverRideState.init() = _DriverRideInit;
  const factory DriverRideState.accepting() = _DriverRideAccepting;
  const factory DriverRideState.accepted(RideRequest rideRequest) =
      _DriverRideAccepted;
  const factory DriverRideState.inTrip(RideRequest rideRequest) =
      _DriverRideInTrip;
}

class DriverRideVM extends StateNotifier<DriverRideState> {
  DriverRideVM(Reader read)
      : _rideDriver = read(rideDriverProvider),
        _rideCurrencyRegistry = read(rideCurrencyRegistryProvider),
        super(const DriverRideState.init());

  final RideDriverService _rideDriver;
  final RideCurrencyRegistryService _rideCurrencyRegistry;

  Future<void> acceptRideRequest(RideRequest rideRequest, String badge) async {
    try {
      state = const DriverRideState.accepting();
      final keyLocal = await _rideCurrencyRegistry.getKeyFiat();
      final keyAccept = await _rideCurrencyRegistry.getKeyCrypto();
      final useBadge = BigInt.parse(badge);
      final decodedTixId = Uint8List.fromList(HEX.decode(rideRequest.tixId));
      await _rideDriver.acceptTicket(
          keyLocal, keyAccept, decodedTixId, useBadge);
      state = DriverRideState.accepted(rideRequest);
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
    Uint8List? tixId,
    EthereumAddress driverAddress,
    RideRequest rideRequest,
  ) async {
    if (tixId == null) {
      state = const DriverRideState.error('Sorry, ticket ID not found.');
      return;
    }

    try {
      final encodedTixId = HEX.encode(tixId);
      await FireHelper.updateRideRequest(
        encodedTixId,
        {
          "driver_id": driverAddress.hexEip55,
          "status": Strings.accepted,
        },
      );
      rideRequest.status = Strings.accepted;
      updateInTrip(rideRequest);
    } catch (ex) {
      state = DriverRideState.error(ex.toString());
    }
  }
}

final driverRideProvider =
    StateNotifierProvider.autoDispose<DriverRideVM, DriverRideState>(
        (ref) => DriverRideVM(ref.read));

final acceptedTicketEventProvider = StreamProvider<AcceptedTicket>((ref) {
  final rideDriver = ref.watch(rideDriverProvider);

  return rideDriver.rideDriver.acceptedTicketEvents();
});
