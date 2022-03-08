import 'dart:typed_data';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/abi/RideDriver.g.dart';
import 'package:ride/services/ride/ride_hub.dart';
import 'package:web3dart/web3dart.dart';

class RideDriverService {
  RideDriverService(Reader read) : _rideHub = read(rideHubProvider) {
    _rideDriver = RideDriver(
      address: _rideHub.rideHubAddress,
      client: _rideHub.web3Client,
    );
  }

  final RideHubService _rideHub;
  late RideDriver _rideDriver;

  RideDriver get rideDriver => _rideDriver;

  Future<String?> acceptTicket(
    Uint8List keyLocal,
    Uint8List keyAccept,
    Uint8List tixId,
    BigInt useBadge,
  ) async {
    final transactionId = await _rideDriver.acceptTicket(
      keyLocal,
      keyAccept,
      tixId,
      useBadge,
      credentials: _rideHub.credentials,
      transaction: Transaction(
        gasPrice: EtherAmount.fromUnitAndValue(EtherUnit.gwei, 50),
      ),
    );
    return transactionId;
  }

  Future<String?> cancelPickUp() async {
    final transactionId = await _rideDriver.cancelPickUp(
      credentials: _rideHub.credentials,
      transaction: Transaction(
        gasPrice: EtherAmount.fromUnitAndValue(EtherUnit.gwei, 50),
      ),
    );
    return transactionId;
  }

  Future<String?> endTrip(bool reached) async {
    final transactionId = await _rideDriver.endTripDrv(
      reached,
      credentials: _rideHub.credentials,
      transaction: Transaction(
        gasPrice: EtherAmount.fromUnitAndValue(EtherUnit.gwei, 50),
      ),
    );
    return transactionId;
  }

  Future<String?> forceEndTrip() async {
    final transactionId = await _rideDriver.forceEndDrv(
      credentials: _rideHub.credentials,
      transaction: Transaction(
        gasPrice: EtherAmount.fromUnitAndValue(EtherUnit.gwei, 50),
      ),
    );
    return transactionId;
  }
}

final rideDriverProvider = Provider<RideDriverService>((ref) {
  return RideDriverService(ref.read);
});
