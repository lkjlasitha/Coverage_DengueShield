import 'package:flutter/material.dart';

class MessageUtils {
  static void showSnackBar(BuildContext context, String message, Color color) {
    try{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: color,
          duration: const Duration(seconds: 4),
          content: SizedBox(
            width: 200, 
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          behavior: SnackBarBehavior.floating, 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } catch (e){
      print('error eccoured ${e.toString()}');
    }
  }

  static void showSignInSuccessMessage(BuildContext context) {
    showSnackBar(context, 'Signed-in Successfully!', Colors.green);
  }

  static void showAccountADDSuccessMessage(BuildContext context) {
    showSnackBar(context, 'Account ADD in Successfully!', Colors.green);
  }

  static void showAccountBlockedMessage(BuildContext context) {
    showSnackBar(
        context, 'Your Account has been blocked for 24-hours!', Colors.red);
  }

  static void showIncorrectUsernamePasswordMessage(BuildContext context) {
    showSnackBar(context, 'Incorrect Username or Password!', Colors.red);
  }

  static void showApiErrorMessage(BuildContext context, String message) {
    showSnackBar(context, message, Colors.red);
  }

  static void ShowAnyMessage(BuildContext context, String message) {
    showSnackBar(context, message, Colors.green);
  }
}
