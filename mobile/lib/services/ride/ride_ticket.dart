import 'dart:typed_data';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/abi/RideTicket.g.dart';
import 'package:ride/services/ride/ride_hub.dart';
import 'package:web3dart/web3dart.dart';

class RideTicketService {
  RideTicketService(Reader read) : _rideHub = read(rideHubProvider) {
    _rideTicket = RideTicket(
        address: _rideHub.rideHubAddress, client: _rideHub.web3Client);
  }

  final RideHubService _rideHub;
  late RideTicket _rideTicket;

  Future<Uint8List> getTixId(EthereumAddress user) async {
    final tixId = await _rideTicket.getUserToTixId(user);
    return tixId;
  }
}

final rideTicketProvider = Provider<RideTicketService>((ref) {
  return RideTicketService(ref.read);
});
