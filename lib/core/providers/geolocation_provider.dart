import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

// Define a data class for a place
class Place {
  final double latitude;
  final double longitude;
  final double radius; // Radius in meters

  Place({
    required this.latitude,
    required this.longitude,
    required this.radius,
  });
}

// Initialize WorkManager periodically
// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     Position position = await Geolocator.getCurrentPosition(
//       locationSettings: const LocationSettings(
//         accuracy: LocationAccuracy.high,
//       ),
//     );

//     double latitude = position.latitude;
//     double longitude = position.longitude;

//     // Get address from coordinates
//     List<Placemark> placemarks =
//         await placemarkFromCoordinates(latitude, longitude);
//     Placemark placemark = placemarks[0];
//     String address =
//         '${placemark.street}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}';

//     // Save location and address to Shared Preferences
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setDouble('latitude', latitude);
//     await prefs.setDouble('longitude', longitude);
//     await prefs.setString('address', address);

//     return Future.value(true); // Indicates successful task execution
//   });
// }

class GeolocationProvider extends ChangeNotifier {
  double? latitude;
  double? longitude;
  String address = 'Fetching address...';
  bool isWithinRadius = false;
  late LocationSettings locationSettings;

  // Define multiple places with their radii
  final List<Place> _places = [
    Place(latitude: 19.0777475, longitude: 72.9974897, radius: 5),
    Place(latitude: 19.0877475, longitude: 72.9874897, radius: 10),
    // Add more places as needed
  ];

  StreamSubscription<Position>? _positionStreamSubscription;

  GeolocationProvider() {
    _initializeLocationTracking();
    // _initWorkManager();
  }

  void _initializeLocationTracking() async {
    await _requestLocationPermission();
    await _loadSavedLocation(); // Load saved location on initialization

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 2, // meter
      ),
    ).listen((Position position) {
      latitude = position.latitude;
      longitude = position.longitude;
      _updateAddress(position.latitude, position.longitude);
      _checkRadius(position.latitude, position.longitude);
      notifyListeners();
    });
  }

  // Request location permissions
  Future<void> _requestLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      final note = await Geolocator.openLocationSettings();
      if (note == false) {
        return Future.error('Location services are disabled.');
      }
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }
  }

  Future<Position?> getCurrentLocation() async {
    await _requestLocationPermission();
    address = "Fetching address...";
    notifyListeners();

    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
    await _updateAddress(position.latitude, position.longitude);
    notifyListeners();
    return position;
  }

  // Load the saved location from Shared Preferences
  Future<void> _loadSavedLocation() async {
    final prefs = await SharedPreferences.getInstance();
    latitude = prefs.getDouble('latitude');
    longitude = prefs.getDouble('longitude');
    address = prefs.getString('address') ?? 'Fetching address...';
    _checkRadius(latitude ?? 0, longitude ?? 0);
    notifyListeners();
  }

  // Initialize WorkManager
  // void _initWorkManager() {
  //   Workmanager().initialize(
  //     callbackDispatcher, // The top-level function
  //     isInDebugMode: true,
  //   );

  //   // Register a periodic task to run every 15 minutes
  //   Workmanager().registerPeriodicTask(
  //     "locationTask",
  //     "locationBackgroundTask",
  //     frequency: const Duration(minutes: 1), // Minimum interval on Android
  //   );
  // }

  // Update address from coordinates
  Future<void> _updateAddress(double lat, double lon) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
      Placemark placemark = placemarks[0];
      address =
          '${placemark.street}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}';
    } catch (e) {
      address = 'Address not found';
    }
  }

  // Check if within any radius of defined places
  void _checkRadius(double currentLat, double currentLon) {
    isWithinRadius = _places.any((place) =>
        Geolocator.distanceBetween(
          place.latitude,
          place.longitude,
          currentLat,
          currentLon,
        ) <=
        place.radius);
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }
}
