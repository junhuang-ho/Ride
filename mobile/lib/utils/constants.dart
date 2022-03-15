import 'package:google_maps_flutter/google_maps_flutter.dart';

const String kMapKey = 'AIzaSyAVNxJ3yx19d-BCI8g8jc6lstDC9xU2u08';

const CameraPosition kGooglePlex = CameraPosition(
  target: LatLng(37.42796133580664, -122.085749655962),
  zoom: 14.4746,
);

const CameraPosition kKualaLumpurPlex = CameraPosition(
  target: LatLng(3.140853, 101.693207),
  zoom: 14,
);

class Strings {
  static const String allZeroIn64Hex =
      '0000000000000000000000000000000000000000000000000000000000000000';
  static const String getTicketFailed = 'FAILED TO GET TICKET';
  static const String ticketNotFound = 'TICKET NOT FOUND';
  static const String pendingApproval = 'pending_approval';
  static const String approved = 'approved';
  static const String rejected = 'rejected';
  static const String waiting = 'waiting';
  static const String accepted = 'accepted';
  static const String arrived = 'arrived';
  static const String ontrip = 'ontrip';
  static const String destReached = 'dest_reached';
  static const String destNotReached = 'dest_not_reached';
  static const String paxAgreed = 'pax_agreed';
  static const String paxDisagreed = 'pax_disagreed';
  static const String driversAvailable = 'drivers_available';
}
