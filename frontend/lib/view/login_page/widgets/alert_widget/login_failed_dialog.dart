import 'package:flutter/material.dart';
import 'package:food_order_ui/view/home_page/components/colors.dart';

class LoginFailedDialog extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onDismiss;

  const LoginFailedDialog({
    Key? key,
    required this.errorMessage,
    required this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Login Failed",
        style: TextStyle(color: failedColor),
      ),
      content: Text(
        errorMessage,
        style: TextStyle(color: failedColor),
      ),
      backgroundColor: Colors.white,
      actions: [
        TextButton(
          onPressed: onDismiss,
          child: Text(
            "OK",
            style: TextStyle(color: failedColor),
          ),
        ),
      ],
    );
  }
}
