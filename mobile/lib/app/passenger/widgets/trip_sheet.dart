import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/app/passenger/home/passenger.otw.info.vm.dart';
import 'package:ride/app/passenger/trip/passenger.trip.vm.dart';
import 'package:ride/app/passenger/widgets/reputation_details.dart';
import 'package:ride/app/passenger/widgets/trip_details.dart';
import 'package:ride/models/ride_request.dart';
import 'package:ride/utils/ride_colors.dart';
import 'package:ride/widgets/common_sheet.dart';
import 'package:ride/widgets/ride_details_content.dart';

class TripSheet extends HookConsumerWidget {
  const TripSheet({
    Key? key,
    required this.tripSheetHeight,
    required this.rideRequest,
  }) : super(key: key);

  final double tripSheetHeight;
  final RideRequest? rideRequest;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passengerTrip = ref.watch(passengerTripProvider);

    return CommonSheet(
      sheetHeight: tripSheetHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 5),
            passengerTrip.maybeWhen(
              onTheWay: (_) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'On The Way',
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              orElse: () => const SizedBox(),
            ),
            const SizedBox(height: 20),
            if (rideRequest != null)
              CarouselSlider(
                options: CarouselOptions(
                  height: 250,
                  scrollDirection: Axis.vertical,
                  viewportFraction: 0.8,
                  aspectRatio: 2.0,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                ),
                items: [
                  TripDetailsCard(
                    pickupAddress: rideRequest!.pickupAddress,
                    destinationAddress: rideRequest!.destinationAddress,
                  ),
                  Card(
                    elevation: 10.0,
                    margin: const EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: RideColors.cardColor,
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      child: Column(
                        children: [
                          RideDetailsContent(
                            showPickupAndDest: false,
                            userId: rideRequest!.driverId,
                            distanceText: rideRequest!.distanceText,
                            durationText: rideRequest!.durationText,
                            fare: rideRequest!.tripFare,
                            pickupAddress: rideRequest!.pickupAddress,
                            destAddress: rideRequest!.destinationAddress,
                          ),
                        ],
                      ),
                    ),
                  ),
                  DriverReputationCard(
                    driverId: rideRequest!.driverId,
                    tixId: rideRequest!.tixId,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class TripDetailsCard extends StatelessWidget {
  const TripDetailsCard({
    Key? key,
    required this.pickupAddress,
    required this.destinationAddress,
  }) : super(key: key);

  final String pickupAddress;
  final String destinationAddress;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10.0,
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: RideColors.cardColor,
      child: Container(
        margin: const EdgeInsets.all(4),
        child: Column(
          children: [
            TripDetailsContent(
              pickupAddress: pickupAddress,
              destAddress: destinationAddress,
            ),
          ],
        ),
      ),
    );
  }
}

class DriverReputationCard extends StatelessWidget {
  const DriverReputationCard({
    Key? key,
    required this.driverId,
    required this.tixId,
  }) : super(key: key);

  final String driverId;
  final String tixId;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final passengerOnTheWayInfo = ref.watch(passengerOnTheWayInfoProvider(
            PassengerOnTheWayInput(driverAddress: driverId, tixId: tixId)));
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: RideColors.cardColor,
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
        );
      },
    );
  }
}
