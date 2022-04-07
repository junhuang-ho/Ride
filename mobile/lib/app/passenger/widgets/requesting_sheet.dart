import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/app/driver/widgets/ride_button.dart';
import 'package:ride/app/passenger/home/passenger.otw.info.vm.dart';
import 'package:ride/app/passenger/home/passenger.ride.vm.dart';
import 'package:ride/app/passenger/home/request.ticket.vm.dart';
import 'package:ride/app/passenger/trip/passenger.trip.vm.dart';
import 'package:ride/app/passenger/widgets/reputation_details.dart';
import 'package:ride/widgets/pending_transaction.dart';
import 'package:ride/app/qrcode.reader.view.dart';
import 'package:ride/services/crypto.dart';
import 'package:ride/services/ride/ride_passenger.dart';
import 'package:ride/widgets/common_sheet.dart';
import 'package:ride/models/ride_request.dart';
import 'package:ride/utils/constants.dart';
import 'package:ride/utils/ride_colors.dart';
import 'package:ride/widgets/empty_content.dart';
import 'package:ride/widgets/ride_details_card.dart';

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
    AsyncValue<DatabaseEvent> requestedRideRequest =
        ref.watch(rideRequestProvider(tixId));

    return CommonSheet(
      sheetHeight: requestingSheetHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 10),
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
                if (rideRequest.status == Strings.waiting) {
                  return WaitingAcceptContent(rideRequest: rideRequest);
                } else if (rideRequest.status == Strings.accepted) {
                  return OnTheWayContent(rideRequest: rideRequest);
                } else if (rideRequest.status == Strings.arrived) {
                  ref
                      .read(passengerRideProvider.notifier)
                      .updateDriverArrived();
                  return ArrivedContent(rideRequest: rideRequest);
                } else {
                  return Text('Ride Request Status: ${rideRequest.status}');
                }
              },
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

class WaitingAcceptContent extends StatelessWidget {
  const WaitingAcceptContent({
    Key? key,
    required this.rideRequest,
  }) : super(key: key);

  final RideRequest rideRequest;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Waiting Driver Accept...',
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.w900,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.open_in_new),
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) {
                return RideDetailsCard(
                  distanceText: rideRequest.distanceText,
                  durationText: rideRequest.durationText,
                  fare: rideRequest.tripFare,
                  pickupAddress: rideRequest.pickupAddress,
                  destAddress: rideRequest.destinationAddress,
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class OnTheWayContent extends HookConsumerWidget {
  const OnTheWayContent({
    Key? key,
    required this.rideRequest,
  }) : super(key: key);

  final RideRequest rideRequest;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passengerOnTheWayInfo = ref.watch(passengerOnTheWayInfoProvider(
        PassengerOnTheWayInput(
            driverAddress: rideRequest.driverId, tixId: rideRequest.tixId)));

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Driver\'s On The Way...',
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.w900,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.open_in_new),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) {
                    return RideDetailsCard(
                      userId: rideRequest.driverId,
                      distanceText: rideRequest.distanceText,
                      durationText: rideRequest.durationText,
                      fare: rideRequest.tripFare,
                      pickupAddress: rideRequest.pickupAddress,
                      destAddress: rideRequest.destinationAddress,
                    );
                  },
                );
              },
            ),
          ],
        ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: RideColors.grey,
          child: Container(
            margin: const EdgeInsets.all(4),
            height: 100,
            width: 300,
            child: passengerOnTheWayInfo.maybeWhen(
              loading: () => const Center(child: CircularProgressIndicator()),
              data: (driverReputation, ticket) {
                return ReputationDetails(
                  metresTravelled: driverReputation.metresTravelled,
                  tripCompleted: driverReputation.countEnd,
                  rating: driverReputation.totalRating /
                      driverReputation.countRating,
                );
              },
              error: (errorMsg) => Text(errorMsg!),
              orElse: () => const SizedBox(),
            ),
          ),
        ),
      ],
    );
  }
}

class ArrivedContent extends HookConsumerWidget {
  const ArrivedContent({
    Key? key,
    required this.rideRequest,
  }) : super(key: key);

  final RideRequest rideRequest;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> _startTrip(String driverAddress) async {
      await ref
          .read(passengerTripProvider.notifier)
          .startTrip(driverAddress, rideRequest);
      final passengerAddress =
          await ref.read(cryptoProvider).getUserPublicAddress();
      ref
          .read(ridePassengerProvider)
          .ridePassenger
          .tripStartedEvents()
          .listen((event) {
        if (event.passenger == passengerAddress) {
          ref.read(passengerRideProvider.notifier).startRideTrip(rideRequest);
        }
      });
    }

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Driver Arrived!',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w900,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.open_in_new),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) {
                    return RideDetailsCard(
                      userId: rideRequest.driverId,
                      distanceText: rideRequest.distanceText,
                      durationText: rideRequest.durationText,
                      fare: rideRequest.tripFare,
                      pickupAddress: rideRequest.pickupAddress,
                      destAddress: rideRequest.destinationAddress,
                    );
                  },
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Consumer(
            builder: (context, ref, _) {
              final passengerTripVM = ref.watch(passengerTripProvider);

              return passengerTripVM.maybeWhen(
                startingTrip: () => const CircularProgressIndicator(),
                onTheWay: (_) => const PendingTransaction(),
                orElse: () => RideButton(
                  title: 'Scan Driver QR Code',
                  color: Colors.green,
                  onPressed: () async {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) {
                          return QRCodeReaderView(
                            onScanned: (scannedAddress) async {
                              await _startTrip(scannedAddress.toString());
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// class DriverAddressNotMatchedContent extends HookConsumerWidget {
//   const DriverAddressNotMatchedContent({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // TODO: implement build
//     throw UnimplementedError();
//   }
// }
