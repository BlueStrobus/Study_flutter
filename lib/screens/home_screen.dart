// lib\screens\home_screen.dart

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';
import '../services/weather_service.dart';
import 'package:intl/intl.dart';

String getWeekday(int timestamp) {
  final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  return DateFormat.E('ko').format(date); // 월, 화, 수,...
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? weatherData;

  double? _latitude;
  double? _longitude;

  bool useCustomLocation = false;
  double? customLat;
  double? customLon;

  Widget _buildWeeklyForecast() {
    if (weatherData == null) return const SizedBox();

    final daily = weatherData!['daily'];

    return SizedBox(
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (context, index) {
          final day = daily[index];
          final dt = day['dt'];
          final min = day['temp']['min'].toDouble();
          final max = day['temp']['max'].toDouble();
          final icon = day['weather'][0]['icon'];

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            width: 80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(getWeekday(dt),
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Image.network(
                  'https://openweathermap.org/img/wn/$icon.png',
                  width: 40,
                  height: 40,
                ),
                Text('${min.toStringAsFixed(0)}° / ${max.toStringAsFixed(0)}°',
                    style: const TextStyle(fontSize: 12)),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadLocationAndWeather();
  }

  Future<void> _loadLocationAndWeather() async {
    try {
      double lat;
      double lon;

      if (useCustomLocation && customLat != null && customLon != null) {
        lat = customLat!;
        lon = customLon!;
      } else {
        final position = await LocationService.getCurrentLocation();
        lat = position.latitude;
        lon = position.longitude;
      }

      final weather = await WeatherService.fetchWeather(lat, lon);
      setState(() {
        _latitude = lat;
        _longitude = lon;
        weatherData = weather;
      });
    } catch (e) {
      debugPrint('위치/날씨 에러: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ઇଓ FLY 다이어리'), centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            // 전체 화면 스크롤 가능
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blue,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text("현재 날씨"),
                      //  _buildPlaceholderBox("현재 날씨"),
                      Text("하루 기온 변화"),
                      //  _buildPlaceholderBox("하루 기온 변화"),

                      //  _buildWeeklyForecast(),
                      Text("일주일 날씨"),
                      _buildPlaceholderBox("일기예보"),
                    ],
                  ),
                ),
                SizedBox(height: 8), //

                Row(
                  // 기능 버튼
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildFeatureButton(
                      context: context,
                      icon: Icons.edit,
                      color: Colors.teal,
                      onPressed: () => Navigator.pushNamed(context, '/diary'),
                    ),
                    SizedBox(width: 8), //
                    _buildFeatureButton(
                      context: context,
                      icon: Icons.calendar_month,
                      color: Colors.orange,
                      onPressed: () =>
                          Navigator.pushNamed(context, '/schedule'),
                    ),

                    SizedBox(width: 8), //
                    _buildFeatureButton(
                      context: context,
                      icon: Icons.checklist,
                      color: Colors.green,
                      onPressed: () => Navigator.pushNamed(context, '/todo'),
                    ),

                    SizedBox(width: 8), //
                    _buildFeatureButton(
                      context: context,
                      icon: Icons.settings,
                      color: Colors.blue,
                      onPressed: () =>
                          Navigator.pushNamed(context, '/settings'),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                Text("최신 일기"),
                _buildPlaceholderBox("최신 일기"), // 최신 일기
                // _buildHorizontalList(latestPosts),
                const SizedBox(height: 16),
                Text("최신 할 일"),
                _buildPlaceholderBox("최신 할 일"), // 최신 할 일
                //  _buildHorizontalList(latestPosts),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 일기예보
  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('위치 서비스 꺼져 있음');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('위치 권한 거부됨');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  Widget _buildHorizontalList(List<Widget> items) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: items[index],
          );
        },
      ),
    );
  }

  Widget _buildFeatureButton({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          backgroundColor: color,
          radius: 30,
          child: IconButton(
            icon: Icon(icon, color: Colors.white),
            onPressed: onPressed,
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderBox(String label) {
    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade300,
      ),
      child: Center(
        child: Text(
          '$label 구현 예정',
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ),
    );
  }
}
/*
Widget _buildFeatureButton(BuildContext context, IconData icon, Color color) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 0.0),
    child: ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        minimumSize: const Size(60, 60),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Icon(icon, size: 30),
    ),
  );
}
*/
