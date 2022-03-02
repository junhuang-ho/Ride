import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
  DriverHomeVM(Reader read) : super(const DriverHomeState.offline());

  late Position currentPosition;

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
      await Geofire.initialize('driversAvailable');
      await Geofire.setLocation(
          '3', currentPosition.latitude, currentPosition.longitude);
      state = const DriverHomeState.online();
    } catch (ex) {
      state = DriverHomeState.error(ex.toString());
    }
  }

  void goOffline() async {
    try {
      state = const DriverHomeState.loading();
      Geofire.removeLocation('3');
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
