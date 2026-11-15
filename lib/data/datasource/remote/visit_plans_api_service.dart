import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/utils/shared_prefs_manager.dart';
import '../../models/unplanned_customers_response.dart';

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

  Future<UnplannedCustomersResponse> getUnplannedCustomers({
    required String date,
    int page = 0,
    int size = 20,
    String planType = 'LOCAL',
  }) async {
    final uri = Uri.parse(
        "$baseUrl/api/v1/sfa/visit-plans/unplanned-customers?date=$date&page=$page&size=$size&planType=$planType");

    final response = await http.get(uri, headers: await _getHeaders());

    if (response.statusCode == 200) {
      return UnplannedCustomersResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          "Failed to load unplanned customers: ${response.statusCode} - ${response.body}");
    }
  }
}
