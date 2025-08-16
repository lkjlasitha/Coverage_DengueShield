import 'package:dengue_shield/config/keys.dart';
import 'package:dengue_shield/screens/language_select/language_select.dart';
import 'package:dengue_shield/widgets/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import '../message_service/message_service.dart';
import '../secure_storage_service/secure_storage.dart';

enum AuthStatus {
  checking,
  authenticated,
  unauthenticated,
  sessionExpired,
}

class AppWrapper extends StatefulWidget {
  const AppWrapper({super.key});

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  final storage = SecureStorageService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AuthStatus>(
      future: _checkAuthenticationStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
        }
        switch (snapshot.data) {
          case AuthStatus.authenticated:
            return CustomBottomNav(
              key: AppKeys.bottomNavKey,
            );
          case AuthStatus.sessionExpired:
            WidgetsBinding.instance.addPostFrameCallback((_) {
              MessageUtils.showApiErrorMessage(context, 'Session Expired');
            });
            return const LanguageSelectionScreen();
          case AuthStatus.unauthenticated:
            WidgetsBinding.instance.addPostFrameCallback((_) {
              MessageUtils.showApiErrorMessage(context, 'Session Expired');
            });
            return const LanguageSelectionScreen();
          default:
            return const Scaffold(
              backgroundColor: Colors.white,
            );
        }
      },
    );
  }

  Future<AuthStatus> _checkAuthenticationStatus() async {
    try {
      final savedAccessToken = await storage.readSecureData('token');
      final savedTimestamp = await storage.readSecureData('accessToken_timestamp');

      if (savedAccessToken == null || savedTimestamp == null) {
        return AuthStatus.unauthenticated;
      }
      final int currentTime = DateTime.now().millisecondsSinceEpoch;
      final int differenceInDays = (currentTime - int.parse(savedTimestamp)) ~/ (1000 * 60 * 60 * 24);
      if (differenceInDays <= 0.9) {
        return AuthStatus.authenticated;
      } else {
        return AuthStatus.sessionExpired;
      }
    } catch (e) {
      return AuthStatus.unauthenticated;
    }
  }
}