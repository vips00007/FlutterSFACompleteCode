import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../../models/customer_reference_data_response.dart';
import '../../models/customer_create_request.dart';
import '../../models/customer_create_response.dart';
import '../../../core/utils/shared_prefs_manager.dart';

class CustomerApiService {
  final String baseUrl = "https://api-staging.rahulpatel.online";

  String generateUuidV4() {
    final random = Random();
    String hexString(int length) {
      final buffer = StringBuffer();
      for (int i = 0; i < length; i++) {
        buffer.write(random.nextInt(16).toRadixString(16));
      }
      return buffer.toString();
    }
    return '${hexString(8)}-${hexString(4)}-4${hexString(3)}-a${hexString(3)}-${hexString(12)}';
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = SharedPrefsManager.getToken();
    return {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "X-Correlation-ID": generateUuidV4(),
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  Future<CustomerReferenceDataResponse> getReferenceData() async {
    final response = await http.get(
      Uri.parse("$baseUrl/api/v1/sfa/customers/reference-data"),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return CustomerReferenceDataResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load reference data: ${response.statusCode}");
    }
  }

  Future<CustomerCreateResponse> createCustomer(
    CustomerCreateRequest request, {
    String? shopImagePath,
    String? aadhaarPath,
    String? bankProofPath,
  }) async {
    final requestBody = jsonEncode(request.toJson());
    print('============= CREATE CUSTOMER REQUEST BODY =============');
    print(requestBody);
    print('========================================================');
    
    developer.log('CREATE CUSTOMER REQUEST BODY: $requestBody', name: 'CustomerApiService');
    
    final uri = Uri.parse("$baseUrl/api/v1/sfa/customers/with-files");
    final multipartRequest = http.MultipartRequest('POST', uri);
    
    final headers = await _getHeaders();
    headers.remove("Content-Type"); // MultiPartRequest handles this
    multipartRequest.headers.addAll(headers);

    // 1. Add JSON data part
    multipartRequest.files.add(http.MultipartFile.fromString(
      'data',
      requestBody,
      filename: 'request.json',
      contentType: MediaType('application', 'json', {'charset': 'utf-8'}),
    ));

    // 2. Add Shop Image
    if (shopImagePath != null && shopImagePath.isNotEmpty) {
      multipartRequest.files.add(await _createMultipartFile('shopImage', shopImagePath));
    }

    // 3. Add Aadhaar Image
    if (aadhaarPath != null && aadhaarPath.isNotEmpty) {
      multipartRequest.files.add(await _createMultipartFile('kyc-aadhaar', aadhaarPath));
    }

    // 4. Add Bank Proof Image
    if (bankProofPath != null && bankProofPath.isNotEmpty) {
      multipartRequest.files.add(await _createMultipartFile('bank-proof', bankProofPath));
    }

    final streamedResponse = await multipartRequest.send();
    final response = await http.Response.fromStream(streamedResponse);

    developer.log('CREATE CUSTOMER RESPONSE STATUS: ${response.statusCode}', name: 'CustomerApiService');
    developer.log('CREATE CUSTOMER RESPONSE BODY: ${response.body}', name: 'CustomerApiService');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return CustomerCreateResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to create customer: ${response.statusCode} - ${response.body}");
    }
  }

  Future<http.MultipartFile> _createMultipartFile(String fieldName, String filePath) async {
    String ext = filePath.split('.').last.toLowerCase();
    String mediaType = 'application';
    String subType = 'octet-stream';
    if (ext == 'png') { 
      mediaType = 'image'; subType = 'png'; 
    } else if (ext == 'jpg' || ext == 'jpeg') { 
      mediaType = 'image'; subType = 'jpeg'; 
    } else if (ext == 'pdf') { 
      mediaType = 'application'; subType = 'pdf'; 
    }
    
    return await http.MultipartFile.fromPath(
      fieldName,
      filePath,
      contentType: MediaType(mediaType, subType),
    );
  }

  Future<String> uploadFile(String filePath, String kind) async {
    final uri = Uri.parse("$baseUrl/api/v1/sfa/customers/files?kind=$kind");
    final request = http.MultipartRequest('POST', uri);
    
    final headers = await _getHeaders();
    headers.remove("Content-Type");
    request.headers.addAll(headers);
    
    String ext = filePath.split('.').last.toLowerCase();
    String mediaType = 'application';
    String subType = 'octet-stream';
    if (ext == 'png') { 
      mediaType = 'image'; subType = 'png'; 
    } else if (ext == 'jpg' || ext == 'jpeg') { 
      mediaType = 'image'; subType = 'jpeg'; 
    } else if (ext == 'pdf') { 
      mediaType = 'application'; subType = 'pdf'; 
    }

    request.files.add(await http.MultipartFile.fromPath(
      'file', 
      filePath,
      contentType: MediaType(mediaType, subType),
    ));
    
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    
    print('============= UPLOAD API RESPONSE BODY =============');
    print(response.body);
    print('====================================================');
    
    developer.log('UPLOAD RESPONSE STATUS: ${response.statusCode}', name: 'CustomerApiService');
    developer.log('UPLOAD RESPONSE BODY: ${response.body}', name: 'CustomerApiService');
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success'] == true) {
        return jsonResponse['data']['fileRef'];
      } else {
        throw Exception("Upload failed: ${jsonResponse['message']}");
      }
    } else {
      throw Exception("Failed to upload file: ${response.statusCode} - ${response.body}");
    }
  }
}
