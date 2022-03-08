import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/abi/RideBadge.g.dart';
import 'package:ride/models/driver_reputation.dart';
import 'package:ride/services/ride/ride_hub.dart';
import 'package:web3dart/web3dart.dart';

class RideBadgeService {
  RideBadgeService(Reader read) : _rideHub = read(rideHubProvider) {
    _rideBadge = RideBadge(
        address: _rideHub.rideHubAddress, client: _rideHub.web3Client);
  }

  final RideHubService _rideHub;
  late RideBadge _rideBadge;

  Future<DriverReputation> getDriverReputation(
      EthereumAddress driverAddress) async {
    List<dynamic> resultInRawArray =
        await _rideBadge.getDriverToDriverReputation(driverAddress);
    return DriverReputation.parseRaw(resultInRawArray);
  }
}

final rideBadgeProvider = Provider<RideBadgeService>((ref) {
  return RideBadgeService(ref.read);
});
