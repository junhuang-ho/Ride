import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/abi/RideBadge.g.dart';
import 'package:ride/models/driver_reputation.dart';
import 'package:ride/services/ride/ride_hub.dart';
import 'package:web3dart/web3dart.dart';

class RideBadgeService {
  late RideBadge _rideBadge;
  final Credentials _credentials;

  RideBadgeService(
      {required Credentials credentials,
      required EthereumAddress rideHubAddress,
      required Web3Client web3Client})
      : _credentials = credentials {
    _rideBadge = RideBadge(address: rideHubAddress, client: web3Client);
  }

  Future<DriverReputation> getDriverReputation(
      EthereumAddress driverAddress) async {
    List<dynamic> resultInRawArray =
        await _rideBadge.getDriverToDriverReputation(driverAddress);
    return DriverReputation.parseRaw(resultInRawArray);
  }
}

final rideBadgeProvider = Provider<RideBadgeService>((ref) {
  final rideHub = ref.watch(rideHubProvider);

  return RideBadgeService(
    credentials: rideHub.credentials,
    rideHubAddress: rideHub.rideHubAddress,
    web3Client: rideHub.web3Client,
  );
});
