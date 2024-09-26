import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/View/search_screen.dart';
import 'package:weather_app/View/settings_screen.dart';
import 'package:weather_app/View/weather_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  String _currentCity = 'Dhaka'; // Default city is Dhaka
  String? _errorMessage; // Store error message if any

  final List<Widget> _screens = [];

  void _updateScreens(String city, {String? error}) {
    _screens.clear();
    _screens.addAll([
      WeatherScreen(city: city, errorMessage: error), // Home screen shows updated weather
      SearchScreen(onSearchComplete: (searchedCity, error) {
        setState(() {
          _currentCity = searchedCity; // Update current city
          _errorMessage = error; // Set the error message if any
          _selectedIndex = 0; // Navigate back to Home screen
        });
      }),
      SettingsScreen(),
    ]);
  }

  @override
  void initState() {
    super.initState();
    _updateScreens(_currentCity); // Initialize screens
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    _updateScreens(_currentCity, error: _errorMessage);
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: CrystalNavigationBar(
          currentIndex: _selectedIndex,
          height: 10,
          unselectedItemColor: Colors.white70,
          backgroundColor: Colors.black.withOpacity(0.1),
          selectedItemColor: Colors.white,
          onTap: _onItemTapped,
          items: [
            /// Home
            CrystalNavigationBarItem(
              icon: Icons.add_home_outlined, // Corrected
              unselectedIcon:Icons.add_home_outlined,// Corrected
            ),
            /// Search
            CrystalNavigationBarItem(
              icon: Icons.search_rounded, // Corrected
              unselectedIcon: Icons.search_rounded,// Corrected
            ),
            /// Settings
            CrystalNavigationBarItem(
              icon: Icons.person_outline_outlined, // Corrected
              unselectedIcon:Icons.person_outline_outlined, // Corrected
            ),
          ],
        ),
      ),
    );
  }
}