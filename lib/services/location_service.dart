import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<Position> getCurrentLocation() async {
    // Geolocator.isLocationServiceEnabled() : 기기에서 위치 서비스가 활성화되어 있는지 여부를 나타내는 [bool] 값을 포함하는 [Future]를 반환합니다.
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('위치 서비스가 꺼져있습니다');
    }

    // Geolocator.checkPermission() : 위치 권한을 확인합니다. 권한이 없으면 Geolocator.requestPermission()을 호출하여 권한 요청을 합니다.
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Geolocator.requestPermission() : 위치 권한을 요청합니다. 사용자가 권한을 부여하면 [LocationPermission] 값을 반환합니다.
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('위치 권한이 거부되었습니다');
      }
    }

    return await Geolocator.getCurrentPosition();
  }
}
