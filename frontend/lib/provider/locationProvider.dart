import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationProvider with ChangeNotifier {
  Position? _currentPosition;
  Position? get currentPosition => _currentPosition;

  LocationProvider() {
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    print('Initializing location...');
    await _requestLocationPermission();
    if (await Geolocator.isLocationServiceEnabled()) {
      try {
        _currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        print('Current position: $_currentPosition');
        notifyListeners();
      } catch (e) {
        print('Error getting location: $e');
      }
    } else {
      print('Location services are not enabled');
    }
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      print('Location permission granted');
    } else if (status.isDenied) {
      print('Location permission denied');
    } else if (status.isPermanentlyDenied) {
      print('Location permission permanently denied');
      // You might want to direct the user to settings
      openAppSettings();
    } else {
      print('Location permission status: ${status.toString()}');
    }
  }

  Future<void> updateLocation() async {
    if (await Geolocator.isLocationServiceEnabled()) {
      try {
        _currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        print('Updated position: $_currentPosition');
        notifyListeners();
      } catch (e) {
        print('Error updating location: $e');
      }
    } else {
      print('Location services are not enabled');
    }
  }
}
