import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/abi/RideDriver.g.dart';
import 'package:ride/app/passenger/home/passenger.ride.vm.dart';
import 'package:ride/app/passenger/widgets/common_sheet.dart';
import 'package:ride/app/ride/request.ticket.vm.dart';
import 'package:ride/utils/ride_colors.dart';
import 'package:ride/widgets/empty_content.dart';

class RequestingSheet extends HookConsumerWidget {
  const RequestingSheet({
    Key? key,
    required this.requestingSheetHeight,
    required this.tixId,
  }) : super(key: key);

  final double requestingSheetHeight;
  final String? tixId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<AcceptedTicket> acceptedTicket =
        ref.watch(requestAcceptedEventProvider);

    return CommonSheet(
      sheetHeight: requestingSheetHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            acceptedTicket.when(
              loading: () => const CircularProgressIndicator(),
              error: (err, stack) => EmptyContent(
                title: 'Something Goes Wrong',
                message: err.toString(),
              ),
              data: (ticket) => EmptyContent(
                title: 'Sender: ${ticket.sender}',
                message: 'TixId: ${ticket.tixId}',
              ),
            ),
            const SizedBox(height: 20),
            Consumer(
              builder: (context, ref, _) {
                final requestTicketVM = ref.watch(requestTicketProvider);

                return requestTicketVM.maybeWhen(
                  cancelling: () => const CircularProgressIndicator(),
                  orElse: () => GestureDetector(
                    onTap: () async {
                      await ref
                          .read(requestTicketProvider.notifier)
                          .cancelRequest();
                      await ref
                          .read(passengerRideProvider.notifier)
                          .cancelRide(tixId: tixId);
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                            width: 1.0, color: RideColors.colorLightGrayFair),
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 25,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            const SizedBox(
              width: double.infinity,
              child: Text(
                'Cancel Ride',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
