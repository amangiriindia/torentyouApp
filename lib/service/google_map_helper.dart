//
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart'; // Import the geocoding package
//
// // Helper class for Google Maps related functions
// class GoogleMapHelper {
//   // Static function to get the current location and return a formatted string
//   static Future<String> getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     // Check if location services are enabled
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return "Location services are disabled.";
//     }
//
//     // Check if permission is granted
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return "Location permissions are denied.";
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       return "Location permissions are permanently denied.";
//     }
//
//     // Get the current location
//     Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );
//
//     // Convert the coordinates to an address
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//         position.latitude,
//         position.longitude,
//       );
//       Placemark place = placemarks[0];
//
//       // Format: "City, State - Pincode"
//       String formattedLocation =
//           "${place.locality}, ${place.administrativeArea} - ${place.postalCode}";
//
//       return formattedLocation;
//     } catch (e) {
//       return "Failed to get the address.";
//     }
//   }
//
//   // Static function to update address for API with latitude and longitude
//   static Future<Map<String, double>?> updateAddressForApi() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     // Check if location services are enabled
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       print("Location services are disabled.");
//       return null;
//     }
//
//     // Check if permission is granted
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         print("Location permissions are denied.");
//         return null;
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       print("Location permissions are permanently denied.");
//       return null;
//     }
//
//     // Get the current location
//     Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );
//
//     // Return the latitude and longitude as a map
//     return {
//       'latitude': position.latitude,
//       'longitude': position.longitude,
//     };
//   }
// }



import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

/// Helper class for Google Maps related functions and location services
class GoogleMapHelper {

  /// Get the current location and return a formatted string
  /// Returns: "City, State - Pincode" format
  static Future<String> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return "Location services are disabled.";
    }

    // Check if permission is granted
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return "Location permissions are denied.";
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return "Location permissions are permanently denied.";
    }

    // Get the current location
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      // Convert the coordinates to an address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        // Format: "City, State - Pincode"
        String formattedLocation = "${place.locality ?? 'Unknown'}, ${place.administrativeArea ?? 'Unknown'} - ${place.postalCode ?? ''}";

        return formattedLocation;
      } else {
        return "Failed to get the address.";
      }
    } catch (e) {
      print('Error getting current location: $e');
      return "Failed to get the address: ${e.toString()}";
    }
  }

  /// Get coordinates for API calls
  /// Returns: Map with latitude and longitude as double values
  static Future<Map<String, double>?> updateAddressForApi() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Location services are disabled.");
      return null;
    }

    // Check if permission is granted
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Location permissions are denied.");
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("Location permissions are permanently denied.");
      return null;
    }

    // Get the current location
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      // Return the latitude and longitude as a map
      return {
        'latitude': position.latitude,
        'longitude': position.longitude,
      };
    } catch (e) {
      print('Error getting coordinates: $e');
      return null;
    }
  }

  /// Get city and state from coordinates using reverse geocoding
  /// Returns: Map with city, state, and pincode information
  static Future<Map<String, String?>> getCityAndStateFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        return {
          'city': place.locality,
          'state': place.administrativeArea,
          'pincode': place.postalCode,
          'subLocality': place.subLocality,
          'country': place.country,
          'street': place.street,
          'name': place.name,
        };
      } else {
        return {
          'city': null,
          'state': null,
          'pincode': null,
          'subLocality': null,
          'country': null,
          'street': null,
          'name': null,
        };
      }
    } catch (e) {
      print('Error getting city and state from coordinates: $e');
      return {
        'city': null,
        'state': null,
        'pincode': null,
        'subLocality': null,
        'country': null,
        'street': null,
        'name': null,
        'error': e.toString(),
      };
    }
  }

  /// Check if location services are available
  /// Returns: true if location services are enabled and permissions are granted
  static Future<bool> isLocationServiceAvailable() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return false;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return false;
      }

      return true;
    } catch (e) {
      print('Error checking location service availability: $e');
      return false;
    }
  }

  /// Request location permissions
  /// Returns: true if permission is granted
  static Future<bool> requestLocationPermission() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      return permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always;
    } catch (e) {
      print('Error requesting location permission: $e');
      return false;
    }
  }

  /// Get current position with error handling
  /// Returns: Position object or null if failed
  static Future<Position?> getCurrentPosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return null;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      );

      return position;
    } catch (e) {
      print('Error getting current position: $e');
      return null;
    }
  }

  /// Calculate distance between two coordinates in kilometers
  /// Returns: distance in kilometers
  static double calculateDistance(
      double startLatitude,
      double startLongitude,
      double endLatitude,
      double endLongitude,
      ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    ) / 1000; // Convert to kilometers
  }

  /// Open device location settings
  static Future<bool> openLocationSettings() async {
    try {
      return await Geolocator.openLocationSettings();
    } catch (e) {
      print('Error opening location settings: $e');
      return false;
    }
  }

  /// Open app-specific location settings
  static Future<bool> openAppSettings() async {
    try {
      return await Geolocator.openAppSettings();
    } catch (e) {
      print('Error opening app settings: $e');
      return false;
    }
  }
}