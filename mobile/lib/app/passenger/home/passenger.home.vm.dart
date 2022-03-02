import 'package:equatable/equatable.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/models/address.dart';
import 'package:ride/models/nearby_driver.dart';
import 'package:ride/services/maps_api.dart';
import 'package:ride/utils/connectivity_helper.dart';
import 'package:ride/utils/fire_helper.dart';
import 'package:ride/utils/permission_helper.dart';

part 'passenger.home.vm.freezed.dart';

class MapState extends Equatable {
  final bool drawerCanOpen;
  final double mapBottomPadding;
  final Set<Polyline> polylines;
  final Set<Marker> markers;
  final Set<Circle> circles;

  const MapState({
    required this.drawerCanOpen,
    required this.mapBottomPadding,
    required this.polylines,
    required this.markers,
    required this.circles,
  });

  factory MapState.initial() => const MapState(
        drawerCanOpen: true,
        mapBottomPadding: 0.0,
        polylines: {},
        markers: {},
        circles: {},
      );

  MapState copyWith({
    bool? drawerCanOpen,
    double? mapBottomPadding,
    Set<Polyline>? polylines,
    Set<Marker>? markers,
    Set<Circle>? circles,
  }) {
    return MapState(
      drawerCanOpen: drawerCanOpen ?? this.drawerCanOpen,
      mapBottomPadding: mapBottomPadding ?? this.mapBottomPadding,
      polylines: polylines ?? this.polylines,
      markers: markers ?? this.markers,
      circles: circles ?? this.circles,
    );
  }

  @override
  List<Object?> get props =>
      [drawerCanOpen, mapBottomPadding, polylines, markers, circles];
  @override
  bool get stringify => true;
}

@freezed
class PassengerHomeState with _$PassengerHomeState {
  const factory PassengerHomeState.init(MapState mapState) =
      _PassengerHomeStateInit;
  const factory PassengerHomeState.updateDriversOnMap(Set<Marker> markers) =
      _PassengerHomeStateUpdateDriversOnMap;
  const factory PassengerHomeState.loading() = _PassengerHomeLoading;
  const factory PassengerHomeState.error(String? message) = _PassengerHomeError;
  const factory PassengerHomeState.data(Address address) = _PassengerHomeData;
}

class PassengerHomeVM extends StateNotifier<PassengerHomeState> {
  PassengerHomeVM(Reader read)
      : super(PassengerHomeState.init(MapState.initial()));

  Future<void> setupPositionLocator(GoogleMapController mapController) async {
    if (!await PermissionHelper.requestLocationWhenInUsePermission()) return;
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    LatLng mapPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition =
        CameraPosition(target: mapPosition, zoom: 16);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  void resetApp() {
    // drawerCanOpen.value = true;
  }
}

final passengerHomeProvider =
    StateNotifierProvider<PassengerHomeVM, PassengerHomeState>((ref) {
  return PassengerHomeVM(ref.read);
});
