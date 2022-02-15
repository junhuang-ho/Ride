import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/services/ride/ride_hub.dart';
import 'package:web3dart/web3dart.dart';

import 'package:ride/abi/RideOwnership.g.dart';

class RideOwnershipService {
  late RideOwnership _rideOwnership;

  RideOwnershipService(
      {required EthereumAddress rideHubAddress,
      required Web3Client web3Client}) {
    _rideOwnership = RideOwnership(address: rideHubAddress, client: web3Client);
  }

  Future<EthereumAddress> getOwner() async {
    return await _rideOwnership.owner();
  }
}

final rideOwnershipProvider = Provider<RideOwnershipService>((ref) {
  final rideHub = ref.watch(rideHubProvider);

  return RideOwnershipService(
    rideHubAddress: rideHub.rideHubAddress,
    web3Client: rideHub.web3Client,
  );
});
