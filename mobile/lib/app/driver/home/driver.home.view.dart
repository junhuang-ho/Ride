import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:ride/app/driver/home/driver.home.vm.dart';
import 'package:ride/app/driver/home/driver.ride.vm.dart';
import 'package:ride/app/driver/trip/driver.trip.vm.dart';
import 'package:ride/app/driver/widgets/availability_button.dart';
import 'package:ride/app/driver/widgets/confirm_sheet.dart';
import 'package:ride/app/driver/widgets/taxi_button.dart';
import 'package:ride/models/ride_request.dart';
import 'package:ride/utils/constants.dart';
import 'package:ride/utils/ride_colors.dart';
import 'package:ride/widgets/empty_content.dart';

class DriverHomeView extends HookConsumerWidget {
  const DriverHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final driverHomeVM = ref.read(driverHomeProvider.notifier);

    return Stack(
      children: <Widget>[
        GoogleMap(
          padding: const EdgeInsets.only(top: 135),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          mapType: MapType.normal,
          initialCameraPosition: kGooglePlex,
          onMapCreated: (GoogleMapController controller) async {
            await driverHomeVM.getCurrentPosition(controller);
          },
        ),
        Container(
          height: 135,
          width: double.infinity,
          color: Theme.of(context).backgroundColor,
        ),
        const DriverAvailability(),
        Consumer(
          builder: (context, ref, _) {
            final driverRide = ref.watch(driverRideProvider);

            return driverRide.maybeWhen(
              acceptingTicket: () => const CircularProgressIndicator(),
              inTrip: (rideRequest) => RideTripCard(rideRequest: rideRequest),
              orElse: () => const LiveTicketsList(),
            );
          },
        ),
      ],
    );
  }
}

class DriverAvailability extends HookConsumerWidget {
  const DriverAvailability({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final driverHome = ref.watch(driverHomeProvider);
    final driverHomeVM = ref.read(driverHomeProvider.notifier);

    return Positioned(
      top: 60,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AvailabilityButton(
            title: driverHome.maybeWhen(
              offline: () => 'GO ONLINE',
              online: () => 'GO OFFLINE',
              orElse: () => '',
            ),
            color: driverHome.maybeWhen(
              offline: () => Colors.orange,
              online: () => Colors.green,
              orElse: () => Colors.transparent,
            ),
            onPressed: () {
              showModalBottomSheet(
                isDismissible: false,
                context: context,
                builder: (context) => driverHome.when(
                  loading: () => const CircularProgressIndicator(),
                  error: (errorMsg) => EmptyContent(
                    title: 'Something goes wrong',
                    message: errorMsg!,
                  ),
                  offline: () => ConfirmSheet(
                    title: 'GO ONLINE',
                    subtitle:
                        'You are about to become available to receive trip requests',
                    onPressed: () {
                      driverHomeVM.goOnline();
                      Navigator.pop(context);
                    },
                  ),
                  online: () => ConfirmSheet(
                    title: 'GO OFFLINE',
                    subtitle: 'You will stop receiving new trip requests',
                    onPressed: () {
                      driverHomeVM.goOffline();
                      Navigator.pop(context);
                    },
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

class LiveTicketsList extends HookConsumerWidget {
  const LiveTicketsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<DatabaseEvent> availableTickets =
        ref.watch(availableTicketsProvider);

    return Positioned(
      left: 0,
      right: 0,
      bottom: 10,
      child: SizedBox(
        height: 200,
        child: availableTickets.when(
          loading: () => const CircularProgressIndicator(),
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
      ),
    );
  }
}

class RideRequestCard extends HookConsumerWidget {
  const RideRequestCard({
    Key? key,
    required this.rideRequest,
  }) : super(key: key);

  final RideRequest rideRequest;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final useBadge = useState<int>(0);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Theme.of(context).bottomAppBarColor,
      child: Container(
        margin: const EdgeInsets.all(4),
        child: Column(
          children: [
            ListTile(
              title: Text(rideRequest.destinationAddress),
              subtitle: Text(
                'from: ${rideRequest.pickupAddress} ${rideRequest.tixId}',
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 30,
              width: 30,
              child: NumberPicker(
                zeroPad: true,
                minValue: 0,
                maxValue: 6,
                value: useBadge.value,
                onChanged: (value) {
                  useBadge.value = value;
                },
                textStyle: const TextStyle(fontSize: 18),
                haptics: true,
              ),
            ),
            const SizedBox(height: 10),
            TaxiButton(
              title: 'ACCEPT',
              color: RideColors.colorGreen,
              onPressed: () async {
                await ref
                    .read(driverRideProvider.notifier)
                    .acceptRideRequest(rideRequest, useBadge.value.toString());
              },
            ),
          ],
        ),
      ),
    );
  }
}

class RideTripCard extends HookConsumerWidget {
  const RideTripCard({
    Key? key,
    required this.rideRequest,
  }) : super(key: key);

  final RideRequest rideRequest;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print(rideRequest.status);
    return Positioned(
      left: 0,
      right: 0,
      bottom: 10,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Theme.of(context).bottomAppBarColor,
        child: Container(
          margin: const EdgeInsets.all(4),
          child: Column(
            children: [
              ListTile(
                title: Text(rideRequest.destinationAddress),
                subtitle: Text(
                  'from: ${rideRequest.pickupAddress} ${rideRequest.tixId}',
                ),
              ),
              const SizedBox(height: 10),
              if (rideRequest.status == Strings.accepted)
                TaxiButton(
                  title: 'START TRIP',
                  color: RideColors.colorAccentPurple,
                  onPressed: () {
                    ref
                        .read(driverTripProvider.notifier)
                        .pickingUp(rideRequest);
                    context.go('/driver/trip');
                  },
                ),
              if (rideRequest.status == Strings.ontrip ||
                  rideRequest.status == Strings.pendingAgreement)
                TaxiButton(
                  title: 'CONTINUE TRIP',
                  color: RideColors.colorAccentPurple,
                  onPressed: () {
                    ref
                        .read(driverTripProvider.notifier)
                        .updateOnTheWay(rideRequest);
                    context.go('/driver/trip');
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
