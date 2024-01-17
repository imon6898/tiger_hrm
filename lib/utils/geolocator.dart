import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Add this import for LatLng
import 'package:geocoding/geocoding.dart'; // Add this import for locationFromAddress

class LocationService {
  static Position? currentLocation;
  static bool haveLocationPermission = false;

  static Future<String?> getLocationPlusCode(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        String name = placemarks.first.name ?? '';
        String plusCode = extractPlusCode(name);
        return plusCode;
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting location Plus Code: $e');
      return null;
    }
  }

  static String extractPlusCode(String name) {
    // Extract the Plus Code from the name
    RegExp regex = RegExp(r'([A-Z0-9]+[+]+[A-Z0-9]+)');
    String plusCode = regex.stringMatch(name) ?? '';
    return plusCode;
  }

  static Future<bool> locationPermissionCheck() async {
    LocationPermission permission = await Geolocator.checkPermission();

    haveLocationPermission =
    (permission == LocationPermission.always || permission == LocationPermission.whileInUse);

    if (!haveLocationPermission) {
      permission = await Geolocator.requestPermission();
      haveLocationPermission =
      (permission == LocationPermission.always || permission == LocationPermission.whileInUse);

      if (!haveLocationPermission) {
        // Location permission denied, close the app
        closeApp();
      }

      return haveLocationPermission;
    }

    return haveLocationPermission;
  }

  static Future<Position?> get({Function? currentState}) async {
    await locationPermissionCheck();

    if (!haveLocationPermission) {
      return null;
    }

    try {
      currentLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      return null;
    }

    if (currentState != null) {
      currentState();
    }

    print("currentLocation: ${currentLocation!.latitude}");
    return currentLocation;
  }

  static void closeApp() {
    // Send a platform-specific message to close the app
    //SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }
}

class LocationConverter {
  static Future<LatLng?> getLocationFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        double latitude = locations.first.latitude;
        double longitude = locations.first.longitude;
        return LatLng(latitude, longitude);
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting location from address: $e');
      return null;
    }
  }
}
