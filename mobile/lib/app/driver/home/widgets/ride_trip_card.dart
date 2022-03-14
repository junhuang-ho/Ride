import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/app/driver/trip/driver.trip.vm.dart';
import 'package:ride/app/driver/widgets/taxi_button.dart';
import 'package:ride/models/ride_request.dart';
import 'package:ride/utils/constants.dart';
import 'package:ride/utils/ride_colors.dart';

class RideTripCard extends HookConsumerWidget {
  const RideTripCard({
    Key? key,
    required this.rideRequest,
  }) : super(key: key);

  final RideRequest rideRequest;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Theme.of(context).bottomAppBarColor,
      child: Container(
        margin: const EdgeInsets.all(4),
        height: 200,
        child: Column(
          children: [
            ListTile(
              title: Text(rideRequest.destinationAddress),
              subtitle: Text(
                'from: ${rideRequest.pickupAddress} ${rideRequest.tixId}',
              ),
            ),
            const SizedBox(height: 10),
            if (rideRequest.status == Strings.accepted)
              TaxiButton(
                title: 'START TRIP',
                color: RideColors.colorAccentPurple,
                onPressed: () {
                  ref.read(driverTripProvider.notifier).pickingUp(rideRequest);
                  context.go('/driver/trip');
                },
              ),
            if (rideRequest.status == Strings.arrived ||
                rideRequest.status == Strings.ontrip ||
                rideRequest.status == Strings.destReached ||
                rideRequest.status == Strings.destNotReached ||
                rideRequest.status == Strings.paxAgreed ||
                rideRequest.status == Strings.paxDisagreed)
              TaxiButton(
                title: 'CONTINUE TRIP',
                color: RideColors.colorAccentPurple,
                onPressed: () {
                  ref
                      .read(driverTripProvider.notifier)
                      .updateOnTheWay(rideRequest);
                  context.go('/driver/trip');
                },
              ),
          ],
        ),
      ),
    );
  }
}
