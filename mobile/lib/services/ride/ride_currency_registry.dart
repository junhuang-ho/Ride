import 'dart:typed_data';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/abi/RideCurrencyRegistry.g.dart';
import 'package:ride/services/ride/ride_hub.dart';

class RideCurrencyRegistryService {
  RideCurrencyRegistryService(Reader read) : _rideHub = read(rideHubProvider) {
    _rideCurrencyRegistry = RideCurrencyRegistry(
        address: _rideHub.rideHubAddress, client: _rideHub.web3Client);
  }

  final RideHubService _rideHub;
  late RideCurrencyRegistry _rideCurrencyRegistry;

  Future<Uint8List> getKeyFiat() async {
    final key = await _rideCurrencyRegistry.getKeyFiat('USD');
    return key;
  }

  Future<Uint8List> getKeyCrypto() async {
    final key = await _rideCurrencyRegistry.getKeyCrypto(_rideHub.wethAddress);
    return key;
  }
}

final rideCurrencyRegistryProvider =
    Provider<RideCurrencyRegistryService>((ref) {
  return RideCurrencyRegistryService(ref.read);
});
