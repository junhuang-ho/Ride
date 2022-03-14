import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/abi/RidePassenger.g.dart';
import 'package:ride/services/ride/ride_passenger.dart';

final requestTicketEventProvider = StreamProvider<RequestTicket>((ref) {
  final ridePassenger = ref.watch(ridePassengerProvider);

  return ridePassenger.ridePassenger.requestTicketEvents();
});
