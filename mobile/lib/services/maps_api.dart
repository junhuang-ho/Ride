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
}
