import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/abi/RidePassenger.g.dart';
import 'package:ride/app/driver/home/driver.home.vm.dart';
import 'package:ride/widgets/empty_content.dart';

class DriverHomeView extends HookConsumerWidget {
  const DriverHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<RequestTicket> requstTickets =
        ref.watch(requestTicketEventProvider);

    return Scaffold(
      body: Center(
        child: requstTickets.when(
          loading: () => const CircularProgressIndicator(),
          error: (err, stack) => EmptyContent(
            title: 'Something Goes Wrong',
            message: err.toString(),
          ),
          data: (ticket) => EmptyContent(
            title: 'Sender: ${ticket.sender}',
            message: 'Fare: ${ticket.fare}',
          ),
        ),
      ),
    );
  }
}
