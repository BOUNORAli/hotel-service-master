import 'package:flutter/material.dart';
import 'package:food_order_ui/view/home_page/components/colors.dart';
import 'package:food_order_ui/view/home_page/components/size_config.dart';
import 'package:food_order_ui/view/profile_page/components/CustomShape.dart';

class TopCustomShape extends StatelessWidget {
  final String userName;
  final String userEmail;

  const TopCustomShape({Key? key, required this.userName, required this.userEmail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeConfig.screenHeight! / 2.84, // 240.0
      child: Stack(
        children: [
          ClipPath(
            clipper: CustomShape(),
            child: Container(
              height: SizeConfig.screenHeight! / 4.56, // 150.0
              color: buttonColor,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  height: SizeConfig.screenHeight! / 4.88, // 140.0
                  width: SizeConfig.screenWidth! / 2.93, // 140.0
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: SizeConfig.screenWidth! / 51.37),
                      color: Colors.white,
                      image: DecorationImage(
                        image: AssetImage("assets/main/avatar.png"),
                      )),
                ),
                Text(userName, style: TextStyle(fontSize: 22)),
                SizedBox(height: SizeConfig.screenHeight! / 136.6), // 5.0
                Text(userEmail, style: TextStyle(fontWeight: FontWeight.w400, color: Colors.black45)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
