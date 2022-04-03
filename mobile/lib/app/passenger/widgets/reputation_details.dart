import 'package:flutter/material.dart';
import 'package:ride/utils/ride_colors.dart';

class ReputationDetails extends StatelessWidget {
  const ReputationDetails({
    Key? key,
    required this.metresTravelled,
    required this.tripCompleted,
    required this.rating,
  }) : super(key: key);

  final BigInt metresTravelled;
  final BigInt tripCompleted;
  final double rating;

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
              'Driver Reputation',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w200,
              ),
            ),
            const SizedBox(height: 2),
            const Divider(color: RideColors.primaryColor),
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Travelled',
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      '${(metresTravelled / BigInt.from(1000)).toStringAsFixed(2)} KM',
                      style: const TextStyle(
                        fontSize: 20,
                        color: RideColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Rating',
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      rating.toStringAsFixed(2),
                      style: const TextStyle(
                        fontSize: 20,
                        color: RideColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Trips',
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      '$tripCompleted',
                      style: const TextStyle(
                        fontSize: 20,
                        color: RideColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
