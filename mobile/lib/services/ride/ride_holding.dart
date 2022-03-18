import 'dart:typed_data';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/abi/RideHolding.g.dart';
import 'package:ride/services/ride/ride_hub.dart';
import 'package:web3dart/web3dart.dart';

class RideHoldingService {
  RideHoldingService(Reader read) : _rideHub = read(rideHubProvider) {
    _rideHolding = RideHolding(
        address: _rideHub.rideHubAddress, client: _rideHub.web3Client);
  }

  final RideHubService _rideHub;
  late RideHolding _rideHolding;

  Future<BigInt> getHolding(EthereumAddress user, Uint8List key) async {
    return await _rideHolding.getHolding(user, key);
  }

  Future<String?> depositTokens(Uint8List keyPay, BigInt depositAmount) async {
    final transactionId = await _rideHolding.depositTokens(
        keyPay, depositAmount,
        credentials: _rideHub.credentials);
    return transactionId;
  }

  Future<String?> withdrawTokens(
      Uint8List keyPay, BigInt withdrawalAmount) async {
    final transactionId = await _rideHolding.withdrawTokens(
        keyPay, withdrawalAmount,
        credentials: _rideHub.credentials);
    return transactionId;
  }
}

final rideHoldingProvider = Provider<RideHoldingService>((ref) {
  return RideHoldingService(ref.read);
});
