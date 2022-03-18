import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/services/ride/ride_hub.dart';
import 'package:web3dart/web3dart.dart';

import 'package:ride/abi/RideOwnership.g.dart';

class RideOwnershipService {
  RideOwnershipService(Reader read) : _rideHub = read(rideHubProvider) {
    _rideOwnership = RideOwnership(
        address: _rideHub.rideHubAddress, client: _rideHub.web3Client);
  }

  final RideHubService _rideHub;
  late RideOwnership _rideOwnership;

  Future<EthereumAddress> getOwner() async {
    return await _rideOwnership.owner();
  }
}

final rideOwnershipProvider = Provider<RideOwnershipService>((ref) {
  return RideOwnershipService(ref.read);
});
