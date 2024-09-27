import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../domain/store.dart';
import '../func/httpFunc.dart';

class MarkerProvider with ChangeNotifier {
  List<Marker> _markerList = [];

  List<Marker> get markerList => _markerList;

  MarkerProvider() {
    initializeProvider();
  }

  initializeProvider() async {
    List<Store> stores = await HTTPFunc().getAllStores();
    List<Marker> newMarker = [];

    for (Store store in stores) {
      newMarker.add(
          Marker(
            point: LatLng(store.latitude, store.longitude),
            width: 80,
            height: 80,
            child: Icon(Icons.location_on, color: Colors.red, size: 40),
          )
      );
    }

    _markerList = newMarker;
    notifyListeners();
  }
}
