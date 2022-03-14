import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/models/ride_request.dart';
import 'package:ride/services/ride/ride_passenger.dart';
import 'package:ride/utils/constants.dart';
import 'package:ride/utils/fire_helper.dart';
import 'package:web3dart/web3dart.dart';

part 'passenger.trip.vm.freezed.dart';

@freezed
class PassengerTripState with _$PassengerTripState {
  const factory PassengerTripState.init() = _PassengerTripInit;
  const factory PassengerTripState.error(String? message) = _PassengerTripError;
  const factory PassengerTripState.driverAddressNotMatched() =
      _PassengerTripDriverAddressNotMatched;
  const factory PassengerTripState.startingTrip() = _PassengerTripStartingTrip;
  const factory PassengerTripState.onTheWay(String tixId) =
      _PassengerTripOnTheWay;
  const factory PassengerTripState.endingTrip() = _PassengerTripEndingTrip;
  const factory PassengerTripState.ended() = _PassengerTripEnded;
}

class PassengerTripVM extends StateNotifier<PassengerTripState> {
  PassengerTripVM(Reader read)
      : _ridePassenger = read(ridePassengerProvider),
        super(const PassengerTripState.init());

  final RidePassengerService _ridePassenger;
  late RideRequest acceptedRideRequest;

  Future<void> startTrip(String scannedAddress, RideRequest rideRequest) async {
    try {
      if (scannedAddress != rideRequest.driverId) {
        state = const PassengerTripState.driverAddressNotMatched();
        return;
      }
      state = const PassengerTripState.startingTrip();
      await _ridePassenger
          .startTrip(EthereumAddress.fromHex(rideRequest.driverId));

      updateOnTheWay(rideRequest);
    } catch (ex) {
      state = PassengerTripState.error(ex.toString());
    }
  }

  void updateOnTheWay(RideRequest rideRequest) {
    acceptedRideRequest = rideRequest;
    state = PassengerTripState.onTheWay(acceptedRideRequest.tixId);
  }

  Future<void> endTrip(bool agreed, int rating) async {
    try {
      state = const PassengerTripState.endingTrip();
      final rideRequestStatus =
          agreed ? Strings.paxAgreed : Strings.paxDisagreed;

      await FireHelper.updateRideRequest(
        acceptedRideRequest.tixId,
        {"status": rideRequestStatus},
      );

      if (agreed) {
        await _ridePassenger.endTrip(agreed, BigInt.from(rating));
        state = const PassengerTripState.ended();
      } else {
        state = PassengerTripState.onTheWay(acceptedRideRequest.tixId);
      }
    } catch (ex) {
      state = PassengerTripState.error(ex.toString());
    }
  }
}

final passengerTripProvider =
    StateNotifierProvider<PassengerTripVM, PassengerTripState>((ref) {
  return PassengerTripVM(ref.read);
});
