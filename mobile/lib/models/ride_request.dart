class RideRequest {
  late String tixId;
  late String status;
  late String driverId;
  late String destinationAddress;
  late String pickupAddress;
  late String createdAt;

  RideRequest({
    required this.tixId,
    required this.status,
    required this.driverId,
    required this.destinationAddress,
    required this.pickupAddress,
    required this.createdAt,
  });

  RideRequest.parseRaw(Object rideRequest) {
    tixId = (rideRequest as dynamic)['tix_id'];
    status = (rideRequest as dynamic)['status'];
    driverId = (rideRequest as dynamic)['driver_id'];
    destinationAddress = (rideRequest as dynamic)['destination_address'];
    pickupAddress = (rideRequest as dynamic)['pickup_address'];
    createdAt = (rideRequest as dynamic)['created_at'];
  }
}
