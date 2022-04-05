import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/app/driver/home/driver.ride.vm.dart';
import 'package:ride/app/driver/widgets/ride_button.dart';
import 'package:ride/models/ride_request.dart';
import 'package:ride/utils/ride_colors.dart';
import 'package:ride/widgets/ride_details_content.dart';

class RideRequestCard extends HookConsumerWidget {
  const RideRequestCard({
    Key? key,
    required this.rideRequest,
  }) : super(key: key);

  final RideRequest rideRequest;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final useBadge = useState<int>(0);

    return Card(
      elevation: 5.0,
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: RideColors.cardColor,
      child: Container(
        margin: const EdgeInsets.all(4),
        child: Column(
          children: [
            RideDetailsContent(
              userId: rideRequest.passengerId,
              distanceText: rideRequest.distanceText,
              durationText: rideRequest.durationText,
              fare: rideRequest.tripFare,
              pickupAddress: rideRequest.pickupAddress,
              destAddress: rideRequest.destinationAddress,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: RideButton(
                title: 'ACCEPT',
                color: RideColors.primaryColor,
                onPressed: () async {
                  await ref.read(driverRideProvider.notifier).acceptRideRequest(
                      rideRequest, useBadge.value.toString());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
