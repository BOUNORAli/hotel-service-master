import 'package:flutter/material.dart';
import 'package:food_order_ui/view/cart_page/widgets/bottom_bar_widget/three_d_secure.dart';
import 'package:food_order_ui/view/cart_page/widgets/bottom_bar_widget/bottombar_text.dart';
import 'package:food_order_ui/view/cart_page/widgets/bottom_bar_widget/checkout_button.dart';
import 'package:food_order_ui/view/food_detail_page/components/separator.dart';
import 'package:food_order_ui/view/home_page/components/size_config.dart';

class BottomBar extends StatefulWidget {
  final String totalAmount;

  const BottomBar({Key? key, required this.totalAmount}) : super(key: key);

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.screenHeight! / 15.0,
        horizontal: SizeConfig.screenHeight! / 30.0,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
              EdgeInsets.only(bottom: SizeConfig.screenHeight! / 85.37),
              child: const MySeparator(
                color: Colors.grey,
              ),
            ),
            const ThreeDSecure(),
            SizedBox(
              height: SizeConfig.screenHeight! / 45.54,
            ),
            BottomBarText(
              titleText: "Subtotal",
              priceText: "\$${double.parse(widget.totalAmount).toStringAsFixed(2)}",
              fontSize: SizeConfig.screenHeight! / 45.54,
              fontWeight: FontWeight.w400,
              textColor: Colors.black54,
            ),
            SizedBox(
              height: SizeConfig.screenHeight! / 45.54,
            ),
            BottomBarText(
              titleText: "Discount",
              priceText: "\$0.0",
              fontSize: SizeConfig.screenHeight! / 45.54,
              fontWeight: FontWeight.w400,
              textColor: Colors.black54,
            ),
            SizedBox(
              height: SizeConfig.screenHeight! / 45.54,
            ),
            BottomBarText(
              titleText: "Total",
              priceText: "\$${double.parse(widget.totalAmount).toStringAsFixed(2)}",
              fontSize: SizeConfig.screenHeight! / 37.95,
              fontWeight: FontWeight.bold,
              textColor: Colors.black,
            ),
            SizedBox(height: SizeConfig.screenHeight! / 34.15),
            const CheckoutButton(),
          ],
        ),
      ),
    );
  }
}
