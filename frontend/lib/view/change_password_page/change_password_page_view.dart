import 'package:flutter/material.dart';
import 'package:food_order_ui/view/change_password_page/widgets/confirm_button.dart';
import 'package:food_order_ui/view/change_password_page/widgets/text_field_widget/text_field_password.dart';

import 'widgets/logo.dart';

class ChangePasswordPageView extends StatefulWidget {
  const ChangePasswordPageView({Key? key}) : super(key: key);

  @override
  _ChangePasswordPageViewState createState() => _ChangePasswordPageViewState();
}

class _ChangePasswordPageViewState extends State<ChangePasswordPageView> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void _confirmPassword() {
    // Implement your logic to confirm the password
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const LogoImage(),
            TextFieldPassword(
                controller: _oldPasswordController,
                hintText: "Old Password",
                labelText: "Old Password"),
            TextFieldPassword(
                controller: _newPasswordController,
                hintText: "New Password",
                labelText: "New Password"),
            TextFieldPassword(
                controller: _confirmPasswordController,
                hintText: "Confirm Password",
                labelText: "Confirm Password"),
            ConfirmButonColor(
              onPressed: _confirmPassword, // Pass the function reference here
            ),
          ],
        ),
      ),
    );
  }
}
