import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/services/crypto.dart';
import 'package:ride/services/repository.dart';
import 'package:ride/services/ride/ride_currency_registry.dart';
import 'package:ride/services/ride/ride_passenger.dart';
import 'package:ride/services/ride/ride_ticket.dart';

part 'request.ticket.vm.freezed.dart';

@freezed
class RequestTicketState with _$RequestTicketState {
  const factory RequestTicketState.init() = _RequestTicketInit;
  const factory RequestTicketState.requesting() = _RequestTicketRequesting;
  const factory RequestTicketState.requested(String? txnId) =
      _RequestTicketRequested;
  const factory RequestTicketState.cancelling() = _RequestTicketCancelling;
  const factory RequestTicketState.cancelled(String? txnId) =
      _RequestTicketCancelled;
  const factory RequestTicketState.error(String? message) = _RequestTicketError;
  const factory RequestTicketState.loading() = _RequestTicketLoading;
  const factory RequestTicketState.data(String? tixId) = _RequestTicketSuccess;
}

class RequestTicketVM extends StateNotifier<RequestTicketState> {
  RequestTicketVM(Reader read)
      : _ridePassenger = read(ridePassengerProvider),
        _rideTicket = read(rideTicketProvider),
        _rideCurrencyRegistry = read(rideCurrencyRegistryProvider),
        _repository = read(repositoryProvider),
        _crypto = read(cryptoProvider),
        super(const RequestTicketState.init());

  final RidePassengerService _ridePassenger;
  final RideTicketService _rideTicket;
  final RideCurrencyRegistryService _rideCurrencyRegistry;
  final Repository _repository;
  final Crypto _crypto;

  Future<Uint8List?> getTicket() async {
    try {
      // Get the Ticket Id
      final privateKey = _repository.getPrivateKey();
      final userAddress = await _crypto.getPublicAddress(privateKey!);
      final tixId = await _rideTicket.getTixId(userAddress);
      return tixId;
    } catch (ex) {
      state = RequestTicketState.error(ex.toString());
      return null;
    }
  }

  Future<void> requestTicket(
      String badge, bool strict, BigInt metres, BigInt minutes) async {
    try {
      state = const RequestTicketState.requesting();
      // Request Ticket
      final keyLocal = await _rideCurrencyRegistry.getKeyFiat();
      final keyPay = await _rideCurrencyRegistry.getKeyCrypto();
      final parsedBadge = BigInt.parse(badge);
      final txnId = await _ridePassenger.requestTicket(
          keyLocal, keyPay, parsedBadge, strict, metres, minutes);
      state = RequestTicketState.requested(txnId);
    } catch (ex) {
      state = RequestTicketState.error(ex.toString());
    }
  }

  Future<void> cancelRequest() async {
    try {
      state = const RequestTicketState.cancelling();
      await _ridePassenger.cancelRequest();
      state = const RequestTicketState.init();
    } catch (ex) {
      state = RequestTicketState.error(ex.toString());
    }
  }

  void backToInit() {
    state = const RequestTicketState.init();
  }
}

final requestTicketProvider =
    StateNotifierProvider<RequestTicketVM, RequestTicketState>((ref) {
  return RequestTicketVM(ref.read);
});
