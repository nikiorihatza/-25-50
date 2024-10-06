import 'package:flutter/material.dart';
import 'package:frontend/func/httpFunc.dart';
import 'package:frontend/provider/locationProvider.dart';
import 'package:provider/provider.dart';
import '../domain/store.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Store>> futureStores;
  bool locationFetched = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchLocationAndStores();
    });
  }

  Future<void> _fetchLocationAndStores() async {
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);
    // Wait for the location to be initialized
    await locationProvider.updateLocation();

    if (locationProvider.currentPosition != null) {
      setState(() {
        locationFetched = true;
        futureStores = HTTPFunc().fetchNearestStores(locationProvider);
      });
    } else {
      // Handle case when location is not available or permission is denied
      setState(() {
        locationFetched = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Text(
              'Hallo!',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Shops in der Nähe',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          // The Expanded widget allows the loading indicator or list to take up the remaining space
          Expanded(
            child: locationFetched
                ? FutureBuilder<List<Store>>(
              future: futureStores,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  return buildStoreList(snapshot.data!);
                } else {
                  return Center(child: Text('Keine Shops gefunden'));
                }
              },
            )
                : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Suche nach deinem Standort...')
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Adjust the list height
  Widget buildStoreList(List<Store> stores) {
    return SizedBox(
      height: 150, // This sets the height of the horizontal list
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: stores.length,
        itemBuilder: (context, index) {
          final store = stores[index];
          return Container(
            width: 250,
            margin: EdgeInsets.only(right: 16),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  store.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  store.fullAddress,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}