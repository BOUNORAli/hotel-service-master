import 'package:flutter/material.dart';
import 'package:food_order_ui/services/api_service.dart';
import 'package:food_order_ui/services/cart_api.dart';
import 'package:food_order_ui/view/home_page/components/food_part.dart';
import 'package:food_order_ui/view/home_page/widgets/categories.dart';
import 'package:food_order_ui/view/home_page/widgets/popular.dart';
import 'package:food_order_ui/view/home_page/widgets/recommed.dart';
import 'package:food_order_ui/view/home_page/widgets/search_food.dart';
import 'package:food_order_ui/view/home_page/widgets/username_text.dart';
import 'package:food_order_ui/view/login_page/login_page_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:food_order_ui/configuration/food.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';



import '../../utils/shared_preferences.dart';
import 'components/size_config.dart';
import 'package:http/http.dart' as http;

class HomePageView extends StatefulWidget {
  const HomePageView({Key? key}) : super(key: key);

  @override
  _HomePageViewState createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  String? username;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final sharedPrefsUtil = SharedPrefsUtil();
      await sharedPrefsUtil.initPrefs();
      final accessToken = sharedPrefsUtil.getToken();
      print("Access token retrieved in HomePage: $accessToken");

      if (accessToken == null || accessToken.isEmpty) {
        throw Exception("Token not found or empty");
      }


      bool tokenValid = await _isTokenValid(accessToken);
      if (!tokenValid) {
        throw Exception("Token is invalid or expired");
      }


      var userData = await ApiService.fetchUserData(accessToken);


      print("User data fetched: $userData");

      if (userData == null || !userData.containsKey('firstname')) {
        throw Exception("Failed to load user data: Missing user information");
      }

      setState(() {
        username = userData['firstname'] ?? "Guest";
      });

      await _checkOrCreateCart(userData['id']);
    } catch (error) {
      print("Error loading user data: $error");
      _navigateToLoginPage();
    }
  }


  Future<void> _checkOrCreateCart(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cartId = prefs.getString('cart_id');

  }

  void _navigateToLoginPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPageView()),
    );
  }

  void _toggleFavorite(Food food) async {
    print('Toggle favorite for food: ${food.name}');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('access_token') ?? '';
    var headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };

    var uri = Uri.parse('http://localhost:8080/api/v1/foods/favorite/${food.id}');
    var response = await http.post(uri, headers: headers);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      setState(() {
        food.isFavorite = !food.isFavorite;
      });
      print('Favorite status toggled: ${food.isFavorite}');
    } else {
      print('Failed to toggle favorite status: ${response.body}');
    }
  }

  Future<bool> _isTokenValid(String token) async {
    try {

      final jwt = JWT.decode(token);
      final expiryDate = jwt.payload['exp'];

      if (DateTime.now().millisecondsSinceEpoch / 1000 > expiryDate) {

        return false;
      }

      return true;
    } catch (e) {
      print("Error validating token: $e");
      return false;
    }
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            UserNameText(username: username),
            const SearchFood(),
            FoodPart(partName: "Categories"),
            const CategoriesFood(),
            FoodPart(partName: "Recommend"),
            RecommendFoods(
              onToggleFavorite: _toggleFavorite,
            ),
            FoodPart(partName: "Popular"),
            PopularFoods(
              onToggleFavorite: _toggleFavorite,
            ),
          ],
        ),
      ),
    );
  }
}
