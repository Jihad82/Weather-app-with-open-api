import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../main.dart';

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
              // const SizedBox(height: 10),
              // Text(
              //   _weatherData!['current']['condition']['text'],
              //   style: const TextStyle(fontSize: 15, color: Colors.white),
              // ),
              const SizedBox(height: 10),
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Hourly Forecast",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold, color: Colors.white),)
                    ],
                  ),
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
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Weekly forecast",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold, color: Colors.white),)
                    ],
                  ),
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
