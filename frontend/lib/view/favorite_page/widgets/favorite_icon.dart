import 'package:flutter/material.dart';
import 'package:food_order_ui/view/home_page/components/size_config.dart';

class FavoriteIcon extends StatefulWidget {
  final bool isFavorite;
  final VoidCallback onTap;

  const FavoriteIcon({Key? key, required this.isFavorite, required this.onTap}) : super(key: key);

  @override
  _FavoriteIconState createState() => _FavoriteIconState();
}

class _FavoriteIconState extends State<FavoriteIcon> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: SizeConfig.screenHeight! / 56.92,
      right: SizeConfig.screenWidth! / 34.25,
      child: IconButton(
        icon: Icon(
          widget.isFavorite ? Icons.favorite : Icons.favorite_border,
          color: widget.isFavorite ? Colors.red : Colors.grey,
        ),
        onPressed: () {
          print('Favorite icon pressed');
          widget.onTap();
        },
      ),
    );
  }
}
