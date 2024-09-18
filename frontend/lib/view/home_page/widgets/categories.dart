import 'package:flutter/material.dart';
import 'package:food_order_ui/configuration/category.dart';
import 'package:food_order_ui/services/category_api.dart';
import 'package:food_order_ui/view/home_page/components/size_config.dart';

class CategoriesFood extends StatefulWidget {
  const CategoriesFood({Key? key}) : super(key: key);

  @override
  _CategoriesFoodState createState() => _CategoriesFoodState();
}

class _CategoriesFoodState extends State<CategoriesFood> {
  late Future<List<Category>> _categoryFuture;

  @override
  void initState() {
    super.initState();
    _categoryFuture = CategoryApi.fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Category>>(
      future: _categoryFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          var categoryList = snapshot.data!;
          return SizedBox(
            height: SizeConfig.screenHeight! / 8.04,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categoryList.length,
              itemBuilder: (context, index) {
                var category = categoryList[index];
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // dir smth
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(
                          SizeConfig.screenWidth! / 34.25,
                          SizeConfig.screenHeight! / 170.75,
                          SizeConfig.screenWidth! / 20.55,
                          SizeConfig.screenHeight! / 170.75,
                        ),
                        height: SizeConfig.screenHeight! / 15.18,
                        width: SizeConfig.screenWidth! / 9.14,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(category.categoryImage),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          category.categoryName,
                          style: TextStyle(
                            fontSize: SizeConfig.screenHeight! / 52.54,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ],
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
