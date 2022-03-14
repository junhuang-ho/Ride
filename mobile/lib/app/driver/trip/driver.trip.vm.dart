import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/models/ride_request.dart';
import 'package:ride/services/ride/ride_driver.dart';
import 'package:ride/utils/constants.dart';
import 'package:ride/utils/fire_helper.dart';

part 'driver.trip.vm.freezed.dart';

@freezed
class DriverTripState with _$DriverTripState {
  const factory DriverTripState.init() = _DriverTripInit;
  const factory DriverTripState.error(String? message) = _DriverTripError;
  const factory DriverTripState.pickingUp(RideRequest rideRequest) =
      _DriverTripPickingUp;
  const factory DriverTripState.cancelling() = _DriverTripCancelling;
  const factory DriverTripState.cancelled() = _DriverTripCancelled;
  const factory DriverTripState.arriving() = _DriverTripArriving;
  const factory DriverTripState.arrived() = _DriverTripArrived;
  const factory DriverTripState.onTheWay() = _DriverTripOnTheWay;
  const factory DriverTripState.completing() = _DriverTripCompleting;
  const factory DriverTripState.completed() = _DriverTripCompleted;
}

class DriverTripVM extends StateNotifier<DriverTripState> {
  DriverTripVM(Reader read)
      : _rideDriver = read(rideDriverProvider),
        super(const DriverTripState.init());

  final RideDriverService _rideDriver;
  late RideRequest acceptedRideRequest;

  Future<void> pickingUp(RideRequest rideRequest) async {
    acceptedRideRequest = rideRequest;
    state = DriverTripState.pickingUp(rideRequest);
  }

  Future<void> arrived() async {
    try {
      state = const DriverTripState.arriving();
      await FireHelper.updateRideRequest(
        acceptedRideRequest.tixId,
        {"status": Strings.arrived},
      );
      state = const DriverTripState.arrived();
    } catch (ex) {
      state = DriverTripState.error(ex.toString());
    }
  }

  Future<void> cancelPickUp() async {
    try {
      state = const DriverTripState.cancelling();
      await _rideDriver.cancelPickUp();
      await FireHelper.removeRideRequest(acceptedRideRequest.tixId);
      state = const DriverTripState.cancelled();
    } catch (ex) {
      state = DriverTripState.error(ex.toString());
    }
  }

  void updateOnTheWay(RideRequest rideRequest) {
    acceptedRideRequest = rideRequest;
    state = const DriverTripState.onTheWay();
  }

  Future<void> destinationReached(bool reached) async {
    try {
      await _rideDriver.endTrip(reached);
      final rideRequestStatus =
          reached ? Strings.destReached : Strings.destNotReached;

      await FireHelper.updateRideRequest(
        acceptedRideRequest.tixId,
        {
          "status": rideRequestStatus,
        },
      );
    } catch (ex) {
      state = DriverTripState.error(ex.toString());
    }
  }

  Future<void> completeTrip() async {
    try {
      state = const DriverTripState.completing();
      await FireHelper.removeRideRequest(acceptedRideRequest.tixId);
      state = const DriverTripState.completed();
    } catch (ex) {
      state = DriverTripState.error(ex.toString());
    }
  }
}

final driverTripProvider =
    StateNotifierProvider<DriverTripVM, DriverTripState>((ref) {
  return DriverTripVM(ref.read);
});
