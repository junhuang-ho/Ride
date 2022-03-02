import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:ride/app/driver/widgets/taxi_button.dart';
import 'package:ride/app/passenger/home/passenger.ride.vm.dart';
import 'package:ride/app/passenger/widgets/common_sheet.dart';
import 'package:ride/app/ride/request.ticket.vm.dart';
import 'package:ride/services/crypto.dart';
import 'package:ride/services/ride/ride_passenger.dart';
import 'package:ride/utils/ride_colors.dart';

class DetailsSheet extends HookConsumerWidget {
  const DetailsSheet({
    Key? key,
    required this.detailSheetHeight,
  }) : super(key: key);

  final double detailSheetHeight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passengerRide = ref.watch(passengerRideProvider);

    final badge = useState<int>(0);
    final strict = useState<bool>(false);

    Future<void> _requestRide(int distance, int duration) async {
      await ref.read(requestTicketProvider.notifier).requestTicket(
            badge.value.toString(),
            strict.value,
            BigInt.from(distance),
            BigInt.from(duration),
          );
      final passengerAddress =
          await ref.read(cryptoProvider).getUserPublicAddress();
      ref
          .read(ridePassengerProvider)
          .ridePassenger
          .requestTicketEvents()
          .listen((event) {
        print('Event TIX ID: ${event.tixId}');
        if (event.sender == passengerAddress) {
          ref.read(passengerRideProvider.notifier).requestRide(event.tixId);
        }
      });
    }

    return CommonSheet(
      sheetHeight: detailSheetHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: <Widget>[
                  // Image.asset(
                  //   'images/taxi.png',
                  //   height: 70,
                  //   width: 70,
                  // ),
                  // const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Distance',
                        style:
                            TextStyle(fontSize: 18, fontFamily: 'Brand-Bold'),
                      ),
                      passengerRide.maybeWhen(
                        orElse: () => const SizedBox(),
                        direction: (directionDetails) => Text(
                          directionDetails.distanceText,
                          style: const TextStyle(
                              fontSize: 16, color: RideColors.colorTextLight),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Duration',
                        style:
                            TextStyle(fontSize: 18, fontFamily: 'Brand-Bold'),
                      ),
                      passengerRide.maybeWhen(
                        orElse: () => const SizedBox(),
                        direction: (directionDetails) => Text(
                          directionDetails.durationText,
                          style: const TextStyle(
                              fontSize: 16, color: RideColors.colorTextLight),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: <Widget>[
                  const SizedBox(width: 16),
                  const Icon(
                    Icons.badge,
                    size: 18,
                    color: RideColors.colorTextLight,
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Badge',
                    style: TextStyle(fontSize: 18, fontFamily: 'Brand-Bold'),
                  ),
                  const SizedBox(width: 5),
                  Container(
                    height: 50,
                    width: 30,
                    child: NumberPicker(
                      zeroPad: true,
                      minValue: 0,
                      maxValue: 6,
                      value: badge.value,
                      onChanged: (value) {
                        badge.value = value;
                      },
                      textStyle: const TextStyle(fontSize: 18),
                      haptics: true,
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: RideColors.colorTextLight,
                    size: 16,
                  ),
                  const SizedBox(width: 16),
                  const Icon(
                    Icons.assignment_turned_in,
                    size: 18,
                    color: RideColors.colorTextLight,
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Strict',
                    style: TextStyle(fontSize: 18, fontFamily: 'Brand-Bold'),
                  ),
                  const SizedBox(width: 5),
                  Switch(
                    value: strict.value,
                    onChanged: (value) {
                      strict.value = value;
                    },
                  )
                ],
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Consumer(
                builder: (context, ref, _) {
                  final requestTicketVM = ref.watch(requestTicketProvider);

                  return requestTicketVM.maybeWhen(
                    requesting: () => const CircularProgressIndicator(),
                    orElse: () => TaxiButton(
                      title: 'REQUEST RIDE',
                      color: passengerRide.maybeWhen(
                          direction: (_) => RideColors.colorGreen,
                          orElse: () => Colors.grey),
                      onPressed: passengerRide.maybeWhen(
                        direction: (directionDetails) => () async {
                          await _requestRide(directionDetails.distanceValue,
                              directionDetails.durationValue);
                        },
                        orElse: () => null,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TaxiButton(
                title: 'CANCEL',
                color: Colors.orange,
                onPressed: () async {
                  await ref.read(passengerRideProvider.notifier).cancelRide();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
