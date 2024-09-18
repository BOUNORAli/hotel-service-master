import 'package:flutter/material.dart';
import 'package:food_order_ui/configuration/food.dart';
import 'package:food_order_ui/services/food_api.dart';
import 'package:food_order_ui/view/food_detail_page/food_detail_view.dart';
import 'package:food_order_ui/view/home_page/components/colors.dart';
import 'package:food_order_ui/view/home_page/components/size_config.dart';

class PopularFoods extends StatefulWidget {
  final Function(Food) onToggleFavorite;

  const PopularFoods({Key? key, required this.onToggleFavorite}) : super(key: key);

  @override
  _PopularFoodsState createState() => _PopularFoodsState();
}

class _PopularFoodsState extends State<PopularFoods> {
  late Future<List<Food>> _popularFoodsFuture;

  @override
  void initState() {
    super.initState();
    _popularFoodsFuture = FoodApi.fetchPopularFoods();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Food>>(
      future: _popularFoodsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final List<Food>? foodList = snapshot.data;
          return SizedBox(
            height: SizeConfig.screenHeight! / 2.28,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: foodList!.length,
              itemBuilder: (context, index) {
                final Food food = foodList[index];
                final List<String> categoryNames = food.categories
                    .map((category) => category.categoryName)
                    .toList();


                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FoodDetailView(food: food),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(
                            SizeConfig.screenWidth! / 34.25,
                            SizeConfig.screenHeight! / 113.84,
                            SizeConfig.screenWidth! / 34.25,
                            SizeConfig.screenHeight! / 22.77),
                        height: SizeConfig.screenHeight! / 3.105,
                        width: SizeConfig.screenWidth! / 2.74,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30.0),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 3),
                              blurRadius: 6,
                              color: Colors.black.withOpacity(0.3),
                            )
                          ],
                        ),
                        child: Stack(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: SizeConfig.screenHeight! / 6.83,
                                  width: SizeConfig.screenWidth! / 2.74,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(food.imageUrl),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(30.0),
                                        topRight: Radius.circular(30.0)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        food.name,
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize:
                                            SizeConfig.screenHeight! / 40,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Text(
                                        categoryNames.join(', '),
                                        style: TextStyle(
                                          color: Colors.black38,
                                          fontSize:
                                          SizeConfig.screenHeight! / 45,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: SizeConfig.screenHeight! /
                                                136.6),
                                        child: Text(
                                          "\$${food.price}",
                                          style: TextStyle(
                                              color: Colors.orange,
                                              fontSize:
                                              SizeConfig.screenHeight! /
                                                  38,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                height: SizeConfig.screenHeight! / 13.66,
                                width: SizeConfig.screenWidth! / 8.22,
                                decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: const BorderRadius.only(
                                      bottomRight: Radius.circular(30.0),
                                      topLeft: Radius.circular(30.0),
                                    )),
                                child: const Icon(
                                  Icons.shopping_cart_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Positioned(
                              top: SizeConfig.screenHeight! / 68.3,
                              right: SizeConfig.screenWidth! / 41.1,
                              child: IconButton(
                                icon: Icon(
                                  food.isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: food.isFavorite
                                      ? Colors.red
                                      : Colors.grey,
                                ),
                                onPressed: () {
                                  widget.onToggleFavorite(food);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        } else {
          return const Center(child: Text('No data available'));
        }
      },
    );
  }
}
