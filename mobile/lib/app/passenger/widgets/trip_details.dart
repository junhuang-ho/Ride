import 'package:flutter/material.dart';
import 'package:ride/utils/ride_colors.dart';

class TripDetailsContent extends StatelessWidget {
  const TripDetailsContent({
    Key? key,
    required this.pickupAddress,
    required this.destAddress,
  }) : super(key: key);

  final String pickupAddress;
  final String destAddress;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.all(8.0),
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 2),
            const Text(
              'Trip Details',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w200,
              ),
            ),
            const SizedBox(height: 2),
            const Divider(color: RideColors.primaryColor),
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pickup',
                        style: TextStyle(color: RideColors.lightGrayColor),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        pickupAddress,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  const Divider(),
                  const SizedBox(height: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Destination',
                        style: TextStyle(color: RideColors.lightGrayColor),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        destAddress,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
