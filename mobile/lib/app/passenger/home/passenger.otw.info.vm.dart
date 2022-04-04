import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hex/hex.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/app/auth/auth.vm.dart';
import 'package:ride/models/driver_reputation.dart';
import 'package:ride/models/ticket.dart';
import 'package:ride/services/ride/ride_badge.dart';
import 'package:ride/services/ride/ride_ticket.dart';
import 'package:web3dart/web3dart.dart';

part 'passenger.otw.info.vm.freezed.dart';

@freezed
class PassengerOnTheWayInput with _$PassengerOnTheWayInput {
  const factory PassengerOnTheWayInput({
    required final String driverAddress,
    required final String tixId,
  }) = _PassengerOnTheWayInput;
}

@freezed
class PassengerOnTheWayInfoState with _$PassengerOnTheWayInfoState {
  const factory PassengerOnTheWayInfoState.error(String? message) =
      _PassengerOnTheWayInfoError;
  const factory PassengerOnTheWayInfoState.init() = _PassengerOnTheWayInfoInit;
  const factory PassengerOnTheWayInfoState.loading() =
      _PassengerOnTheWayInfoLoading;
  const factory PassengerOnTheWayInfoState.data(
          DriverReputation driverReputation, Ticket ticket) =
      _PassengerOnTheWayInfoData;
}

class PassengerOnTheWayInfoVM
    extends StateNotifier<PassengerOnTheWayInfoState> {
  PassengerOnTheWayInfoVM(Reader read, this.input)
      : _rideBadge = read(rideBadgeProvider),
        _rideTicket = read(rideTicketProvider),
        super(const PassengerOnTheWayInfoState.init()) {
    getOnTheWayInfo();
  }

  final PassengerOnTheWayInput input;
  final RideBadgeService _rideBadge;
  final RideTicketService _rideTicket;

  Future<void> getOnTheWayInfo() async {
    try {
      state = const PassengerOnTheWayInfoState.loading();
      final driverReputation = await _rideBadge
          .getDriverReputation(EthereumAddress.fromHex(input.driverAddress));
      final ticket = await _rideTicket
          .getTicket(Uint8List.fromList(HEX.decode(input.tixId)));
      state = PassengerOnTheWayInfoState.data(driverReputation, ticket);
    } catch (ex) {
      if (mounted) {
        state = PassengerOnTheWayInfoState.error(ex.toString());
      }
    }
  }
}

final passengerOnTheWayInfoProvider = StateNotifierProvider.family<
    PassengerOnTheWayInfoVM,
    PassengerOnTheWayInfoState,
    PassengerOnTheWayInput>((ref, input) {
  ref.watch(authProvider);
  return PassengerOnTheWayInfoVM(ref.read, input);
});
