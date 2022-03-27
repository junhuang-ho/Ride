class DriverApplication {
  late String driverId;
  late String createdAt;
  late String fileName;
  late String email;
  late String firstName;
  late String lastName;
  late String location;
  late String phoneNumber;
  late String status;

  DriverApplication({
    required this.driverId,
    required this.status,
    required this.fileName,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.location,
    required this.phoneNumber,
    required this.createdAt,
  });

  DriverApplication.parseRaw(Object driverApplicant) {
    driverId = (driverApplicant as dynamic)['driver_id'];
    status = (driverApplicant as dynamic)['status'];
    fileName = (driverApplicant as dynamic)['file_name'];
    email = (driverApplicant as dynamic)['email'] ?? 'raydalio@gmail.com';
    firstName = (driverApplicant as dynamic)['first_name'] ?? 'Ray';
    lastName = (driverApplicant as dynamic)['last_name'] ?? 'Dalio';
    location = (driverApplicant as dynamic)['location'] ?? 'New York';
    phoneNumber =
        (driverApplicant as dynamic)['phone_number'] ?? '+12332321212';
    createdAt = (driverApplicant as dynamic)['created_at'];
  }
}
