class DriverApplication {
  late String driverId;
  late String createdAt;
  late String fileName;
  late String status;

  DriverApplication({
    required this.driverId,
    required this.status,
    required this.fileName,
    required this.createdAt,
  });

  DriverApplication.parseRaw(Object driverApplicant) {
    driverId = (driverApplicant as dynamic)['driver_id'];
    status = (driverApplicant as dynamic)['status'];
    fileName = (driverApplicant as dynamic)['file_name'];
    createdAt = (driverApplicant as dynamic)['created_at'];
  }
}
