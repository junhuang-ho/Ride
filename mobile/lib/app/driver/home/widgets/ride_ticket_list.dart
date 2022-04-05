import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/app/driver/home/driver.home.vm.dart';
import 'package:ride/app/driver/home/widgets/ride_request_card.dart';
import 'package:ride/models/ride_request.dart';
import 'package:ride/utils/ride_colors.dart';
import 'package:ride/widgets/empty_content.dart';
import 'package:ride/widgets/sheet_handle.dart';

class RideTicketList extends HookConsumerWidget {
  const RideTicketList({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('live ticket list rebuild...');
    AsyncValue<DatabaseEvent> availableTickets =
        ref.watch(availableTicketsProvider);

    return Column(
      children: [
        const SizedBox(height: 20),
        const SheetHandle(),
        const SizedBox(height: 15),
        Row(
          children: [
            const Text(
              'Ride Requests',
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(width: 10),
            availableTickets.maybeWhen(
              data: (availableTickets) => CircleAvatar(
                radius: 15,
                backgroundColor: RideColors.primaryColor,
                foregroundColor: Colors.white,
                child: Text('${availableTickets.snapshot.children.length}'),
              ),
              orElse: () => const SizedBox(),
            ),
          ],
        ),
        availableTickets.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => EmptyContent(
            title: 'Something Goes Wrong',
            message: err.toString(),
          ),
          data: (availableTickets) => Expanded(
            child: ListView.separated(
              controller: scrollController,
              itemCount: availableTickets.snapshot.children.length,
              shrinkWrap: true,
              separatorBuilder: (context, index) => const SizedBox(height: 20),
              itemBuilder: (context, index) {
                final ticket =
                    availableTickets.snapshot.children.elementAt(index);
                return RideRequestCard(
                  rideRequest: RideRequest.parseRaw(ticket.value!),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
