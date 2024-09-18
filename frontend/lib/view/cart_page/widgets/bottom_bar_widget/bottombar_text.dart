import 'package:flutter/material.dart';

class BottomBarText extends StatefulWidget {
  final String titleText;
  final String priceText;
  final double fontSize;
  final FontWeight fontWeight;
  final Color textColor;

  const BottomBarText(
      {Key? key,
      required this.titleText,
      required this.priceText,
      required this.fontSize,
      required this.fontWeight,
      required this.textColor})
      : super(key: key);

  @override
  _BottomBarTextState createState() => _BottomBarTextState();
}

class _BottomBarTextState extends State<BottomBarText> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          widget.titleText,
          style: TextStyle(
              fontWeight: widget.fontWeight,
              fontSize: widget.fontSize,
              color: widget.textColor),
        ),
        const Spacer(),
        Text(
          widget.priceText,
          style: TextStyle(
              fontWeight: widget.fontWeight,
              fontSize: widget.fontSize,
              color: widget.textColor),
        ),
      ],
    );
  }
}
