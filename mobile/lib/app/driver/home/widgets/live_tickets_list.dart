import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/app/driver/home/driver.home.vm.dart';
import 'package:ride/app/driver/home/widgets/ride_request_card.dart';
import 'package:ride/models/ride_request.dart';
import 'package:ride/widgets/empty_content.dart';

class LiveTicketsList extends HookConsumerWidget {
  const LiveTicketsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<DatabaseEvent> availableTickets =
        ref.watch(availableTicketsProvider);

    return SizedBox(
      height: 200,
      child: availableTickets.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => EmptyContent(
          title: 'Something Goes Wrong',
          message: err.toString(),
        ),
        data: (availableTickets) => ListView(
          children: <Widget>[
            for (final ticket in availableTickets.snapshot.children)
              RideRequestCard(
                rideRequest: RideRequest.parseRaw(ticket.value!),
              ),
          ],
        ),
      ),
    );
  }
}
