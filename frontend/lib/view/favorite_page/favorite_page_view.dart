import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_order_ui/configuration/food.dart';
import 'package:food_order_ui/view/favorite_page/widgets/favorite_cart_icon.dart';
import 'package:food_order_ui/view/favorite_page/widgets/favorite_icon.dart';
import 'package:food_order_ui/view/favorite_page/widgets/favorite_image.dart';
import 'package:food_order_ui/view/home_page/components/size_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FavoritePageView extends StatefulWidget {
  const FavoritePageView({Key? key}) : super(key: key);

  @override
  _FavoritePageViewState createState() => _FavoritePageViewState();
}

class _FavoritePageViewState extends State<FavoritePageView> {
  Future<List<Food>> _fetchFavoriteFoods() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('access_token') ?? '';
    var headers = {
      'Authorization': 'Bearer $accessToken',
    };
    var uri = Uri.parse('http://localhost:8080/api/v1/foods/favorite');
    var response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final responseBody = response.body;
      if (responseBody != null && responseBody.isNotEmpty) {
        final Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
        if (jsonResponse.containsKey('results')) {
          final List<dynamic> data = jsonResponse['results'];
          return data.map((json) => Food.fromJson(json)).toList();
        } else {
          throw Exception('Response does not contain results');
        }
      } else {
        throw Exception('Response body is null or empty');
      }
    } else {
      throw Exception('Failed to load favorite foods');
    }
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "My Favorite",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.screenWidth! / 20.0,
          vertical: SizeConfig.screenHeight! / 136.6,
        ),
        child: FutureBuilder<List<Food>>(
          future: _fetchFavoriteFoods(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var foodList = snapshot.data;
              return GridView.builder(
                itemCount: foodList!.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  childAspectRatio: 3.2 / 4,
                ),
                itemBuilder: (context, index) {
                  var food = foodList[index];
                  return Stack(
                    children: [
                      Container(
                        height: SizeConfig.screenHeight! / 3.10,
                        width: SizeConfig.screenWidth! / 2.06,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30.0),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 3),
                              blurRadius: 6,
                              color: Colors.black.withOpacity(0.1),
                            )
                          ],
                        ),
                        child: Stack(
                          children: [
                            FavoriteDetail(
                              food_image_name: food.imageUrl,
                              food_name: food.name,
                              food_price: food.price.toString(),
                            ),
                            FavoriteCartIcon(),
                            FavoriteIcon(
                              isFavorite: food.isFavorite,
                              onTap: () => _toggleFavorite(food),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            } else {
              return Padding(
                padding: EdgeInsets.only(
                  top: SizeConfig.screenHeight! / 3.10,
                ),
                child: Column(
                  children: [
                    Center(
                      child: Icon(
                        Icons.favorite,
                        color: Colors.black12,
                        size: SizeConfig.screenHeight! / 11.39,
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight! / 34.15,
                    ),
                    Center(
                      child: Text(
                        "Your Favorite Foods",
                        style: TextStyle(
                          color: Colors.black12,
                          fontSize: SizeConfig.screenHeight! / 34.15,
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
