import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/app/driver/trip/driver.trip.vm.dart';
import 'package:ride/app/driver/widgets/taxi_button.dart';
import 'package:ride/widgets/common_sheet.dart';
import 'package:ride/utils/ride_colors.dart';

class PickupSheet extends HookConsumerWidget {
  const PickupSheet({
    Key? key,
    required this.pickupSheetHeight,
  }) : super(key: key);

  final double pickupSheetHeight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final acceptedRideRequest = ref.watch(driverTripProvider.notifier
        .select((driverTripVM) => driverTripVM.acceptedRideRequest));

    return CommonSheet(
      sheetHeight: pickupSheetHeight,
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
            Consumer(
              builder: (context, ref, _) {
                final driverTrip = ref.watch(driverTripProvider);

                return driverTrip.maybeWhen(
                  arriving: () => const CircularProgressIndicator(),
                  orElse: () => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TaxiButton(
                      title: 'Arrived',
                      color: Colors.green,
                      onPressed: () {
                        ref.read(driverTripProvider.notifier).arrived();
                      },
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TaxiButton(
                title: 'Cancel Pick Up',
                color: Colors.orange,
                onPressed: () async {
                  await ref.read(driverTripProvider.notifier).cancelPickUp();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
