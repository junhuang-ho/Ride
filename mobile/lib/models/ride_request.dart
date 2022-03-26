class RideRequest {
  late String tixId;
  late String status;
  late String driverId;
  late String passengerId;
  late String destinationAddress;
  late String destination;
  late String pickupAddress;
  late String location;
  late String distanceText;
  late int distanceValue;
  late String durationText;
  late int durationValue;
  late BigInt tripFare;
  late String createdAt;

  RideRequest({
    required this.tixId,
    required this.status,
    required this.driverId,
    required this.passengerId,
    required this.destinationAddress,
    required this.destination,
    required this.pickupAddress,
    required this.location,
    required this.distanceText,
    required this.distanceValue,
    required this.durationText,
    required this.durationValue,
    required this.tripFare,
    required this.createdAt,
  });

  RideRequest.parseRaw(Object rideRequest) {
    tixId = (rideRequest as dynamic)['tix_id'];
    status = (rideRequest as dynamic)['status'];
    driverId = (rideRequest as dynamic)['driver_id'];
    passengerId = (rideRequest as dynamic)['passenger_id'];
    destinationAddress = (rideRequest as dynamic)['destination_address'];
    pickupAddress = (rideRequest as dynamic)['pickup_address'];
    distanceText = (rideRequest as dynamic)['distance_text'];
    distanceValue = (rideRequest as dynamic)['distance_value'];
    durationText = (rideRequest as dynamic)['duration_text'];
    durationValue = (rideRequest as dynamic)['duration_value'];
    tripFare = BigInt.from((rideRequest as dynamic)['trip_fare']);
    createdAt = (rideRequest as dynamic)['created_at'];
  }
}
