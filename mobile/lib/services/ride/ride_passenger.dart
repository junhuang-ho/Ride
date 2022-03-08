import 'dart:typed_data';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/abi/RidePassenger.g.dart';
import 'package:ride/services/ride/ride_hub.dart';
import 'package:web3dart/web3dart.dart';

class RidePassengerService {
  RidePassengerService(Reader read) : _rideHub = read(rideHubProvider) {
    _ridePassenger = RidePassenger(
        address: _rideHub.rideHubAddress, client: _rideHub.web3Client);
    _ridePassenger.requestTicketEvents().listen((event) {
      print('Tix ID: ${event.tixId}');
      print('Sender: ${event.sender}');
    });
    // _ridePassenger.requestCancelledEvents().listen((event) {
    //   print('Tix ID: ${event.tixId}');
    //   print('Sender: ${event.sender}');
    // });
  }

  final RideHubService _rideHub;
  late RidePassenger _ridePassenger;

  RidePassenger get ridePassenger => _ridePassenger;

  Future<String?> requestTicket(Uint8List keyLocal, Uint8List keyPay,
      BigInt badge, bool strict, BigInt metres, BigInt minutes) async {
    final transactionId = await _ridePassenger.requestTicket(
      keyLocal,
      keyPay,
      badge,
      strict,
      metres,
      minutes,
      credentials: _rideHub.credentials,
      transaction: Transaction(
        gasPrice: EtherAmount.fromUnitAndValue(EtherUnit.gwei, 50),
      ),
    );
    return transactionId;
  }

  Future<String?> cancelRequest() async {
    final transactionId = await _ridePassenger.cancelRequest(
      credentials: _rideHub.credentials,
      transaction: Transaction(
        gasPrice: EtherAmount.fromUnitAndValue(EtherUnit.gwei, 50),
      ),
    );
    return transactionId;
  }

  Future<String?> startTrip(EthereumAddress driver) async {
    final transactionId = await _ridePassenger.startTrip(
      driver,
      credentials: _rideHub.credentials,
      transaction: Transaction(
        gasPrice: EtherAmount.fromUnitAndValue(EtherUnit.gwei, 50),
      ),
    );
    return transactionId;
  }

  Future<String?> endTrip(bool agreed, BigInt rating) async {
    final transactionId = await _ridePassenger.endTripPax(
      agreed,
      rating,
      credentials: _rideHub.credentials,
      transaction: Transaction(
        gasPrice: EtherAmount.fromUnitAndValue(EtherUnit.gwei, 50),
      ),
    );
    return transactionId;
  }

  Future<String?> forceEndTrip() async {
    final transactionId = await _ridePassenger.forceEndPax(
      credentials: _rideHub.credentials,
      transaction: Transaction(
        gasPrice: EtherAmount.fromUnitAndValue(EtherUnit.gwei, 50),
      ),
    );
    return transactionId;
  }
}

final ridePassengerProvider = Provider<RidePassengerService>((ref) {
  return RidePassengerService(ref.read);
});
