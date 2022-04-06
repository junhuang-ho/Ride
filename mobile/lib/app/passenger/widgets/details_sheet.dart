import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/app/driver/widgets/ride_button.dart';
import 'package:ride/app/passenger/home/passenger.ride.vm.dart';
import 'package:ride/app/passenger/home/request.ticket.vm.dart';
import 'package:ride/widgets/pending_transaction.dart';
import 'package:ride/models/direction_details.dart';
import 'package:ride/utils/eth_amount_formatter.dart';
import 'package:ride/widgets/common_sheet.dart';
import 'package:ride/services/crypto.dart';
import 'package:ride/services/ride/ride_passenger.dart';
import 'package:ride/utils/ride_colors.dart';
import 'package:ride/widgets/ride_details_card.dart';

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

    Future<void> _requestRide(
        DirectionDetails directionDetails, BigInt tripFare) async {
      await ref.read(requestTicketProvider.notifier).requestTicket(
            badge.value.toString(),
            strict.value,
            BigInt.from(directionDetails.distanceValue),
            BigInt.from(directionDetails.durationValue),
          );
      final passengerAddress =
          await ref.read(cryptoProvider).getUserPublicAddress();
      ref
          .read(ridePassengerProvider)
          .ridePassenger
          .requestTicketEvents()
          .listen((event) {
        if (event.sender == passengerAddress) {
          ref.read(passengerRideProvider.notifier).requestRide(
                event.tixId,
                passengerAddress: event.sender,
                directionDetails: directionDetails,
                tripFare: tripFare,
              );
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
                  Image.asset(
                    'images/taxi.png',
                    height: 70,
                    width: 70,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Duration',
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      passengerRide.maybeWhen(
                        orElse: () => const SpinKitThreeBounce(
                            size: 20.0, color: RideColors.primaryColor),
                        direction: (directionDetails, tripFare) => Text(
                          directionDetails.durationText,
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
                        'Fare',
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      passengerRide.maybeWhen(
                        orElse: () => const SpinKitThreeBounce(
                            size: 20.0, color: RideColors.primaryColor),
                        direction: (directionDetails, tripFare) {
                          return Text(
                            '\$${EthAmountFormatter(tripFare).formatFiat()}',
                            style: const TextStyle(
                                fontSize: 16, color: RideColors.colorTextLight),
                          );
                        },
                      ),
                    ],
                  ),
                  passengerRide.maybeWhen(
                    orElse: () => const SizedBox(),
                    direction: (directionDetails, tripFare) {
                      return IconButton(
                        icon: const Icon(Icons.open_in_new),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) {
                              return RideDetailsCard(
                                distanceText: directionDetails.distanceText,
                                durationText: directionDetails.durationText,
                                fare: tripFare,
                                pickupAddress: directionDetails.startAddress,
                                destAddress: directionDetails.endAddress,
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
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
                    requested: (_) => const PendingTransaction(),
                    orElse: () => Row(
                      children: [
                        RideButton(
                          title: 'Cancel',
                          color: Colors.red,
                          onPressed: () async {
                            await ref
                                .read(passengerRideProvider.notifier)
                                .cancelRide();
                          },
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: RideButton(
                            title: 'Request Ride',
                            color: passengerRide.maybeWhen(
                                direction: (_, __) => RideColors.primaryColor,
                                orElse: () => Colors.grey),
                            onPressed: passengerRide.maybeWhen(
                              direction: (directionDetails, tripFare) =>
                                  () async {
                                await _requestRide(directionDetails, tripFare);
                              },
                              orElse: () => null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
