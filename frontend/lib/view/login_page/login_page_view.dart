import 'package:flutter/material.dart';
import 'package:food_order_ui/services/api_service.dart';
import 'package:food_order_ui/view/bottom_navigator.dart';
import 'package:food_order_ui/view/admin_options/admin_options_page.dart';
import 'package:food_order_ui/view/login_page/widgets/text_field_widget/text_field_input.dart';
import 'package:food_order_ui/view/login_page/widgets/text_field_widget/text_field_password.dart';
import 'package:food_order_ui/view/login_page/widgets/text_signup.dart';
import 'widgets/alert_widget/login_failed_dialog.dart';
import 'widgets/forgot_password.dart';
import 'widgets/login_button.dart';
import 'widgets/logo.dart';

class LoginPageView extends StatefulWidget {
  const LoginPageView({Key? key}) : super(key: key);

  @override
  _LoginPageViewState createState() => _LoginPageViewState();
}

class _LoginPageViewState extends State<LoginPageView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    try {
      String? accessToken = await ApiService.login(email, password);
      print("Access token: $accessToken");
      String role = await ApiService.getUserRole(accessToken!);


      if (role == 'ADMIN') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminOptionsPage()),
        );
      } else if (role == 'USER') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyHomePage()),
        );
      } else {
        throw Exception('Unknown role');
      }
    } catch (error) {
      print("Login failed with error: $error");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return LoginFailedDialog(
            errorMessage: error.toString(),
            onDismiss: () {
              Navigator.of(context).pop();
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const LogoImage(),
            TextFieldInput(
              text: "email",
              iconName: Icons.mail,
              ltext: "Email",
              controller: _emailController,
            ),
            TextFieldPassword(controller: _passwordController),
            const ForgotPassword(),
            LoginButonColor(
              onPressed: _login,
            ),
            TextSignUp(),
          ],
        ),
      ),
    );
  }
}
