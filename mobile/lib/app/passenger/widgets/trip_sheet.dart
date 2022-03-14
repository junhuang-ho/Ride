import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/app/passenger/trip/passenger.trip.vm.dart';
import 'package:ride/models/ride_request.dart';
import 'package:ride/widgets/common_sheet.dart';

class TripSheet extends HookConsumerWidget {
  const TripSheet({
    Key? key,
    required this.tripSheetHeight,
    required this.rideRequest,
  }) : super(key: key);

  final double tripSheetHeight;
  final RideRequest? rideRequest;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passengerTrip = ref.watch(passengerTripProvider);

    // AsyncValue<DatabaseEvent> requestedRideRequest =
    //     ref.watch(rideRequestProvider(rideRequest?.tixId));

    return CommonSheet(
      sheetHeight: tripSheetHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 5),
            passengerTrip.maybeWhen(
              startingTrip: () => Column(
                children: const [
                  Text(
                    'Starting Trip...',
                    style: TextStyle(fontSize: 18, fontFamily: 'Brand-Bold'),
                  ),
                  CircularProgressIndicator(),
                ],
              ),
              onTheWay: (_) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'On The Way',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontFamily: 'Brand-Bold'),
                  ),
                ],
              ),
              orElse: () => const SizedBox(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
