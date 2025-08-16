import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class LoginService {
  static final String baseUrl = dotenv.env['API_URL'] ?? '';

  static Future<Map<String, dynamic>> logIn({
    required String name,
    required String email,
    required String password,
    String role = 'user',
  }) async {
    final url = Uri.parse('$baseUrl/signup');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'email': email,
        'password': password,
        'role': role,
      }),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
          json.decode(response.body)['message'] ?? 'Registration failed');
    }
  }
}
