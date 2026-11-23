import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../core/network/api_exception.dart';
import '../../../core/utils/shared_prefs_manager.dart';
import '../../models/unplanned_customers_response.dart';
import '../../models/my_geographies_response.dart';
import '../../models/visit_plan_customers_response.dart';
import '../../models/create_visit_plan_models.dart';
import '../../models/my_visits_response.dart';
import '../../models/visit_plan_models.dart';

class VisitPlansApiService {
  final String baseUrl = "https://api-staging.rahulpatel.online";

  Future<Map<String, String>> _getHeaders() async {
    final token = SharedPrefsManager.getToken();
    return {
      "Accept": "application/json",
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  Future<MyGeographiesResponse> getMyGeographies() async {
    final uri = Uri.parse("$baseUrl/api/v1/sfa/visit-plans/my-geographies");
    final response = await http.get(uri, headers: await _getHeaders());

    if (kDebugMode) {
      print("GET /my-geographies status: ${response.statusCode}, body: ${response.body}");
    }

    if (response.statusCode == 200) {
      return MyGeographiesResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          "Failed to load geographies: ${response.statusCode} - ${response.body}");
    }
  }

  /// Primary Customers API
  /// GET /api/v1/sfa/customers
  Future<VisitPlanCustomersResponse> getCustomers({
    required String planType,
    bool? planned,
    String type = 'ALL',
    String? date,
    String? destinationGeographyUuid,
    String? search,
    String? sort,
    double? latitude,
    double? longitude,
    int page = 0,
    int size = 20,
  }) async {
    final queryParams = <String, String>{
      'planType': planType,
      if (planned != null) 'planned': planned.toString(),
      if (type != 'ALL') 'type': type,
      if (date != null && date.trim().isNotEmpty) 'date': date.trim(),
      if (destinationGeographyUuid != null && destinationGeographyUuid.trim().isNotEmpty) ...{
        'destinationGeographyUuid': destinationGeographyUuid.trim(),
        'destinationGeoGraphyUuid': destinationGeographyUuid.trim(),
      },
      if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
      if (sort != null && sort.trim().isNotEmpty) 'sort': sort.trim(),
      if (latitude != null) 'latitude': latitude.toString(),
      if (longitude != null) 'longitude': longitude.toString(),
      'page': page.toString(),
      'size': size.toString(),
    };

    final uri = Uri.parse("$baseUrl/api/v1/sfa/customers")
        .replace(queryParameters: queryParams);

    if (kDebugMode) {
      print("GET /api/v1/sfa/customers request URL: $uri");
    }

    final response = await http.get(uri, headers: await _getHeaders());

    if (kDebugMode) {
      print("GET /api/v1/sfa/customers status: ${response.statusCode}, body: ${response.body}");
    }

    if (response.statusCode == 200) {
      return VisitPlanCustomersResponse.fromJson(jsonDecode(response.body));
    } else {
      final fallbackUri = Uri.parse("$baseUrl/api/v1/sfa/visit-plans/customers")
          .replace(queryParameters: queryParams);
      final fallbackResponse = await http.get(fallbackUri, headers: await _getHeaders());
      if (fallbackResponse.statusCode == 200) {
        return VisitPlanCustomersResponse.fromJson(jsonDecode(fallbackResponse.body));
      }
      throw Exception(
          "Failed to load customers: ${response.statusCode} - ${response.body}");
    }
  }

  /// Wrapper for backward compatibility
  Future<VisitPlanCustomersResponse> getVisitPlanCustomers({
    required String planType,
    String type = 'ALL',
    String? date,
    String? destinationGeographyUuid,
    String? search,
    String? sort,
    double? latitude,
    double? longitude,
    int page = 0,
    int size = 20,
  }) async {
    return getCustomers(
      planType: planType,
      type: type,
      date: date,
      destinationGeographyUuid: destinationGeographyUuid,
      search: search,
      sort: sort,
      latitude: latitude,
      longitude: longitude,
      page: page,
      size: size,
    );
  }

  /// My Visits / My Plans API
  /// GET /api/v1/sfa/visits
  Future<MyVisitsResponse> getMyVisits({
    String scope = 'MINE',
    String? date,
    int page = 0,
    int size = 20,
  }) async {
    final queryParams = <String, String>{
      'scope': scope,
      if (date != null && date.trim().isNotEmpty) 'date': date.trim(),
      'page': page.toString(),
      'size': size.toString(),
    };

    final uri = Uri.parse("$baseUrl/api/v1/sfa/visits")
        .replace(queryParameters: queryParams);

    if (kDebugMode) {
      print("GET /api/v1/sfa/visits request URL: $uri");
    }

    final response = await http.get(uri, headers: await _getHeaders());

    if (kDebugMode) {
      print("GET /api/v1/sfa/visits status: ${response.statusCode}, body: ${response.body}");
    }

    if (response.statusCode == 200) {
      return MyVisitsResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          "Failed to load my visits: ${response.statusCode} - ${response.body}");
    }
  }

