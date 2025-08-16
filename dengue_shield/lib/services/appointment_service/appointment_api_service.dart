import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../../models/appointment/history_appointments/HistoryAppointment .dart';
import '../../screens/onboard/onboard_screen.dart';
import '../secure_storage_service/secure_storage.dart';

class AppointmentApiService {
  static String get baseUrl => dotenv.env['API_URL'] ?? '';
  static final SecureStorageService _storage = SecureStorageService();

  static Future<String?> _getJwtToken() async {
    return await _storage.readSecureData('token');
  }

  static Future<void> _handleExpiredToken(BuildContext context) async {
    await _storage.clearAllData();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      (route) => false,
    );
  }

  static Future<Map<String, dynamic>?> bookAppointment({
    required BuildContext context, // ✅ Need context for navigation
    required String hospitalName,
    required String date,
    required String time,
    required String category,
    required String referenceNum,
    bool pdf = true,
  }) async {
    try {
      final jwtToken = await _getJwtToken();
      if (jwtToken == null) {
        print('JWT token not found');
        await _handleExpiredToken(context);
        return null;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/book'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'hospitalName': hospitalName,
          'date': date,
          'time': time,
          'category': category,
          'jwt': jwtToken,
          'referenceNum': referenceNum,
          'PDF': pdf,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        print('Token expired, redirecting to onboarding...');
        await _handleExpiredToken(context);
        return null;
      } else {
        print('Failed to book appointment: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error booking appointment: $e');
      return null;
    }
  }

  static Future<List<HistoryAppointment>?> getAppointmentHistory(BuildContext context) async {
    try {
      final jwtToken = await _getJwtToken();
      if (jwtToken == null) {
        print('JWT token not found');
        await _handleExpiredToken(context);
        return null;
      }

      final response = await http.get(
        Uri.parse('$baseUrl/appointments'),
        headers: {
          'Authorization': 'Bearer $jwtToken',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((appointment) => HistoryAppointment.fromApi(appointment)).toList();
      } else if (response.statusCode == 401) {
        print('Token expired, redirecting to onboarding...');
        await _handleExpiredToken(context);
        return null;
      } else {
        print('Failed to get appointments: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error getting appointments: $e');
      return null;
    }
  }
}
