import 'package:flutter/material.dart';
import 'package:frontend/pages/settingsPage.dart';
import 'package:provider/provider.dart';
import '../provider/navigationProvider.dart';
import '../widgets/customBottomNavBar.dart';
import 'accountPage.dart';
import 'homePage.dart';
import 'mapPage.dart';

class MainPage extends StatelessWidget {
  final List<Widget> _pages = [
    HomePage(),
    MapPage(),
    AccountPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);

    return Scaffold(
      body: _pages[navigationProvider.currentIndex],
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}