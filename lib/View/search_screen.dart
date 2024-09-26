import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../main.dart';


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
