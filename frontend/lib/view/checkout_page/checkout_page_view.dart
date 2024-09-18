import 'package:flutter/material.dart';
import 'package:food_order_ui/view/checkout_page/widgets/address.dart';
import 'package:food_order_ui/view/checkout_page/widgets/payment.dart';
import 'package:food_order_ui/view/home_page/components/colors.dart';
import 'package:food_order_ui/view/home_page/components/size_config.dart';
import 'package:food_order_ui/view/checkout_page/widgets/success_checkout_page_view.dart';
import 'package:food_order_ui/view/checkout_page/widgets/check_cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutPageView extends StatefulWidget {
  const CheckoutPageView({Key? key}) : super(key: key);

  @override
  _CheckoutPageViewState createState() => _CheckoutPageViewState();
}

class _CheckoutPageViewState extends State<CheckoutPageView> {
  int currentStep = 0;
  bool isCompleted = false;

  Future<void> _submitOrder() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('access_token') ?? '';
    final String cartId = prefs.getString('cart_id') ?? '';

    print('Token: $token');
    print('Cart ID: $cartId');

    if (cartId.isEmpty || token.isEmpty) {
      print('Error: Missing token or cartId');
      return;
    }



    final orderData = {
      "cartId": cartId,
    };

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/v1/orders/checkout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(orderData),
      );

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SuccessCheckoutPageView(),
          ),
        );
      } else {
        print('Error: ${response.body}');
        throw Exception('Failed to submit order: ${response.body}');
      }

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(error.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }


  List<Step> getSteps() => [
    Step(
      state: currentStep > 0 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 0,
      title: const Text(
        "Address",
        style: TextStyle(
          fontSize: 18,
        ),
      ),
      content: const Address(),
    ),
    Step(
      state: currentStep > 1 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 1,
      title: const Text(
        "Complete",
        style: TextStyle(
          fontSize: 18,
        ),
      ),
      content: const Payment(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          "Checkout",
          style: TextStyle(
            color: buttonColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: isCompleted
          ? CheckCart()
          : Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(primary: buttonColor),
        ),
        child: Stepper(
          type: StepperType.vertical,
          steps: getSteps(),
          currentStep: currentStep,
          onStepContinue: () {
            final isLastStep = currentStep == getSteps().length - 1;
            if (isLastStep) {
              _submitOrder();
              setState(() => isCompleted = true);
            } else {
              setState(() => currentStep += 1);
            }
          },
          onStepTapped: (step) => setState(() => currentStep = step),
          onStepCancel: currentStep == 0
              ? null
              : () {
            setState(() => currentStep -= 1);
          },
          controlsBuilder: (BuildContext context, ControlsDetails controls) {
            final isLastStep = currentStep == getSteps().length - 1;
            return Container(
              margin: EdgeInsets.only(top: SizeConfig.screenHeight! / 68.3),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: controls.onStepContinue,
                      child: Container(
                        height: SizeConfig.screenHeight! / 13.66,
                        decoration: BoxDecoration(
                          color: buttonColor,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Center(
                          child: Text(
                            isLastStep ? "Confirm" : "Next",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: SizeConfig.screenHeight! / 37.95,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: SizeConfig.screenWidth! / 34.25,
                  ),
                  if (currentStep != 0)
                    Expanded(
                      child: InkWell(
                        onTap: controls.onStepCancel,
                        child: Container(
                          height: SizeConfig.screenHeight! / 13.66,
                          decoration: BoxDecoration(
                            color: buttonColor,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Center(
                            child: Text(
                              "Back",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: SizeConfig.screenHeight! / 37.95,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
