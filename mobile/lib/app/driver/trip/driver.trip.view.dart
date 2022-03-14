import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/app/driver/home/driver.ride.vm.dart';
import 'package:ride/app/driver/trip/driver.trip.vm.dart';
import 'package:ride/app/driver/widgets/driver_trip_sheet.dart';
import 'package:ride/app/driver/widgets/pickup_sheet.dart';
import 'package:ride/utils/constants.dart';
import 'package:ride/widgets/cancelling_sheet.dart';

class DriverTripView extends HookConsumerWidget {
  const DriverTripView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<DriverTripState>(driverTripProvider,
        (prevTripState, newTripState) {
      if (newTripState == const DriverTripState.cancelled() ||
          newTripState == const DriverTripState.completed()) {
        ref.read(driverRideProvider.notifier).backToInit();
        context.pop();
      }
    });

    return Scaffold(
      body: Stack(
        children: <Widget>[
          const GoogleMap(
            initialCameraPosition: kGooglePlex,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            mapType: MapType.normal,
          ),
          Consumer(
            builder: (context, ref, _) {
              final driverTrip = ref.watch(driverTripProvider);
              double cancellingSheetHeight = driverTrip.maybeWhen(
                cancelling: () => Platform.isIOS ? 280 : 265,
                orElse: () => 0.0,
              );
              return CancellingSheet(
                  cancellingSheetHeight: cancellingSheetHeight);
            },
          ),
          Consumer(
            builder: (context, ref, _) {
              final driverTrip = ref.watch(driverTripProvider);
              double pickupSheetHeight = driverTrip.maybeWhen(
                pickingUp: (_) => Platform.isIOS ? 280 : 265,
                orElse: () => 0.0,
              );
              return PickupSheet(
                pickupSheetHeight: pickupSheetHeight,
              );
            },
          ),
          Consumer(
            builder: (context, ref, _) {
              final driverTrip = ref.watch(driverTripProvider);
              double sheetHeight = Platform.isIOS ? 280 : 265;
              double tripSheetHeight = driverTrip.maybeWhen(
                arrived: () => sheetHeight,
                onTheWay: () => sheetHeight,
                orElse: () => 0,
              );
              return DriverTripSheet(
                tripSheetHeight: tripSheetHeight,
              );
            },
          ),
        ],
      ),
    );
  }
}
