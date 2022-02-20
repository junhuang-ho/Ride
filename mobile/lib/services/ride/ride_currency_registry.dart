import 'dart:typed_data';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/abi/RideCurrencyRegistry.g.dart';
import 'package:ride/services/ride/ride_hub.dart';
import 'package:web3dart/web3dart.dart';

class RideCurrencyRegistryService {
  late RideCurrencyRegistry _rideCurrencyRegistry;
  final Credentials _credentials;
  final EthereumAddress _wethAddress;

  RideCurrencyRegistryService({
    required Credentials credentials,
    required EthereumAddress rideHubAddress,
    required EthereumAddress wethAddress,
    required Web3Client web3Client,
  })  : _credentials = credentials,
        _wethAddress = wethAddress {
    _rideCurrencyRegistry =
        RideCurrencyRegistry(address: rideHubAddress, client: web3Client);
  }

  Future<Uint8List> getKeyFiat() async {
    final key = await _rideCurrencyRegistry.getKeyFiat('USD');
    return key;
  }

  Future<Uint8List> getKeyCrypto() async {
    final key = await _rideCurrencyRegistry.getKeyCrypto(_wethAddress);
    return key;
  }
}

final rideCurrencyRegistryProvider =
    Provider<RideCurrencyRegistryService>((ref) {
  final rideHub = ref.watch(rideHubProvider);

  return RideCurrencyRegistryService(
    credentials: rideHub.credentials,
    rideHubAddress: rideHub.rideHubAddress,
    wethAddress: rideHub.wethAddress,
    web3Client: rideHub.web3Client,
  );
});
