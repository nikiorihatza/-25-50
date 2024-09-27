import 'dart:convert';

class Store {
  final int id;
  final String name;
  final int postcode;
  final String city;
  final String country;
  final String address;
  final double latitude;
  final double longitude;
  final String fullAddress;

  Store({
    required this.id,
    required this.name,
    required this.postcode,
    required this.city,
    required this.country,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.fullAddress,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'],
      name: json['name'],
      postcode: json['postcode'],
      city: json['city'],
      country: json['country'],
      address: json['address'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      fullAddress: json['fullAddress'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'postcode': postcode,
      'city': city,
      'country': country,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'fullAddress': fullAddress,
    };
  }
}