import 'package:flutter/material.dart';
import 'package:food_order_ui/configuration/food.dart';
import 'package:food_order_ui/services/food_api.dart';
import 'package:food_order_ui/view/home_page/components/size_config.dart';
import 'package:flutter/material.dart';
import 'package:food_order_ui/configuration/food.dart';
import 'package:food_order_ui/services/food_api.dart';
import 'package:food_order_ui/view/food_detail_page/food_detail_view.dart';
import 'package:food_order_ui/view/home_page/components/colors.dart';
import 'package:food_order_ui/view/home_page/components/size_config.dart';

import 'package:flutter/material.dart';
import 'package:food_order_ui/configuration/food.dart';
import 'package:food_order_ui/services/food_api.dart';
import 'package:food_order_ui/view/home_page/components/size_config.dart';

class RecommendFoods extends StatefulWidget {
  final Function(Food) onToggleFavorite;

  const RecommendFoods({Key? key, required this.onToggleFavorite}) : super(key: key);

  @override
  _RecommendFoodsState createState() => _RecommendFoodsState();
}

class _RecommendFoodsState extends State<RecommendFoods> {
  late Future<List<Food>> _fetchRecommendFoods;

  @override
  void initState() {
    super.initState();
    _fetchRecommendFoods = FoodApi.fetchRecommendFoods();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Food>>(
      future: _fetchRecommendFoods,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var foodList = snapshot.data;
          return SizedBox(
            height: SizeConfig.screenHeight! / 2.58,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: foodList!.length,
              itemBuilder: (context, index) {
                final Food food = foodList[index];
                final List<String> categoryNames = food.categories
                    .map((category) => category.categoryName)
                    .toList();
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FoodDetailView(food: food),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(
                          SizeConfig.screenWidth! / 34.25,
                          SizeConfig.screenHeight! / 170.75,
                          SizeConfig.screenWidth! / 41.1,
                          SizeConfig.screenHeight! / 170.75,
                        ),
                        height: SizeConfig.screenHeight! / 2.73,
                        width: SizeConfig.screenWidth! / 2.055,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(4, 6),
                                blurRadius: 4,
                                color: Colors.black.withOpacity(0.3),
                              )
                            ]),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(food.imageUrl),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            Positioned(
                                left: SizeConfig.screenWidth! / 34.25,
                                bottom: SizeConfig.screenHeight! / 45.54,
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(food.name,
                                        style: TextStyle(
                                            fontSize: SizeConfig.screenHeight! / 34.15,
                                            color: Colors.white)),
                                    Text(categoryNames.join(', '),
                                        style: TextStyle(
                                            fontSize: SizeConfig.screenHeight! / 48.79,
                                            color: Colors.white)),
                                    Text("\$${food.price}",
                                        style: TextStyle(
                                            fontSize: SizeConfig.screenHeight! / 37.95,
                                            color: Colors.white))
                                  ],
                                )),
                            Positioned(
                              top: SizeConfig.screenHeight! / 68.3,
                              right: SizeConfig.screenWidth! / 41.1,
                              child: IconButton(
                                icon: Icon(
                                  food.isFavorite ? Icons.favorite : Icons.favorite_border,
                                  color: food.isFavorite ? Colors.red : Colors.grey,
                                ),
                                onPressed: () {
                                  widget.onToggleFavorite(food);
                                  setState(() {
                                    food.isFavorite = !food.isFavorite;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        } else {
          return const Center();
        }
      },
    );
  }
}
