import 'package:flutter/material.dart';
import 'package:frontend/func/httpFunc.dart';
import 'package:frontend/provider/locationProvider.dart';
import 'package:frontend/provider/markerProvider.dart';
import 'package:frontend/provider/tokenProvider.dart';
import 'package:provider/provider.dart';
import 'provider/navigationProvider.dart';
import 'pages/mainPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _apiToken;

  @override
  void initState() {
    super.initState();
    _fetchApiTokenOnStart();
  }

  Future<void> _fetchApiTokenOnStart() async {
    try {
      final token = await HTTPFunc().fetchApiToken();
      setState(() {
        _apiToken = token;
      });
    } catch(e) {
      print("Error fetching token: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => TokenProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => MarkerProvider()),
      ],
      child: MaterialApp(
        title: '-25-50',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MainPage(),
      ),
    );
  }
}