  /// GET /api/v1/sfa/visit-plans
  Future<VisitPlanResponseModel> getVisitPlans({
    String? status,
    int page = 0,
    int size = 20,
  }) async {
    final queryParams = <String, String>{
      if (status != null && status.trim().isNotEmpty) 'status': status.trim(),
      'page': page.toString(),
      'size': size.toString(),
    };

    final uri = Uri.parse("$baseUrl/api/v1/sfa/visit-plans")
        .replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);

    if (kDebugMode) {
      print("GET /api/v1/sfa/visit-plans request URL: $uri");
    }

    final response = await http.get(uri, headers: await _getHeaders());

    if (kDebugMode) {
      print("GET /api/v1/sfa/visit-plans status: ${response.statusCode}, body: ${response.body}");
    }

    if (response.statusCode == 200) {
      return VisitPlanResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          "Failed to load visit plans: ${response.statusCode} - ${response.body}");
    }
  }

  /// Submit for Approval API
  /// POST /api/v1/sfa/visit-plans
  Future<SubmitPlanResponse> createVisitPlan(Map<String, dynamic> body) async {
    final uri = Uri.parse("$baseUrl/api/v1/sfa/visit-plans");
    final jsonBody = jsonEncode(body);

    if (kDebugMode) {
      print("POST /api/v1/sfa/visit-plans payload: $jsonBody");
    }

    final response = await http.post(
      uri,
      headers: await _getHeaders(),
      body: jsonBody,
    );

    if (kDebugMode) {
      print("POST /api/v1/sfa/visit-plans status: ${response.statusCode}, body: ${response.body}");
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      return SubmitPlanResponse.fromJson(jsonDecode(response.body));
    } else {
      throw ApiException.fromResponse(
        response.statusCode,
        response.body,
        defaultTitle: 'Unable to Create Plan',
      );
    }
  }

  /// Deprecated legacy endpoint wrapper for backward compatibility
  Future<UnplannedCustomersResponse> getUnplannedCustomers({
    required String date,
    int page = 0,
    int size = 20,
    String planType = 'LOCAL',
    String? destinationGeoGraphyUuid,
  }) async {
    try {
      final res = await getVisitPlanCustomers(
        planType: planType,
        type: 'UNPLANNED',
        date: date,
        destinationGeographyUuid: destinationGeoGraphyUuid,
        page: page,
        size: size,
      );

      final content = (res.data?.content ?? []).map((c) {
        return UnplannedCustomer(
          uuid: c.uuid,
          customerCode: c.customerCode,
          shopName: c.shopName,
          area: c.area,
          latitude: c.latitude,
          longitude: c.longitude,
          distanceKm: c.distanceKm,
          outstandingAmount: c.outstandingAmount,
          lastOrderDays: c.lastOrderDays,
        );
      }).toList();

      return UnplannedCustomersResponse(
        success: res.success,
        code: res.code,
        message: res.message,
        data: UnplannedCustomersData(
          content: content,
          page: res.data?.page ?? page,
          size: res.data?.size ?? size,
          totalElements: res.data?.totalElements ?? content.length,
          totalPages: res.data?.totalPages ?? 1,
        ),
      );
    } catch (_) {
      final queryParams = <String, String>{
        'date': date,
        'page': page.toString(),
        'size': size.toString(),
        'planType': planType,
        if (destinationGeoGraphyUuid != null && destinationGeoGraphyUuid.isNotEmpty) ...{
          'destinationGeoGraphyUuid': destinationGeoGraphyUuid,
          'destinationGeographyUuid': destinationGeoGraphyUuid,
        },
      };

      final uri = Uri.parse("$baseUrl/api/v1/sfa/visit-plans/unplanned-customers")
          .replace(queryParameters: queryParams);

      final response = await http.get(uri, headers: await _getHeaders());

      if (response.statusCode == 200) {
        return UnplannedCustomersResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
            "Failed to load unplanned customers: ${response.statusCode} - ${response.body}");
      }
    }
  }
}
