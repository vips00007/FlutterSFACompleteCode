import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../core/utils/shared_prefs_manager.dart';
import '../../models/customer_reference_data_response.dart';
import '../../models/geography_response.dart';
import '../../models/customer_create_request.dart';
import '../../models/customer_create_response.dart';

class CustomerApiService {
  final String baseUrl = "https://api-staging.rahulpatel.online";
  late final Dio _dio = Dio(
    BaseOptions(baseUrl: baseUrl,
      headers: {"Accept": "application/json"},
      validateStatus: (status) => status != null,
    ),
  );

  String generateUuidV4() {
    final Random random = Random();
    String hex(int length, {int min = 0, int max = 15}) {
      String result = '';
      for (int i = 0; i < length; i++) {
        int value = min + random.nextInt(max - min + 1);
        result += value.toRadixString(16);
      }
      return result;
    }
    return '${hex(8)}-${hex(4)}-4${hex(3)}-${hex(1, min: 8, max: 11)}${hex(3)}-${hex(12)}';
  }

  Future<CustomerReferenceDataResponse> getReferenceData() async {
    final endpoint = "/api/v1/sfa/customers/reference-data";
    final token = SharedPrefsManager.getToken();
    if (token == null || token.isEmpty) {
      throw Exception("Authentication token not found. Please login again.");
    }

    final correlationId = generateUuidV4();

    try {
      final response = await _dio.get(
        endpoint,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "X-Correlation-ID": correlationId,
          },
        ),
      );

      try {
        final data = response.data;
        if (data == null) {
          throw Exception(
            "Server returned empty body (Status: ${response.statusCode})",
          );
        }

        final Map<String, dynamic> json = data is String
            ? Map<String, dynamic>.from(jsonDecode(data))
            : Map<String, dynamic>.from(data);

        final referenceResponse = CustomerReferenceDataResponse.fromJson(json);

        if (response.statusCode != null &&
            response.statusCode! >= 200 &&
            response.statusCode! < 300) {
          if (referenceResponse.success &&
              (referenceResponse.code == "SUCCESS" ||
                  referenceResponse.code == "200")) {
            return referenceResponse;
          } else {
            String msg = referenceResponse.message.isNotEmpty
                ? referenceResponse.message
                : "Failed to fetch reference data (Code: ${referenceResponse.code})";
            throw Exception(msg);
          }
        } else {
          String errorMessage = referenceResponse.message.isNotEmpty
              ? referenceResponse.message
              : "Server Error: ${response.statusCode}";
          throw Exception(errorMessage);
        }
      } catch (e) {
        if (e is Exception) rethrow;
        debugPrint("Parsing Error: $e");
        throw Exception(
          "Failed to process server response: ${response.statusCode}",
        );
      }
    } catch (e) {
      if (e is Exception) rethrow;
      debugPrint("Dio Error: $e");
      throw Exception("Failed to connect to server: $e");
    }
  }

  Future<GeographyResponse> getGeographyData() async {
    final endpoint = "/api/v1/sfa/customers/geography";
    final token = SharedPrefsManager.getToken();
    if (token == null || token.isEmpty) {
      throw Exception("Authentication token not found. Please login again.");
    }

    final correlationId = generateUuidV4();

    try {
      final response = await _dio.get(
        endpoint,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "X-Correlation-ID": correlationId,
          },
        ),
      );

      try {
        final data = response.data;
        if (data == null) {
          throw Exception(
            "Server returned empty body (Status: ${response.statusCode})",
          );
        }

        final Map<String, dynamic> json = data is String
            ? Map<String, dynamic>.from(jsonDecode(data))
            : Map<String, dynamic>.from(data);

        final geographyResponse = GeographyResponse.fromJson(json);

        if (response.statusCode != null &&
            response.statusCode! >= 200 &&
            response.statusCode! < 300) {
          if (geographyResponse.success &&
              (geographyResponse.code == "SUCCESS" ||
                  geographyResponse.code == "200")) {
            return geographyResponse;
          } else {
            String msg = geographyResponse.message.isNotEmpty
                ? geographyResponse.message
                : "Failed to fetch geography data (Code: ${geographyResponse.code})";
            throw Exception(msg);
          }
        } else {
          String errorMessage = geographyResponse.message.isNotEmpty
              ? geographyResponse.message
              : "Server Error: ${response.statusCode}";
          throw Exception(errorMessage);
        }
      } catch (e) {
        if (e is Exception) rethrow;
        debugPrint("Parsing Error: $e");
        throw Exception(
          "Failed to process server response: ${response.statusCode}",
        );
      }
    } catch (e) {
      if (e is Exception) rethrow;
      debugPrint("Dio Error: $e");
      throw Exception("Failed to connect to server: $e");
    }
  }

  Future<CustomerCreateResponse> createCustomer(CustomerCreateRequest request) async {
    final endpoint = "/api/v1/sfa/customers";
    final token = SharedPrefsManager.getToken();
    if (token == null || token.isEmpty) {
      throw Exception("Authentication token not found. Please login again.");
    }

    final correlationId = generateUuidV4();

    try {
      final response = await _dio.post(
        endpoint,
        data: request.toJson(),
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "X-Correlation-ID": correlationId,
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

        final createResponse = CustomerCreateResponse.fromJson(json);

        if (response.statusCode != null &&
            response.statusCode! >= 200 &&
            response.statusCode! < 300) {
          if (createResponse.success &&
              (createResponse.code == "SUCCESS" || createResponse.code == "200" || createResponse.code == "201")) {
            return createResponse;
          } else {
            String msg = createResponse.message.isNotEmpty
                ? createResponse.message
                : "Failed to create customer (Code: ${createResponse.code})";
            throw Exception(msg);
          }
        } else {
          String errorMessage = createResponse.message.isNotEmpty
              ? "${createResponse.message} - ${jsonEncode(json)}"
              : "Server Error: ${response.statusCode} - ${jsonEncode(json)}";
          throw Exception(errorMessage);
        }
      } catch (e) {
        if (e is Exception) rethrow;
        debugPrint("Parsing Error: $e");
        throw Exception("Failed to process server response: ${response.statusCode}");
      }
    } catch (e) {
      if (e is Exception) rethrow;
      debugPrint("Dio Error: $e");
      throw Exception("Failed to connect to server: $e");
    }
  }
}
