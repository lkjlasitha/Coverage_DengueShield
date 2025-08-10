import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirmed;
  final VoidCallback? onCancelled;

  const ConfirmationDialog({
    Key? key,
    required this.title,
    required this.message,
    required this.onConfirmed,
    this.onCancelled,
    this.confirmText = 'Yes',
    this.cancelText = 'No',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            if (onCancelled != null) {
              onCancelled!();
            }
          },
          child: Text(cancelText),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirmed();
          },
          child: Text(confirmText),
        ),
      ],
    );
  }
}
