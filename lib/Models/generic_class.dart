import 'package:location/location.dart';

class GeneriOps{
  static bool checkValidEntero(String nro) {
    RegExp expr = RegExp(r"^[1-9][0-9]*$|^[0-9]$");
    bool resp = expr.hasMatch(nro);
    return resp;
  }

  static bool checValidFloat(String fltNmbr) {
    RegExp expr = RegExp(r'^[0-9][0-9]*$|^[0-9][0-9]*\.[0-9]+$');
    bool resp = expr.hasMatch(fltNmbr);
    return resp;
  }

  static Future<bool> handleLocationPermission() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return false;
      }
      permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted == PermissionStatus.denied) {
          return false;
        }
      }
      return true;
    } else {
      permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted == PermissionStatus.denied) {
          return false;
        }
        return true;
      } else {
        return true;
      }
    }
  }
}