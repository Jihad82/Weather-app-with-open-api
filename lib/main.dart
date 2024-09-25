import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';

const String baseUrl = "http://api.weatherapi.com/v1/forecast.json?key=3385ff506c1b450182c152917242509";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}

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

// Weather Screen (Home)
// Weather Screen (Home)
class WeatherScreen extends StatefulWidget {
  final String city;
  final String? errorMessage;

  WeatherScreen({required this.city, this.errorMessage});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Map<String, dynamic>? _weatherData;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _fetchWeather(widget.city); // Fetch weather for the city
  }

  Future<void> _fetchWeather(String city) async {
    setState(() {
      _loading = true;
    });
    try {
      final response = await http.get(Uri.parse('$baseUrl&q=$city&days=7&aqi=no&alerts=no'));
      if (response.statusCode == 200) {
        setState(() {
          _weatherData = json.decode(response.body);
          _loading = false;
        });
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      setState(() {
        _loading = false;
      });
      if (widget.errorMessage != null) {
        setState(() {
          _weatherData = null;
        });
      }
    }
  }

  @override
  void didUpdateWidget(covariant WeatherScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.city != widget.city) {
      _fetchWeather(widget.city);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: SafeArea(

        child: Padding(

          padding: const EdgeInsets.all(16.0),
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : widget.errorMessage != null
              ? Center(
            child: Text(
              widget.errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 20),
            ),
          )
              : _weatherData != null
              ? Column(
            children: [
              Text(
                _weatherData!['location']['name'],
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    'https:${_weatherData!['current']['condition']['icon']}',
                    width: 100,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${_weatherData!['current']['temp_c']}°',
                    style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                _weatherData!['current']['condition']['text'],
                style: const TextStyle(fontSize: 15, color: Colors.white),
              ),
              const SizedBox(height: 40),
              const Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Hourly Forecast",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold, color: Colors.white),)
                  ],
                ),
              ),
              // Hourly Forecast
              SizedBox(
                height: 150, // Fixed height for hourly forecast
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _weatherData!['forecast']['forecastday'][0]['hour'].length,
                  itemBuilder: (context, index) {
                    var hourData = _weatherData!['forecast']['forecastday'][0]['hour'][index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 65,
                        height: 30,
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${hourData['time'].substring(11)}',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            Image.network(
                              'https:${hourData['condition']['icon']}',
                              width: 30,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '${hourData['temp_c']}°',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("7-day forecast",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold, color: Colors.white),)
                  ],
                ),
              ),
              // 7-day forecast
              Expanded(
                child: ListView.builder(
                  itemCount: _weatherData!['forecast']['forecastday'].length,
                  itemBuilder: (context, index) {
                    var dayData = _weatherData!['forecast']['forecastday'][index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          title: Text(
                            dayData['date'],
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${dayData['day']['condition']['text']} - Max: ${dayData['day']['maxtemp_c']}°, Min: ${dayData['day']['mintemp_c']}°',
                            style: const TextStyle(color: Colors.white),
                          ),
                          leading: Image.network(
                            'https:${dayData['day']['condition']['icon']}',
                            width: 50,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          )
              : const Center(child: Text('No weather data available')),
        ),
      ),
    );
  }
}



// Search Screen
class SearchScreen extends StatefulWidget {
  final Function(String, String?) onSearchComplete;

  SearchScreen({required this.onSearchComplete});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _controller = TextEditingController();
  bool _loading = false;
  String _errorMessage = '';

  Future<void> _searchWeather(String city) async {
    if (city.isNotEmpty) {
      try {
        setState(() {
          _loading = true;
          _errorMessage = '';
        });
        final response = await http.get(Uri.parse('$baseUrl&q=$city&days=1&aqi=no&alerts=no'));
        if (response.statusCode == 200) {
          setState(() {
            _loading = false;
          });
          widget.onSearchComplete(city, null); // Pass city and no error
        } else {
          throw Exception('Failed to load weather data');
        }
      } catch (e) {
        setState(() {
          _loading = false;
          _errorMessage = 'Can\'t fetch weather data. Please try again.';
        });
        widget.onSearchComplete(city, _errorMessage); // Pass error message
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Weather'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Enter city name',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    _searchWeather(_controller.text);
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            _loading
                ? const CircularProgressIndicator()
                : Text(
              _errorMessage,
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}

// Settings Screen
class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.blueAccent,
      ),
      body: const Center(
        child: Text('Settings Screen'),
      ),
    );
  }
}
