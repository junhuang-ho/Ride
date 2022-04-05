import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/abi/RideDriver.g.dart';
import 'package:ride/app/driver/home/driver.ride.vm.dart';
import 'package:ride/widgets/common_sheet.dart';
import 'package:ride/widgets/pending_transaction.dart';
import 'package:ride/models/ride_request.dart';
import 'package:ride/services/crypto.dart';

class RidePendingCard extends HookConsumerWidget {
  const RidePendingCard({
    Key? key,
    required this.rideRequest,
  }) : super(key: key);

  final RideRequest rideRequest;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<AcceptedTicket>>(acceptedTicketEventProvider,
        (prev, next) {
      next.whenData((acceptedTicket) async {
        final driverAddress =
            await ref.read(cryptoProvider).getUserPublicAddress();
        if (acceptedTicket.sender == driverAddress) {
          ref
              .read(driverRideProvider.notifier)
              .updateDriverId(acceptedTicket.tixId, driverAddress, rideRequest);
        }
      });
    });

    return CommonSheet(
      sheetHeight: 200,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Theme.of(context).bottomAppBarColor,
        child: Container(
          margin: const EdgeInsets.all(4),
          height: 200,
          child: const PendingTransaction(),
        ),
      ),
    );
  }
}
