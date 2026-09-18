import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../core/utils/shared_prefs_manager.dart';
import '../../models/attendance_request.dart';
import '../../models/attendance_response.dart';
import '../../models/attendance_history_response.dart';
import '../../models/today_attendance_response.dart';

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

  Future<AttendanceHistoryResponse> getHistory(int page, int size) async {
    final endpoint = "/api/v1/sfa/attendance/history";
    final token = SharedPrefsManager.getToken();
    if (token == null || token.isEmpty) {
      throw Exception("Authentication token not found. Please login again.");
    }

    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: {
          'page': page,
          'size': size,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      try {
        final data = response.data;
        if (data == null) {
          throw Exception("Server returned empty body (Status: ${response.statusCode})");
        }

        final Map<String, dynamic> json = data is String
            ? Map<String, dynamic>.from(jsonDecode(data))
            : Map<String, dynamic>.from(data);

        final attendanceHistoryResponse = AttendanceHistoryResponse.fromJson(json);

        if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
          if (attendanceHistoryResponse.success && (attendanceHistoryResponse.code == "SUCCESS" || attendanceHistoryResponse.code == "200")) {
            return attendanceHistoryResponse;
          } else {
            String msg = attendanceHistoryResponse.message.isNotEmpty
                ? attendanceHistoryResponse.message
                : "Failed to fetch attendance history (Code: ${attendanceHistoryResponse.code})";
            throw Exception(msg);
          }
        } else {
          String errorMessage = attendanceHistoryResponse.message.isNotEmpty
              ? attendanceHistoryResponse.message
              : "Server Error: ${response.statusCode}";
          throw Exception(errorMessage);
        }
      } catch (e) {
        if (e is Exception) rethrow;
        throw Exception("Failed to process server response: ${response.statusCode}");
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception("Failed to connect to server: $e");
    }
  }

  Future<TodayAttendanceResponse> getTodayAttendance() async {
    final endpoint = "/api/v1/sfa/attendance/today";
    final token = SharedPrefsManager.getToken();
    if (token == null || token.isEmpty) {
      throw Exception("Authentication token not found. Please login again.");
    }

    try {
      final response = await _dio.get(
        endpoint,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      try {
        final data = response.data;
        if (data == null) {
          throw Exception("Server returned empty body (Status: ${response.statusCode})");
        }

        final Map<String, dynamic> json = data is String
            ? Map<String, dynamic>.from(jsonDecode(data))
            : Map<String, dynamic>.from(data);

        final todayAttendanceResponse = TodayAttendanceResponse.fromJson(json);

        if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
          if (todayAttendanceResponse.success && (todayAttendanceResponse.code == "SUCCESS" || todayAttendanceResponse.code == "200")) {
            return todayAttendanceResponse;
          } else {
            String msg = todayAttendanceResponse.message.isNotEmpty
                ? todayAttendanceResponse.message
                : "Failed to fetch today attendance (Code: ${todayAttendanceResponse.code})";
            throw Exception(msg);
          }
        } else {
          String errorMessage = todayAttendanceResponse.message.isNotEmpty
              ? todayAttendanceResponse.message
              : "Server Error: ${response.statusCode}";
          throw Exception(errorMessage);
        }
      } catch (e) {
        if (e is Exception) rethrow;
        throw Exception("Failed to process server response: ${response.statusCode}");
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception("Failed to connect to server: $e");
    }
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
          String msg = attendanceResponse.message.isNotEmpty
              ? attendanceResponse.message
              : "Attendance action failed (Code: ${attendanceResponse.code})";
          throw Exception(msg);
        }
      } else {
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
