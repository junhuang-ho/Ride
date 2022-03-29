import 'dart:typed_data';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/abi/RideExchange.g.dart';
import 'package:ride/services/ride/ride_hub.dart';

class RideExchangeService {
  RideExchangeService(Reader read) : _rideHub = read(rideHubProvider) {
    _rideExchange = RideExchange(
        address: _rideHub.rideHubAddress, client: _rideHub.web3Client);
  }

  final RideHubService _rideHub;
  late RideExchange _rideExchange;

  Future<BigInt> convertCurrency(
      Uint8List keyX, Uint8List keyY, BigInt amount) async {
    final convertedAmount =
        await _rideExchange.convertCurrency(keyX, keyY, amount);
    return convertedAmount;
  }
}

final rideExchangeProvider = Provider<RideExchangeService>((ref) {
  return RideExchangeService(ref.read);
});
