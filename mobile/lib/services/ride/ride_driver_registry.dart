import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:web3dart/web3dart.dart';

import 'package:ride/abi/RideDriverRegistry.g.dart';
import 'package:ride/services/ride/ride_hub.dart';

class RideDriverRegistryService {
  late RideDriverRegistry _rideDriverRegistry;
  final Credentials _credentials;

  RideDriverRegistryService({
    required Credentials credentials,
    required EthereumAddress rideHubAddress,
    required Web3Client web3Client,
  }) : _credentials = credentials {
    _rideDriverRegistry =
        RideDriverRegistry(address: rideHubAddress, client: web3Client);
  }

  Future<String?> approveApplicant(
    EthereumAddress driverAddress,
    String uri,
  ) async {
    final transactionId = await _rideDriverRegistry
        .approveApplicant(driverAddress, uri, credentials: _credentials);
    return transactionId;
  }

  Future<String?> registerAsDriver(BigInt maxMetresPerTrip) async {
    final transactionId = await _rideDriverRegistry
        .registerAsDriver(maxMetresPerTrip, credentials: _credentials);

    return transactionId;
  }

  Future<String?> updateMaxMetresPerTrip(BigInt maxMetresPerTrip) async {
    final transactionId = await _rideDriverRegistry.updateMaxMetresPerTrip(
        maxMetresPerTrip,
        credentials: _credentials,
        transaction: Transaction(
            gasPrice: EtherAmount.fromUnitAndValue(EtherUnit.gwei, 1)));
    return transactionId;
  }
}

final rideDriverRegistryProvider = Provider<RideDriverRegistryService>((ref) {
  final rideHub = ref.watch(rideHubProvider);

  return RideDriverRegistryService(
    credentials: rideHub.credentials,
    rideHubAddress: rideHub.rideHubAddress,
    web3Client: rideHub.web3Client,
  );
});
