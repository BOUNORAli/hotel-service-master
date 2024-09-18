import 'package:flutter/material.dart';
import 'package:food_order_ui/view/home_page/components/size_config.dart';

class RouterText extends StatelessWidget {
  final String text;

  const RouterText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double paddingValue = SizeConfig.screenHeight! / 85.38;
    final double fontSizeValue = SizeConfig.screenHeight! / 27.32;

    return Padding(
      padding: EdgeInsets.only(top: paddingValue, bottom: paddingValue),
      child: Text(
        text,
        style: TextStyle(color: Colors.black54, fontSize: fontSizeValue),
      ),
    );
  }
}
