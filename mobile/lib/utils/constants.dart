import 'dart:typed_data';

import 'package:google_maps_flutter/google_maps_flutter.dart';

const String kMapKey = 'AIzaSyAVNxJ3yx19d-BCI8g8jc6lstDC9xU2u08';

const CameraPosition kGooglePlex = CameraPosition(
  target: LatLng(37.42796133580664, -122.085749655962),
  zoom: 14.4746,
);

class Strings {
  static const String allZeroIn64Hex =
      '0000000000000000000000000000000000000000000000000000000000000000';
  static const String getTicketFailed = 'FAILED TO GET TICKET';
  static const String ticketNotFound = 'TICKET NOT FOUND';
}
