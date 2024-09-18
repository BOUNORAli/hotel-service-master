import 'package:flutter/material.dart';
import 'package:food_order_ui/view/home_page/components/size_config.dart';
import 'package:food_order_ui/view/success_page/widgets/lottie_widget.dart';
import 'package:food_order_ui/view/success_page/widgets/ok_button.dart';
import 'package:food_order_ui/view/success_page/widgets/router_text.dart';

import '../login_page/login_page_view.dart';

class RegisterCart extends StatelessWidget {
  const RegisterCart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(children: [
        const LottieWidget(),
        const RouterText(text: "Successfully registration completed!"),
        SizedBox(
          height: SizeConfig.screenHeight! / 68.3,
        ),
        OkButton(
          onTap: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const LoginPageView()),
            );
          },
          buttonText: "OK",
        ),
      ]),
    );
  }
}
