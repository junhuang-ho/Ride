import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/abi/RideBadge.g.dart';
import 'package:ride/services/ride/ride_hub.dart';
import 'package:web3dart/web3dart.dart';

class RideBadgeService {
  late RideBadge _rideBadge;

  RideBadgeService(
      {required EthereumAddress rideHubAddress,
      required Web3Client web3Client}) {
    _rideBadge = RideBadge(address: rideHubAddress, client: web3Client);
  }
}

final rideBadgeProvider = Provider<RideBadgeService>((ref) {
  final rideHub = ref.watch(rideHubProvider);

  return RideBadgeService(
    rideHubAddress: rideHub.rideHubAddress,
    web3Client: rideHub.web3Client,
  );
});
