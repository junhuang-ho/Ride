import 'package:ride/models/nearby_driver.dart';

class FireHelper {
  static List<NearbyDriver> _nearbyDriverList = [];

  static List<NearbyDriver> get nearbyDriverList => _nearbyDriverList;

  static void addNearbyDriver(NearbyDriver driver) {
    _nearbyDriverList.add(driver);
  }

  static void removeNearbyDriver(String key) {
    int index = _nearbyDriverList
        .indexWhere((existingDriver) => existingDriver.key == key);
    _nearbyDriverList.removeAt(index);
  }

  static void updateNearbyLocation(NearbyDriver driver) {
    int index = _nearbyDriverList
        .indexWhere((existingDriver) => existingDriver.key == driver.key);
    _nearbyDriverList[index].latitude = driver.latitude;
    _nearbyDriverList[index].longitude = driver.longitude;
  }
}
