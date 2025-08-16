import 'dart:convert';
import 'package:dengue_shield/screens/onboard/second_onboard_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import '../message_service/message_service.dart';
import '../secure_storage_service/secure_storage.dart';

class UserAuthenticationService {
  final BuildContext context;
  final TextEditingController userIdController;
  final TextEditingController passwordController;
  late ProgressDialog progressDialog;
  final String baseUrl = dotenv.env['API_URL'] ?? '';
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  UserAuthenticationService({
    required this.context,
    required this.userIdController,
    required this.passwordController,
  });

  Future<void> signIn() async {
    try {
      progressDialog = ProgressDialog(context);
      await progressDialog.show();

      final response = await _makeSignInRequest();
      await _handleResponse(response);
    } finally {
      if (progressDialog.isShowing()) {
        await progressDialog.hide();
      }
    }
  }

  Future<http.Response> _makeSignInRequest() async {
    final Map<String, String> body = {
      'email': userIdController.text.trim(),
      'password': passwordController.text.trim(),
    };

    return await http.post(
      Uri.parse('$baseUrl/login'),
      headers: headers,
      body: jsonEncode(body),
    );
  }

  Future<void> _handleResponse(http.Response response) async {
    if (response.statusCode == 200 || response.statusCode == 201) {
      await _handleSuccessfulSignIn(response);
    } else if (response.statusCode == 401) {
      MessageUtils.showIncorrectUsernamePasswordMessage(context);
    } else {
      _handleErrorResponse(response);
    }
  }

  Future<void> _handleSuccessfulSignIn(http.Response response) async {
    final Map<String, dynamic> responseBody = json.decode(response.body);
    final String accessToken = responseBody['token'] ?? '';
    //final String role = responseBody['role'] ?? 'user';
    await _saveTokens(accessToken);
    if (progressDialog.isShowing()) {
      await progressDialog.hide();
    }
    Future.delayed(const Duration(milliseconds: 300), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SecondOnboardScreen()),
      );
    });
    MessageUtils.showSignInSuccessMessage(context);
  }

  void _handleErrorResponse(http.Response response) {
    if (response.body.isNotEmpty) {
      final Map<String, dynamic> errorResponse = json.decode(response.body);
      final String errorMessage = errorResponse['error'] ?? 'Unknown error occurred';

      if (errorMessage == 'Sorry! user account has blocked for 24 hours.') {
        MessageUtils.showAccountBlockedMessage(context);
      } else {
        MessageUtils.showApiErrorMessage(context, errorMessage);
      }
    } else {
      debugPrint('Error: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
    }
  }

  Future<void> _saveTokens(String accessToken) async {
    try {
      final storage = SecureStorageService();
      await storage.saveSecureData('token', accessToken);
      int currentTime = DateTime.now().millisecondsSinceEpoch;
      await storage.saveSecureData('accessToken_timestamp', currentTime.toString());
    } catch (e) {
      MessageUtils.showApiErrorMessage(context, 'Failed to save data');
    }
  }
}
