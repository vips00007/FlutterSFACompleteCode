import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../core/utils/shared_prefs_manager.dart';
import '../../models/attendance_request.dart';
import '../../models/attendance_response.dart';

class AttendanceApiService {
  final String baseUrl = "https://api-staging.rahulpatel.online";
  late final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    headers: {
      "Accept": "application/json",
    },
    validateStatus: (status) => status != null,
  ));

  Future<AttendanceResponse> checkIn(AttendanceRequest request) async {
    return _sendRequest("/api/v1/sfa/attendance/check-in", request);
  }

  Future<AttendanceResponse> checkOut(AttendanceRequest request) async {
    return _sendRequest("/api/v1/sfa/attendance/check-out", request);
  }

  Future<AttendanceResponse> _sendRequest(String endpoint, AttendanceRequest request) async {
    final token = SharedPrefsManager.getToken();
    if (token == null || token.isEmpty) {
      throw Exception("Authentication token not found. Please login again.");
    }

    final formData = FormData.fromMap({
      "selfie": await MultipartFile.fromFile(
        request.selfie,
        filename: "selfie.jpg",
      ),
      "latitude": request.latitude,
      "longitude": request.longitude,
      "accuracyMeters": request.accuracyMeters.round(),
      "capturedAt": request.capturedAt,
    });

    if (kDebugMode) {
      debugPrint("--- [ATTENDANCE REQUEST DEBUG (DIO)] ---");
      debugPrint("API URL: $baseUrl$endpoint");
      debugPrint("HTTP Method: POST");
      debugPrint("Authorization token present: ${token.isNotEmpty}");
      debugPrint("Token Preview: Bearer ${token.substring(0, token.length > 10 ? 10 : token.length)}...");
      debugPrint("Request parameter names: selfie (file), latitude, longitude, accuracyMeters, capturedAt");
      debugPrint("Selfie File Path: ${request.selfie}");
      debugPrint("Latitude: ${request.latitude}");
      debugPrint("Longitude: ${request.longitude}");
      debugPrint("Accuracy: ${request.accuracyMeters.round()}");
      debugPrint("CapturedAt: ${request.capturedAt}");
    }

    try {
      final response = await _dio.post(
        endpoint,
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      return _handleResponse(response);
    } catch (e) {
      if (e is Exception) rethrow;
      debugPrint("Dio Error: $e");
      throw Exception("Failed to connect to server: $e");
    }
  }

  Future<AttendanceResponse> _handleResponse(Response response) async {
    try {
      if (kDebugMode) {
        debugPrint("--- [ATTENDANCE RESPONSE RECEIVED (DIO)] ---");
        debugPrint("HTTP Status Code: ${response.statusCode}");
        debugPrint("Response Body: ${response.data}");
      }

      final data = response.data;
      if (data == null) {
        throw Exception("Server returned empty body (Status: ${response.statusCode})");
      }

      final Map<String, dynamic> json = data is String 
          ? Map<String, dynamic>.from(jsonDecode(data)) 
          : Map<String, dynamic>.from(data);
          
      final attendanceResponse = AttendanceResponse.fromJson(json);

      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        if (attendanceResponse.success && (attendanceResponse.code == "SUCCESS" || attendanceResponse.code == "200")) {
          return attendanceResponse;
        } else {
          debugPrint("--- [ATTENDANCE API ERROR] ---");
          debugPrint("API Error Code: ${attendanceResponse.code}");
          debugPrint("API Error Message: ${attendanceResponse.message}");
          debugPrint("API Errors: ${attendanceResponse.errors}");
          
          String msg = attendanceResponse.message.isNotEmpty
              ? attendanceResponse.message
              : "Attendance action failed (Code: ${attendanceResponse.code})";
          throw Exception(msg);
        }
      } else {
        debugPrint("--- [ATTENDANCE BACKEND ERROR] ---");
        debugPrint("HTTP Status Code: ${response.statusCode}");
        debugPrint("Backend Error Code: ${attendanceResponse.code}");
        debugPrint("Backend Error Message: ${attendanceResponse.message}");
        debugPrint("Backend Errors: ${attendanceResponse.errors}");
        debugPrint("Correlation ID: ${attendanceResponse.correlationId ?? 'N/A'}");
        debugPrint("Full Response: ${response.data}");

        String errorMessage = attendanceResponse.message.isNotEmpty
            ? attendanceResponse.message
            : "Server Error: ${response.statusCode}";
        
        if (attendanceResponse.correlationId != null) {
          errorMessage += " (Ref: ${attendanceResponse.correlationId})";
        }
        
        throw Exception(errorMessage);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      debugPrint("Parsing Error: $e");
      throw Exception("Failed to process server response: ${response.statusCode}");
    }
  }
}
