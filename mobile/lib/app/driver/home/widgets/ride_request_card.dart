import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:ride/app/driver/home/driver.ride.vm.dart';
import 'package:ride/app/driver/widgets/taxi_button.dart';
import 'package:ride/models/ride_request.dart';
import 'package:ride/utils/ride_colors.dart';

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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Theme.of(context).bottomAppBarColor,
      child: Container(
        margin: const EdgeInsets.all(4),
        child: Column(
          children: [
            ListTile(
              title: Text(rideRequest.destinationAddress),
              subtitle: Text(
                'from: ${rideRequest.pickupAddress} ${rideRequest.tixId}',
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 30,
              width: 30,
              child: NumberPicker(
                zeroPad: true,
                minValue: 0,
                maxValue: 6,
                value: useBadge.value,
                onChanged: (value) {
                  useBadge.value = value;
                },
                textStyle: const TextStyle(fontSize: 18),
                haptics: true,
              ),
            ),
            const SizedBox(height: 10),
            TaxiButton(
              title: 'ACCEPT',
              color: RideColors.colorGreen,
              onPressed: () async {
                await ref
                    .read(driverRideProvider.notifier)
                    .acceptRideRequest(rideRequest, useBadge.value.toString());
              },
            ),
          ],
        ),
      ),
    );
  }
}
