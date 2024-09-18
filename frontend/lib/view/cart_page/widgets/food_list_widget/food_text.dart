import 'package:flutter/material.dart';
import 'package:food_order_ui/view/home_page/components/colors.dart';
import 'package:food_order_ui/view/home_page/components/size_config.dart';

class FoodText extends StatefulWidget {
  final String foodName;
  final double foodPrice;
  final int quantity;
  const FoodText({Key? key, required this.foodName, required this.foodPrice,required this.quantity}) : super(key: key);

  @override
  State<FoodText> createState() => _FoodTextState();
}

class _FoodTextState extends State<FoodText> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.foodName,
          style: TextStyle(color: Colors.black, fontSize: SizeConfig.screenHeight!/42.69),                 /// 16
          maxLines: 2,
        ),
        SizedBox(height: SizeConfig.screenHeight!/341.5),        /// 2.0
        Text.rich(
          TextSpan(
            text: "\$${widget.foodPrice}",
            style: TextStyle(
                fontWeight: FontWeight.w600, color: buttonColor, fontSize: SizeConfig.screenHeight!/37.95   /// 18
            ),
            children: [
              TextSpan(
                  text: " x ${widget.quantity}",
                  style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ),
      ],
    );
  }
}
