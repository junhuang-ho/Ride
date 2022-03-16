import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/app/driver/widgets/taxi_button.dart';
import 'package:ride/app/driver/widgets/taxi_outlined_button.dart';
import 'package:ride/app/passenger/trip/passenger.trip.vm.dart';
import 'package:ride/models/ride_request.dart';
import 'package:ride/utils/constants.dart';
import 'package:ride/utils/ride_colors.dart';

class AgreementSheet extends HookConsumerWidget {
  const AgreementSheet({
    Key? key,
    required this.rideRequest,
  }) : super(key: key);

  final RideRequest rideRequest;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black26,
              blurRadius: 15,
              spreadRadius: .5,
              offset: Offset(0.7, 0.7))
        ],
      ),
      height: 220,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            Text(
              'Are you agree that Destination${rideRequest.status == Strings.destReached ? '' : ' Not'} Reached?',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontFamily: 'Brand-Bold',
                color: Color(0xFF383635),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: <Widget>[
                Expanded(
                  child: TaxiOutlinedButton(
                    title: 'DISAGREE',
                    color: Colors.red,
                    onPressed: () async {
                      await ref
                          .read(passengerTripProvider.notifier)
                          .endTrip(false, 4);
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TaxiButton(
                    color: RideColors.colorGreen,
                    title: 'AGREE',
                    onPressed: () async {
                      await ref
                          .read(passengerTripProvider.notifier)
                          .endTrip(true, 4);
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
