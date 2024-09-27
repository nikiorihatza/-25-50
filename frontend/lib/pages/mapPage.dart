import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:frontend/provider/markerProvider.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../func/httpFunc.dart';
import '../provider/tokenProvider.dart';
import '../provider/locationProvider.dart';

class MapPage extends StatefulWidget {
  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final TextEditingController _searchController = TextEditingController();
  final MapController _mapController = MapController();
  double _currentZoom = 13.0;

  @override
  void initState() {
    super.initState();
    Provider.of<LocationProvider>(context, listen: false).updateLocation();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    String query = _searchController.text;
    _searchForPlaces(query);
  }

  void _searchForPlaces(String query) async {
    var searchResults = await HTTPFunc().searchData(query);

    if (searchResults != null && searchResults.isNotEmpty) {
      setState(() {
        _mapController.move(LatLng(searchResults[0].latitude, searchResults[0].longitude), _currentZoom);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var markerProvider = Provider.of<MarkerProvider>(context, listen: true);

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 40,
            left: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search for a place...',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                    },
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            top: 100,
            child: Consumer2<TokenProvider, LocationProvider>(
              builder: (context, tokenProvider, locationProvider, child) {
                return FutureBuilder<String?>(
                  future: HTTPFunc().fetchApiToken(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error fetching token'));
                    } else if (snapshot.hasData && snapshot.data != null) {
                      final apiToken = snapshot.data;
                      final currentPosition = locationProvider.currentPosition;

                      return FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          initialCenter: currentPosition != null
                              ? LatLng(currentPosition.latitude, currentPosition.longitude)
                              : const LatLng(51.5, -0.09),
                          initialZoom: _currentZoom,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                            'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
                            additionalOptions: {
                              'accessToken': apiToken!,
                              'id': 'mapbox/streets-v11',
                            },
                            errorTileCallback: (tile, error, stackTrace) {
                              print('Failed to load tile: ${tile.coordinates.x}, ${tile.coordinates.y}');
                              print('Error: $error');
                              if (stackTrace != null) {
                                print('StackTrace: $stackTrace');
                              }
                            },
                          ),
                          MarkerLayer(
                            markers: markerProvider.markerList,
                          ),
                        ],
                      );
                    } else {
                      return Center(child: Text('Failed to fetch token'));
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
