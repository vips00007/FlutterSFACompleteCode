import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class GeocodingService {
  final Dio _dio = Dio();

  Future<String> getAddressFromCoordinates(double lat, double lon) async {
    if (lat == 0 && lon == 0) {
      return "Location not available";
    }

    try {
      final response = await _dio.get(
        'https://nominatim.openstreetmap.org/reverse',
        queryParameters: {'lat': lat, 'lon': lon, 'format': 'json'},
        options: Options(
          headers: {
            'User-Agent': 'FlutterPracticeSrLevel/1.0',
            'Accept-Language': 'en-US,en;q=0.5',
          },
          receiveTimeout: const Duration(seconds: 10),
          sendTimeout: const Duration(seconds: 10),
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        if (data['display_name'] != null && data['display_name'].toString().trim().isNotEmpty) {
          return data['display_name'].toString().trim();
        }
      }
      return "Location not available";
    } catch (e) {
      if (kDebugMode) {
        debugPrint("Geocoding failed for ($lat, $lon): $e");
      }
      return "Location not available";
    }
  }
}
