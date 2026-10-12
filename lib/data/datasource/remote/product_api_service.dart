import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../core/utils/shared_prefs_manager.dart';
import '../../models/product_catalog_response.dart';

class ProductApiService {
  final String baseUrl = "https://api-staging.rahulpatel.online";
  late final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      headers: {"Accept": "application/json"},
      validateStatus: (status) => status != null,
    ),
  );

  Future<ProductCatalogResponse> getProducts({
    int page = 0,
    int size = 20,
  }) async {
    final endpoint = "/api/v1/sfa/catalog/products";
    final token = SharedPrefsManager.getToken();
    if (token == null || token.isEmpty) {
      throw Exception("Authentication token not found. Please login again.");
    }

    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: {'page': page, 'size': size},
        options: Options(headers: {"Authorization": "Bearer $token"}),
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

        final catalogResponse = ProductCatalogResponse.fromJson(json);

        if (response.statusCode != null &&
            response.statusCode! >= 200 &&
            response.statusCode! < 300) {
          if (catalogResponse.success &&
              (catalogResponse.code == "SUCCESS" ||
                  catalogResponse.code == "200")) {
            return catalogResponse;
          } else {
            String msg = catalogResponse.message.isNotEmpty
                ? catalogResponse.message
                : "Failed to fetch products (Code: ${catalogResponse.code})";
            throw Exception(msg);
          }
        } else {
          String errorMessage = catalogResponse.message.isNotEmpty
              ? catalogResponse.message
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
}
