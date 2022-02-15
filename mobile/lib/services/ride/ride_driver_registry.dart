import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:web3dart/web3dart.dart';

import 'package:ride/abi/RideDriverRegistry.g.dart';
import 'package:ride/services/ride/ride_hub.dart';

class RideDriverRegistryService {
  late RideDriverRegistry _rideDriverRegistry;

  RideDriverRegistryService(
      {required EthereumAddress rideHubAddress,
      required Web3Client web3Client}) {
    _rideDriverRegistry =
        RideDriverRegistry(address: rideHubAddress, client: web3Client);
  }
}

final rideDriverRegistryProvider = Provider<RideDriverRegistryService>((ref) {
  final rideHub = ref.watch(rideHubProvider);

  return RideDriverRegistryService(
    rideHubAddress: rideHub.rideHubAddress,
    web3Client: rideHub.web3Client,
  );
});
