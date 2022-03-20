import 'dart:typed_data';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/abi/RideFee.g.dart';
import 'package:ride/services/ride/ride_hub.dart';

class RideFeeService {
  RideFeeService(Reader read) : _rideHub = read(rideHubProvider) {
    _rideFee = RideFee(
      address: _rideHub.rideHubAddress,
      client: _rideHub.web3Client,
    );
  }

  final RideHubService _rideHub;
  late RideFee _rideFee;

  Future<BigInt> getFare(Uint8List keyLocal, BigInt badge,
      BigInt metresTravelled, BigInt minutesTaken) async {
    final fare =
        await _rideFee.getFare(keyLocal, badge, minutesTaken, metresTravelled);
    return fare;
  }

  Future<BigInt> getCancellationFee(Uint8List keyPay) async {
    return await _rideFee.getCancellationFee(keyPay);
  }
}

final rideFeeProvider = Provider<RideFeeService>((ref) {
  return RideFeeService(ref.read);
});
