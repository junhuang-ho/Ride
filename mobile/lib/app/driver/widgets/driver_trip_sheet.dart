import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/app/driver/trip/driver.trip.vm.dart';
import 'package:ride/app/driver/widgets/qrcode_sheet.dart';
import 'package:ride/app/driver/widgets/taxi_button.dart';
import 'package:ride/app/passenger/home/passenger.ride.vm.dart';
import 'package:ride/utils/constants.dart';
import 'package:ride/widgets/common_sheet.dart';
import 'package:ride/models/ride_request.dart';
import 'package:ride/utils/ride_colors.dart';
import 'package:ride/widgets/empty_content.dart';

class DriverTripSheet extends HookConsumerWidget {
  const DriverTripSheet({
    Key? key,
    required this.tripSheetHeight,
  }) : super(key: key);

  final double tripSheetHeight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final acceptedRideRequest = ref.watch(driverTripProvider.notifier
        .select((driverTripVM) => driverTripVM.acceptedRideRequest));

    AsyncValue<DatabaseEvent> requestedRideRequest =
        ref.watch(rideRequestProvider(acceptedRideRequest.tixId));

    return CommonSheet(
      sheetHeight: tripSheetHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          children: <Widget>[
            Text(
              acceptedRideRequest.destinationAddress,
              style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Brand-Bold',
                  color: RideColors.colorAccentPurple),
            ),
            const SizedBox(height: 15),
            requestedRideRequest.when(
              loading: () => const CircularProgressIndicator(),
              error: (err, stack) => EmptyContent(
                title: 'Something Goes Wrong',
                message: err.toString(),
              ),
              data: (dbEvent) {
                final rawRideRequest = dbEvent.snapshot.value;
                if (rawRideRequest == null) {
                  return const Text('Ride Request Not Found');
                }
                final rideRequest = RideRequest.parseRaw(rawRideRequest);
                if (rideRequest.status == Strings.arrived) {
                  return const ArrivedContent();
                } else if (rideRequest.status == Strings.ontrip ||
                    rideRequest.status == Strings.paxDisagreed) {
                  return const OnTripContent();
                } else if (rideRequest.status == Strings.destReached ||
                    rideRequest.status == Strings.destNotReached) {
                  return const Text('Pending Passenger Agreement...');
                } else if (rideRequest.status == Strings.paxAgreed) {
                  return const PaxAgreedContent();
                } else {
                  return Text('Ride Request Status: ${rideRequest.status}');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ArrivedContent extends HookConsumerWidget {
  const ArrivedContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TaxiButton(
            title: 'Show QR Code',
            color: Colors.green,
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => const QRCodeSheet(),
              );
            },
          ),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TaxiButton(
            title: 'Cancel Trip',
            color: Colors.orange,
            onPressed: () async {
              await ref.read(driverTripProvider.notifier).cancelPickUp();
            },
          ),
        ),
      ],
    );
  }
}

class OnTripContent extends HookConsumerWidget {
  const OnTripContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TaxiButton(
            title: 'Destination Reached',
            color: Colors.green,
            onPressed: () async {
              await ref
                  .read(driverTripProvider.notifier)
                  .destinationReached(true);
            },
          ),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TaxiButton(
            title: 'Destination Not Reached',
            color: Colors.orange,
            onPressed: () async {
              await ref
                  .read(driverTripProvider.notifier)
                  .destinationReached(false);
            },
          ),
        ),
      ],
    );
  }
}

class PaxAgreedContent extends HookConsumerWidget {
  const PaxAgreedContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('Hooray, passenger agreed!'),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TaxiButton(
            title: 'Complete Trip',
            color: Colors.orange,
            onPressed: () async {
              await ref.read(driverTripProvider.notifier).completeTrip();
            },
          ),
        ),
      ],
    );
  }
}
