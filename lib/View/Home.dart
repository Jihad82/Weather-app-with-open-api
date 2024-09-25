// import 'package:flutter/material.dart';
//
// class WeatherScreen extends StatelessWidget {
//   final Map<String, dynamic> weatherData;
//
//   WeatherScreen(this.weatherData);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blueAccent,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               Text(
//                 weatherData['location']['name'],
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 '${weatherData['current']['temp_c']}°',
//                 style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: Colors.white),
//               ),
//               SizedBox(height: 10),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Image.network(
//                     'https:${weatherData['current']['condition']['icon']}',
//                     width: 50,
//                   ),
//                   SizedBox(width: 10),
//                   Text(
//                     weatherData['current']['condition']['text'],
//                     style: TextStyle(fontSize: 20, color: Colors.white),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20),
//               Expanded(
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: weatherData['forecast']['forecastday'][0]['hour'].length,
//                   itemBuilder: (context, index) {
//                     var hourData = weatherData['forecast']['forecastday'][0]['hour'][index];
//                     return Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Column(
//                         children: [
//                           Text('${hourData['time'].substring(11)}', style: TextStyle(color: Colors.white)),
//                           Image.network('https:${hourData['condition']['icon']}', width: 30),
//                           Text('${hourData['temp_c']}°', style: TextStyle(color: Colors.white)),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }