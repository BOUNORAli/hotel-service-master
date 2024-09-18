import 'package:flutter/material.dart';
import 'package:food_order_ui/services/api_service.dart';
import 'package:food_order_ui/view/home_page/components/colors.dart';
import 'package:food_order_ui/view/login_page/widgets/text_field_widget/text_field_input.dart';
import 'package:food_order_ui/view/login_page/widgets/text_field_widget/text_field_password.dart';
import 'package:food_order_ui/view/register_page/widgets/background_image.dart';
import 'package:food_order_ui/view/register_page/widgets/register_button.dart';
import 'package:food_order_ui/view/register_page/widgets/text_signin.dart';
import '../success_page/success_register_page_view.dart';

class RegisterPageView extends StatefulWidget {
  const RegisterPageView({Key? key}) : super(key: key);

  @override
  _RegisterPageViewState createState() => _RegisterPageViewState();
}

class _RegisterPageViewState extends State<RegisterPageView> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordSecondController = TextEditingController();

  Future<void> _register() async {
    if (_passwordController.text != _passwordSecondController.text) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Password Mismatch",
              style: TextStyle(color: failedColor),
            ),
            content: Text(
              "The passwords you entered do not match.",
              style: TextStyle(color: failedColor),
            ),
            backgroundColor: Colors.white,
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "OK",
                  style: TextStyle(color: failedColor),
                ),
              ),
            ],
          );
        },
      );
      return;
    }
    try {
      await ApiService.registerUser(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );
      _showSuccess();
    } catch (error) {
      _showErrorDialog("Failed to register: ${error.toString()}");
    }
  }

  void _showSuccess() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterCart()),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const BackgroundImage(),
            TextFieldInput(
              text: "firstname",
              iconName: Icons.account_circle,
              ltext: "First Name",
              controller: _firstNameController,
            ),
            TextFieldInput(
              text: "lastname",
              iconName: Icons.account_circle,
              ltext: "Last Name",
              controller: _lastNameController,
            ),
            TextFieldInput(
              text: "email",
              iconName: Icons.mail,
              ltext: "Email",
              controller: _emailController,
            ),
            TextFieldPassword(controller: _passwordController),
            TextFieldPassword(controller: _passwordSecondController),
            RegisterButton(onPressed: _register),
            TextSignIn(),
          ],
        ),
      ),
    );
  }
}
