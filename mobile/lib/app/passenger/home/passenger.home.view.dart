import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/app/auth/auth.vm.dart';
import 'package:ride/app/passenger/home/passenger.home.vm.dart';
import 'package:ride/app/passenger/home/passenger.ride.vm.dart';
import 'package:ride/app/passenger/trip/passenger.trip.vm.dart';
import 'package:ride/app/passenger/widgets/agreement_sheet.dart';
import 'package:ride/app/passenger/widgets/alert.dart';
import 'package:ride/app/passenger/widgets/details_sheet.dart';
import 'package:ride/app/passenger/widgets/main_menu.dart';
import 'package:ride/app/passenger/widgets/menu_button.dart';
import 'package:ride/app/passenger/widgets/requesting_sheet.dart';
import 'package:ride/app/passenger/widgets/search_sheet.dart';
import 'package:ride/app/passenger/widgets/trip_sheet.dart';
import 'package:ride/app/ride/request.ticket.vm.dart';
import 'package:ride/models/ride_request.dart';
import 'package:ride/utils/constants.dart';

class PassengerHomeView extends HookConsumerWidget {
  PassengerHomeView({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passengerHome = ref.watch(passengerHomeProvider);
    final passengerHomeVM = ref.read(passengerHomeProvider.notifier);

    ref.listen<PassengerTripState>(passengerTripProvider,
        (prevTripState, newTripState) {
      if (newTripState == const PassengerTripState.ended()) {
        ref.read(requestTicketProvider.notifier).backToInit();
        ref.read(passengerRideProvider.notifier).backToInit();
      }
    });

    bool drawerCanOpen = passengerHome.maybeWhen(
        init: (mapState) => mapState.drawerCanOpen, orElse: () => true);
    double mapBottomPadding = passengerHome.maybeWhen(
        init: (mapState) => mapState.mapBottomPadding, orElse: () => 0.0);
    Set<Polyline> polylines = passengerHome.maybeWhen(
        init: (mapState) => mapState.polylines, orElse: () => {});
    Set<Marker> markers = passengerHome.maybeWhen(
      init: (mapState) => mapState.markers,
      updateDriversOnMap: (newMarkers) => newMarkers,
      orElse: () => {},
    );
    Set<Circle> circles = passengerHome.maybeWhen(
        init: (mapState) => mapState.circles, orElse: () => {});

    return Scaffold(
      key: _scaffoldKey,
      drawer: MainMenu(
        onReset: () => Alert(
            title: 'Warning',
            text:
                'Without your seed phrase or private key you cannot restore your wallet balance',
            actions: [
              TextButton(
                child: const Text('cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: const Text('reset'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await ref.read(authProvider.notifier).deleteAccount();
                  context.go('/');
                },
              ),
            ]).show(context),
        onRevealKey: () => Alert(
          title: 'Private key',
          text:
              'WARNING, In production environment, the private key should be protected with password.\r\n\r\n'
              '${ref.read(authProvider.notifier).getPrivateKey() ?? "-"}',
          actions: [
            TextButton(
              child: const Text('close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('copy and close'),
              onPressed: () {
                final privateKey =
                    ref.read(authProvider.notifier).getPrivateKey();
                Clipboard.setData(ClipboardData(text: privateKey));
                Navigator.of(context).pop();
              },
            )
          ],
        ).show(context),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            padding: EdgeInsets.only(bottom: mapBottomPadding),
            mapType: MapType.normal,
            initialCameraPosition: kKualaLumpurPlex,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: false,
            polylines: polylines,
            markers: markers,
            circles: circles,
            onMapCreated: (GoogleMapController controller) async {
              mapBottomPadding = (Platform.isAndroid) ? 180 : 170;
              await passengerHomeVM.setupPositionLocator(controller);
            },
          ),
          MenuButton(
            iconData: (drawerCanOpen) ? Icons.menu : Icons.arrow_back,
            onTap: () {
              if (drawerCanOpen) {
                _scaffoldKey.currentState!.openDrawer();
              } else {
                passengerHomeVM.resetApp();
              }
            },
          ),
          Consumer(
            builder: (context, ref, _) {
              final passengerRide = ref.watch(passengerRideProvider);
              double searchSheetHeight = passengerRide.maybeWhen(
                  init: () => Platform.isIOS ? 200 : 175, orElse: () => 0.0);
              return SearchSheet(
                searchSheetHeight: searchSheetHeight,
                onSearchBarTap: () async {
                  context.go('/passenger/search');
                },
              );
            },
          ),
          Consumer(
            builder: (context, ref, _) {
              final passengerRide = ref.watch(passengerRideProvider);
              double detailsSheetHeight = passengerRide.maybeWhen(
                  direction: (_) => (Platform.isIOS) ? 300 : 275,
                  orElse: () => 0.0);
              return DetailsSheet(detailSheetHeight: detailsSheetHeight);
            },
          ),
          Consumer(
            builder: (context, ref, _) {
              final passengerRide = ref.watch(passengerRideProvider);
              double sheetHeight = (Platform.isIOS) ? 220 : 195;
              double requestingSheetHeight = passengerRide.maybeWhen(
                requesting: (_) => sheetHeight,
                ticketAccepted: (_) => sheetHeight,
                orElse: () => 0.0,
              );
              return RequestingSheet(
                requestingSheetHeight: requestingSheetHeight,
                tixId: passengerRide.whenOrNull(
                    requesting: (tixId) => tixId,
                    ticketAccepted: (tixId) => tixId),
              );
            },
          ),
          Consumer(
            builder: (context, ref, _) {
              final passengerRide = ref.watch(passengerRideProvider);
              double tripSheetHeight = passengerRide.maybeWhen(
                inTrip: (_) => (Platform.isIOS) ? 275 : 300,
                orElse: () => 0.0,
              );

              RideRequest? rideRequest = passengerRide.maybeWhen(
                  inTrip: (rideRequest) {
                    ref.listen<AsyncValue<DatabaseEvent>>(
                      rideRequestProvider(rideRequest.tixId),
                      (prev, next) {
                        next.whenData(
                          (dbEvent) {
                            final rawRideRequest = dbEvent.snapshot.value;
                            if (rawRideRequest != null) {
                              final rideRequest =
                                  RideRequest.parseRaw(rawRideRequest);
                              if (rideRequest.status == Strings.destReached ||
                                  rideRequest.status ==
                                      Strings.destNotReached) {
                                showModalBottomSheet(
                                  isDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return AgreementSheet(
                                        rideRequest: rideRequest);
                                  },
                                );
                              }
                            }
                          },
                        );
                      },
                    );
                    return rideRequest;
                  },
                  orElse: () => null);
              return TripSheet(
                tripSheetHeight: tripSheetHeight,
                rideRequest: rideRequest,
              );
            },
          ),
        ],
      ),
    );
  }
}
