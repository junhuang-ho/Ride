import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:web3dart/web3dart.dart';

import 'package:ride/abi/RideDriverRegistry.g.dart';
import 'package:ride/services/ride/ride_hub.dart';

class RideDriverRegistryService {
  RideDriverRegistryService(Reader read) : _rideHub = read(rideHubProvider) {
    _rideDriverRegistry = RideDriverRegistry(
        address: _rideHub.rideHubAddress, client: _rideHub.web3Client);
  }

  final RideHubService _rideHub;
  late RideDriverRegistry _rideDriverRegistry;

  RideDriverRegistry get rideDriverRegistry => _rideDriverRegistry;

  Future<String?> approveApplicant(
    EthereumAddress driverAddress,
    String uri,
  ) async {
    final transactionId = await _rideDriverRegistry.approveApplicant(
      driverAddress,
      uri,
      credentials: _rideHub.credentials,
      transaction: Transaction(
        gasPrice: EtherAmount.fromUnitAndValue(EtherUnit.gwei, 50),
      ),
    );

    return transactionId;
  }

  Future<String?> registerAsDriver(BigInt maxMetresPerTrip) async {
    final transactionId = await _rideDriverRegistry.registerAsDriver(
      maxMetresPerTrip,
      credentials: _rideHub.credentials,
      transaction: Transaction(
        gasPrice: EtherAmount.fromUnitAndValue(EtherUnit.gwei, 50),
      ),
    );
    return transactionId;
  }

  Future<String?> updateMaxMetresPerTrip(BigInt maxMetresPerTrip) async {
    final transactionId = await _rideDriverRegistry.updateMaxMetresPerTrip(
      maxMetresPerTrip,
      credentials: _rideHub.credentials,
      transaction: Transaction(
        gasPrice: EtherAmount.fromUnitAndValue(EtherUnit.gwei, 50),
      ),
    );
    return transactionId;
  }
}

final rideDriverRegistryProvider = Provider<RideDriverRegistryService>((ref) {
  return RideDriverRegistryService(ref.read);
});
