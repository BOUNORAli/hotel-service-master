import 'package:flutter/material.dart';
import 'package:food_order_ui/view/home_page/components/size_config.dart';
import 'package:food_order_ui/view/profile_page/widgets/top_custom_shape.dart';
import 'package:food_order_ui/view/profile_page/widgets/user_sections.dart';
import 'package:food_order_ui/view/profile_page/pages/my_information_page.dart';
import 'package:food_order_ui/view/profile_page/pages/past_orders_page.dart';
import 'package:food_order_ui/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePageView extends StatefulWidget {
  const ProfilePageView({Key? key}) : super(key: key);

  @override
  _ProfilePageViewState createState() => _ProfilePageViewState();
}

class _ProfilePageViewState extends State<ProfilePageView> {
  String? userName = "John Doe";
  String? userEmail = "john.doe@example.com";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      if (token != null) {
        var userData = await ApiService.fetchUserData(token);
        setState(() {
          userName = userData['firstname'] + ' ' + userData['lastname'];
          userEmail = userData['email'];
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text("Profile", style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TopCustomShape(userName: userName ?? "", userEmail: userEmail ?? ""),
          SizedBox(height: SizeConfig.screenHeight! / 34.15), // 20.0
          UserSection(
            icon_name: Icons.account_circle,
            section_text: "My information",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyInformationPage()),
              );
            },
          ),
          UserSection(
            icon_name: Icons.shopping_basket,
            section_text: "Past orders",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PastOrdersPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
