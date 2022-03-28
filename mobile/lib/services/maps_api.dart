import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride/utils/constants.dart';
import 'package:ride/utils/request_helper.dart';

class MapsAPI {
  static Future<dynamic> geocode(
    double latitude,
    double longitude,
  ) async {
    String url = 'https://maps.googleapis.com/maps/api/geocode/json?'
        'latlng=$latitude,$longitude&key=$kMapKey';
    return await RequestHelper.get(url);
  }

  static Future<dynamic> placeAutoComplete(
      String placeName, String sessionToken) async {
    String url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?'
        'input=$placeName&key=$kMapKey&sessiontoken=$sessionToken'
        '&components=country:my';
    return await RequestHelper.get(url);
  }

  static Future<dynamic> placeDetails(
      String placeId, String sessionToken) async {
    String url = 'https://maps.googleapis.com/maps/api/place/details/json?'
        'place_id=$placeId&key=$kMapKey&sessiontoken=$sessionToken';
    return await RequestHelper.get(url);
  }

  static Future<dynamic> directions(
      LatLng startPosition, LatLng endPosition) async {
    String url = 'https://maps.googleapis.com/maps/api/directions/json?'
        'origin=${startPosition.latitude},${startPosition.longitude}'
        '&destination=${endPosition.latitude},${endPosition.longitude}'
        '&mode=driving&key=$kMapKey';
    return await RequestHelper.get(url);
  }
}
