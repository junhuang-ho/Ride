import 'dart:typed_data';

import 'package:firebase_database/firebase_database.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hex/hex.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/app/passenger/trip/passenger.trip.vm.dart';
import 'package:ride/models/address.dart';
import 'package:ride/models/direction_details.dart';
import 'package:ride/models/ride_request.dart';
import 'package:ride/services/maps_api.dart';
import 'package:ride/utils/connectivity_helper.dart';
import 'package:ride/utils/constants.dart';
import 'package:ride/utils/fire_helper.dart';

part 'passenger.ride.vm.freezed.dart';

@freezed
class PassengerRideState with _$PassengerRideState {
  const factory PassengerRideState.error(String? message) = _PassengerRideError;
  const factory PassengerRideState.init() = _PassengerRideInit;
  const factory PassengerRideState.direction(
      DirectionDetails directionDetails) = _PassengerRideDirection;
  const factory PassengerRideState.requesting(String tixId) =
      _PassengerRideRequesting;
  const factory PassengerRideState.ticketAccepted(String tixId) =
      _PassengerRideTicketAccepted;
  const factory PassengerRideState.driverArrived() = _PassengerRideArrived;
  const factory PassengerRideState.inTrip(RideRequest rideRequest) =
      _PassengerRideInTrip;
}

class PassengerRideVM extends StateNotifier<PassengerRideState> {
  PassengerRideVM(Reader read) : super(const PassengerRideState.init());

  Address? pickUpAddress;
  Address? destAddress;

  Future<void> updatePickUpAddress(Position position) async {
    try {
      if (!await ConnectivityHelper.hasConnectivity()) {
        return;
      }
      var geocodeResult =
          await MapsAPI.geocode(position.latitude, position.longitude);
      if (geocodeResult['status'] == 'OK') {
        String placeAddress = geocodeResult['results'][0]['formatted_address'];
        pickUpAddress = Address(
          placeName: placeAddress,
          latitude: position.latitude,
          longitude: position.longitude,
        );
      }
    } catch (ex) {
      state = PassengerRideState.error(ex.toString());
    }
  }

  Future<void> updateDestinationAddress(
      String placeId, String sessionToken) async {
    try {
      final placeDetailsResult =
          await MapsAPI.placeDetails(placeId, sessionToken);
      if (placeDetailsResult == 'failed') {
        return;
      }
      if (placeDetailsResult['status'] == 'OK') {
        String destPlaceName = placeDetailsResult['result']['name'];
        double destPlaceLatitude =
            placeDetailsResult['result']['geometry']['location']['lat'];
        double destPlaceLongitude =
            placeDetailsResult['result']['geometry']['location']['lng'];

        destAddress = Address(
          placeName: destPlaceName,
          placeId: placeId,
          latitude: destPlaceLatitude,
          longitude: destPlaceLongitude,
        );
        await getDirection(destAddress!);
      }
    } catch (ex) {
      state = PassengerRideState.error(ex.toString());
    }
  }

  Future<void> getDirection(Address destAddress) async {
    final pickUpLatLng =
        LatLng(pickUpAddress!.latitude, pickUpAddress!.longitude);
    final destLatLng = LatLng(destAddress.latitude, destAddress.longitude);
    final directionsResult = await MapsAPI.directions(pickUpLatLng, destLatLng);
    if (directionsResult == 'failed') {
      return;
    }
    if (directionsResult['status'] == 'OK') {
      String durationText =
          directionsResult['routes'][0]['legs'][0]['duration']['text'];
      int durationValue =
          directionsResult['routes'][0]['legs'][0]['duration']['value'];
      String distanceText =
          directionsResult['routes'][0]['legs'][0]['distance']['text'];
      int distanceValue =
          directionsResult['routes'][0]['legs'][0]['distance']['value'];
      String encodedPoints =
          directionsResult['routes'][0]['overview_polyline']['points'];

      state = PassengerRideState.direction(DirectionDetails(
        durationText: durationText,
        durationValue: durationValue,
        distanceText: distanceText,
        distanceValue: distanceValue,
        encodedPoints: encodedPoints,
      ));
    }
  }

  Future<void> requestRide(Uint8List? tixId) async {
    if (tixId == null) {
      state = const PassengerRideState.error('Sorry, ticket ID not found.');
      return;
    }

    try {
      final encodedTixId = HEX.encode(tixId);
      state = PassengerRideState.requesting(encodedTixId);
      if (pickUpAddress != null && destAddress != null) {
        final Map pickUpMap = {
          'latitude': pickUpAddress!.latitude.toString(),
          'longitude': pickUpAddress!.longitude.toString(),
        };

        Map destinationMap = {
          'latitude': destAddress!.latitude.toString(),
          'longitude': destAddress!.longitude.toString(),
        };

        Map<String, Object> rideMap = {
          'tix_id': encodedTixId,
          'created_at': DateTime.now().toString(),
          'pickup_address': pickUpAddress!.placeName,
          'destination_address': destAddress!.placeName,
          'location': pickUpMap,
          'destination': destinationMap,
          'driver_id': Strings.waiting,
          'status': Strings.waiting,
        };

        await FireHelper.addRideRequest(encodedTixId, rideMap);
      }
    } catch (ex) {
      state = PassengerRideState.error(ex.toString());
    }
  }

  Future<void> cancelRide({String? tixId}) async {
    if (tixId != null) {
      await FireHelper.removeRideRequest(tixId);
    }
    backToInit();
  }

  void updateTicketAccepted(String tixId) {
    state = PassengerRideState.ticketAccepted(tixId);
  }

  void updateDriverArrived() {
    // state = const PassengerRideState.driverArrived();
  }

  Future<void> startRideTrip(RideRequest rideRequest) async {
    try {
      await FireHelper.updateRideRequest(
        rideRequest.tixId,
        {"status": Strings.ontrip},
      );
      updateInTrip(rideRequest);
    } catch (ex) {
      state = PassengerRideState.error(ex.toString());
    }
  }

  void updateInTrip(RideRequest rideRequest) {
    state = PassengerRideState.inTrip(rideRequest);
  }

  void backToInit() {
    state = const PassengerRideState.init();
  }
}

final passengerRideProvider =
    StateNotifierProvider.autoDispose<PassengerRideVM, PassengerRideState>(
        (ref) => PassengerRideVM(ref.read));

final rideRequestProvider =
    StreamProvider.family.autoDispose<DatabaseEvent, String?>((ref, tixId) {
  if (tixId != null) {
    return FireHelper.getRideRequestStreamByTixId(tixId);
  }
  return const Stream.empty();
});
