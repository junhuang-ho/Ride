import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hex/hex.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/app/auth/auth.vm.dart';
import 'package:ride/app/driver/home/driver.ride.vm.dart';
import 'package:ride/app/ride/request.ticket.vm.dart';
import 'package:ride/utils/constants.dart';
import 'package:ride/utils/fire_helper.dart';
import 'package:ride/utils/hex_helper.dart';
import 'package:ride/utils/permission_helper.dart';

part 'driver.home.vm.freezed.dart';

@freezed
class DriverHomeState with _$DriverHomeState {
  // const factory DriverHomeState.init() = _DriverHomeInit;
  const factory DriverHomeState.loading() = _DriverHomeLoading;
  const factory DriverHomeState.error(String? message) = _DriverHomeError;
  // const factory DriverHomeState.data(Address address) = _DriverHomeData;
  const factory DriverHomeState.online() = _DriverHomeOnline;
  const factory DriverHomeState.offline() = _DriverHomeOffline;
}

class DriverHomeVM extends StateNotifier<DriverHomeState> {
  DriverHomeVM(Reader read)
      : _authVM = read(authProvider.notifier),
        _requestTicketVM = read(requestTicketProvider.notifier),
        _driverRideVM = read(driverRideProvider.notifier),
        super(const DriverHomeState.offline()) {
    checkAcceptedStatus();
  }

  late Position currentPosition;
  final AuthVM _authVM;
  final RequestTicketVM _requestTicketVM;
  final DriverRideVM _driverRideVM;

  Future<void> checkAcceptedStatus() async {
    final tixId = await _requestTicketVM.getTicket();
    if (tixId == null || HexHelper.isAllZeroIn64Hex(tixId)) {
      return;
    }
    final rideRequest = await FireHelper.getRideRequest(HEX.encode(tixId));

    final driverAddress = await _authVM.getPublicKey();
    if (rideRequest.driverId == driverAddress) {
      _driverRideVM.updateInTrip(rideRequest);
    }
  }

  void getCurrentDriverInfo() {}

  Future<void> getCurrentPosition(GoogleMapController mapController) async {
    if (!await PermissionHelper.requestLocationWhenInUsePermission()) return;
    currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    LatLng mapPosition =
        LatLng(currentPosition.latitude, currentPosition.longitude);
    mapController.animateCamera(CameraUpdate.newLatLng(mapPosition));
  }

  Future<void> goOnline() async {
    try {
      state = const DriverHomeState.loading();
      await Geofire.initialize(Strings.driversAvailable);
      final driverId = await _authVM.getPublicKey();
      await Geofire.setLocation(
          driverId!, currentPosition.latitude, currentPosition.longitude);
      state = const DriverHomeState.online();
    } catch (ex) {
      state = DriverHomeState.error(ex.toString());
    }
  }

  Future<void> goOffline() async {
    try {
      state = const DriverHomeState.loading();
      final driverId = await _authVM.getPublicKey();
      await Geofire.removeLocation(driverId!);
      state = const DriverHomeState.offline();
    } catch (ex) {
      state = DriverHomeState.error(ex.toString());
    }
  }
}

final driverHomeProvider =
    StateNotifierProvider<DriverHomeVM, DriverHomeState>((ref) {
  return DriverHomeVM(ref.read);
});

final availableTicketsProvider =
    StreamProvider.autoDispose<DatabaseEvent>((ref) {
  return FireHelper.getWaitingRideRequestStream();
});
