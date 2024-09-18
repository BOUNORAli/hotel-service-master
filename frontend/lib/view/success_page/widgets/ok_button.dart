import 'package:flutter/material.dart';
import 'package:food_order_ui/view/home_page/components/colors.dart';
import 'package:food_order_ui/view/home_page/components/size_config.dart';

class OkButton extends StatefulWidget {
  final VoidCallback onTap;
  final String buttonText;

  const OkButton({Key? key, required this.onTap, required this.buttonText})
      : super(key: key);

  @override
  _OkButtonState createState() => _OkButtonState();
}

class _OkButtonState extends State<OkButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        width: SizeConfig.screenWidth! / 2,
        height: SizeConfig.screenHeight! / 12.42,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            widget.buttonText,
            style: TextStyle(
              color: Colors.white,
              fontSize: SizeConfig.screenHeight! / 37.95,
            ),
          ),
        ),
      ),
    );
  }
}
