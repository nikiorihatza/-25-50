import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../domain/store.dart';
import '../provider/locationProvider.dart';

class HTTPFunc {
  String _apiUrl = 'http://192.168.1.127:8080';

  Future<String?> fetchApiToken() async {
    final url = Uri.parse('$_apiUrl/api/token');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      print('Failed to fetch token: ${response.statusCode}');
      return null;
    }
  }

  Future<List<Store>> getAllStores() async {
    final url = Uri.parse('$_apiUrl/api/store/getAll');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      List<Store> stores = jsonResponse.map((json) => Store.fromJson(json)).toList();

      return stores;
    } else {
      print('Failed to fetch stores: ${response.statusCode}');
      return [];
    }
  }

  Future<List<Store>> searchData(String query) async {
    List<Store> stores = [];

    try {
      final storesResponse = await http.get(Uri.parse('$_apiUrl/api/store/getAll'));
      if (storesResponse.statusCode == 200) {
        final List<dynamic> storeJsonList = json.decode(storesResponse.body);

        stores = storeJsonList.map((json) => Store.fromJson(json)).toList();

        if (RegExp(r'^\d{12,13}$').hasMatch(query)) {
          final productResponse = await http.get(Uri.parse('$_apiUrl/api/saleproducts/getByEa?ean=$query'));

          if (productResponse.statusCode == 200) {
            final Map<String, dynamic> productJson = json.decode(productResponse.body);

            if (productJson.containsKey('store')) {
              stores.add(Store.fromJson(productJson['store']));
            }
          }
        }

        stores = stores.where((store) {
          final lowerQuery = query.toLowerCase();
          return store.name.toLowerCase().contains(lowerQuery) ||
              store.fullAddress.toLowerCase().contains(lowerQuery);
        }).toList();
      }
    } catch (e) {
      print('Error fetching data: $e');
    }

    return stores;
  }

  Future<List<Store>> fetchNearestStores(LocationProvider locationProvider) async {
    final Position? position = locationProvider.currentPosition;

    if (position == null) {
      throw Exception('Location not available');
    }

    final String currentLocation = '${position.latitude},${position.longitude}';

    final response = await http.get(Uri.parse('$_apiUrl/api/store/giveSortedByNearest?currentLocation=$currentLocation'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((store) => Store.fromJson(store)).toList();
    } else {
      throw Exception('Failed to load stores');
    }
  }

}

