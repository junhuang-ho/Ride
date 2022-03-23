import 'package:flutter/material.dart';
import 'package:ride/widgets/ride_details_content.dart';

class RideDetailsCard extends StatelessWidget {
  const RideDetailsCard({
    Key? key,
    required this.distanceText,
    required this.durationText,
    required this.fare,
    required this.pickupAddress,
    required this.destAddress,
  }) : super(key: key);

  final String distanceText;
  final String durationText;
  final BigInt fare;
  final String pickupAddress;
  final String destAddress;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(0),
      contentPadding: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      content: Card(
        elevation: 10.0,
        margin: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Theme.of(context).bottomAppBarColor,
        child: RideDetailsContent(
          distanceText: distanceText,
          durationText: durationText,
          fare: fare,
          pickupAddress: pickupAddress,
          destAddress: destAddress,
        ),
      ),
    );
  }
}
