import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/navigationProvider.dart';

class CustomBottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);

    return BottomNavigationBar(
      currentIndex: navigationProvider.currentIndex,
      onTap: (index) {
        navigationProvider.setCurrentIndex(index);
      },
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, color: Color(0xFF478CCF)),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map, color: Color(0xFF478CCF)),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle, color: Color(0xFF478CCF)),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings, color: Color(0xFF478CCF)),
          label: '',
        ),
      ],
    );
  }
}
