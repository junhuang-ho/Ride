import 'package:connectivity/connectivity.dart';

class ConnectivityHelper {
  static Future<bool> hasConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      return false;
    }
    return true;
  }
}
