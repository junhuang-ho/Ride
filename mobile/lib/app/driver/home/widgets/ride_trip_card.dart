import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/app/driver/trip/driver.trip.vm.dart';
import 'package:ride/app/driver/widgets/ride_button.dart';
import 'package:ride/models/ride_request.dart';
import 'package:ride/utils/constants.dart';
import 'package:ride/utils/ride_colors.dart';
import 'package:ride/widgets/common_sheet.dart';
import 'package:ride/widgets/ride_details_content.dart';

class RideTripCard extends HookConsumerWidget {
  const RideTripCard({
    Key? key,
    required this.rideRequest,
  }) : super(key: key);

  final RideRequest rideRequest;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CommonSheet(
      sheetHeight: MediaQuery.of(context).size.height * .5,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Theme.of(context).bottomAppBarColor,
        child: Container(
          margin: const EdgeInsets.all(4),
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RideDetailsContent(
                userId: rideRequest.passengerId,
                distanceText: rideRequest.distanceText,
                durationText: rideRequest.durationText,
                fare: rideRequest.tripFare,
                pickupAddress: rideRequest.pickupAddress,
                destAddress: rideRequest.destinationAddress,
              ),
              if (rideRequest.status == Strings.accepted)
                RideButton(
                  title: 'Start Trip',
                  color: RideColors.colorAccentPurple,
                  onPressed: () {
                    ref
                        .read(driverTripProvider.notifier)
                        .pickingUp(rideRequest);
                    context.go('/driver/trip');
                  },
                ),
              if (rideRequest.status == Strings.arrived ||
                  rideRequest.status == Strings.ontrip ||
                  rideRequest.status == Strings.destReached ||
                  rideRequest.status == Strings.destNotReached ||
                  rideRequest.status == Strings.paxAgreed ||
                  rideRequest.status == Strings.paxDisagreed)
                RideButton(
                  title: 'Continue Trip',
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
      ),
    );
  }
}
