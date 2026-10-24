import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'firebase_service.dart';

class OnboardingApi {
  OnboardingApi({
    String? baseUrl,
  }) : baseUrl = baseUrl ??
            const String.fromEnvironment(
              'ZALONO_API_BASE_URL',
              defaultValue: 'https://zalona-partner-app-1.onrender.com',
            );

  final String baseUrl;

  Future<void> submit({
    required String mobileNumber,
    required String fullName,
    required String email,
    required String gstNumber,
    required String salonName,
    required String salonCategory,
    required List<String> salonServices,
    required List<Map<String, dynamic>> serviceOfferings,
    required double latitude,
    required double longitude,
    required String completeAddress,
    required String pincode,
    required List<Map<String, String>> stylists,
    required Map<String, List<Map<String, dynamic>>> timings,
    Uint8List? panCard,
    String? panCardName,
    Uint8List? aadhaarCard,
    String? aadhaarCardName,
    Uint8List? businessProof,
    String? businessProofName,
    required List<Uint8List> salonPhotos,
  }) async {
    final user = await FirebaseService.ensureAuthenticated();
    final token = await user.getIdToken(true);
    if (token == null || token.isEmpty) {
      throw StateError('Firebase did not return an ID token.');
    }

    final request = http.MultipartRequest(
      'PUT',
      Uri.parse('$baseUrl/api/onboarding'),
    )..headers['Authorization'] = 'Bearer $token';

    request.fields.addAll({
      'mobileNumber': mobileNumber,
      'fullName': fullName,
      'email': email,
      'gstNumber': gstNumber,
      'salonName': salonName,
      'salonCategory': salonCategory,
      'salonServices': jsonEncode(salonServices),
      'serviceOfferings': jsonEncode(serviceOfferings),
      'location': jsonEncode({
        'latitude': latitude,
        'longitude': longitude,
      }),
      'completeAddress': completeAddress,
      'pincode': pincode,
      'stylists': jsonEncode(stylists),
      'timings': jsonEncode(timings),
    });





    late final http.StreamedResponse response;
    try {
      response = await request.send();
    } on http.ClientException catch (error) {
      throw StateError(
        'Cannot reach the backend at $baseUrl. Start the backend with '
        '`npm start` and check that port 8080 is available. (${error.message})',
      );
    }
    final body = await response.stream.bytesToString();
    if (response.statusCode < 200 || response.statusCode >= 300) {
      String message = 'Could not save registration (${response.statusCode}).';
      try {
        final decoded = jsonDecode(body);
        if (decoded is Map && decoded['error'] is String) {
          message = decoded['error'] as String;
        }
      } catch (_) {
        // Keep the status-based message when the server response is not JSON.
      }
      throw StateError(message);
    }
  }
}
