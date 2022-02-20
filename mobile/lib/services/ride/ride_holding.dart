import 'dart:typed_data';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/abi/RideHolding.g.dart';
import 'package:ride/services/ride/ride_hub.dart';
import 'package:web3dart/web3dart.dart';

class RideHoldingService {
  late RideHolding _rideHolding;
  final Credentials _credentials;

  RideHoldingService({
    required Credentials credentials,
    required EthereumAddress rideHubAddress,
    required Web3Client web3Client,
  }) : _credentials = credentials {
    _rideHolding = RideHolding(address: rideHubAddress, client: web3Client);
  }

  Future<BigInt> getHolding(EthereumAddress user, Uint8List key) async {
    return await _rideHolding.getHolding(user, key);
  }

  Future<String?> depositTokens(Uint8List keyPay, BigInt depositAmount) async {
    final transactionId = await _rideHolding
        .depositTokens(keyPay, depositAmount, credentials: _credentials);
    return transactionId;
  }
}

final rideHoldingProvider = Provider<RideHoldingService>((ref) {
  final rideHub = ref.watch(rideHubProvider);

  return RideHoldingService(
    credentials: rideHub.credentials,
    rideHubAddress: rideHub.rideHubAddress,
    web3Client: rideHub.web3Client,
  );
});
