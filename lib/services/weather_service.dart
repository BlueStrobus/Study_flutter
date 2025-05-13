// JSON 인코딩 및 디코딩을 위한 내장 라이브러리
import 'dart:convert';

// HTTP 요청을 보내기 위한 패키지 (get, post 등)
import 'package:http/http.dart' as http;

// .env 파일에서 환경변수(.env 파일의 API 키 등)를 불러오기 위한 패키지
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherService {
  static final String _apiKey = dotenv.env['OPENWEATHER_API_KEY'] ?? '';

  static Future<Map<String, dynamic>> fetchWeather(
    double lat,
    double lon,
  ) async {
    final url =
        'https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&appid=$_apiKey&units=metric&lang=kr';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('날씨 데이터를 불러오지 못했습니다');
    }
  }
}
