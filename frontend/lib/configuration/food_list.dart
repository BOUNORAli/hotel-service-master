import 'package:food_order_ui/configuration/category.dart';
import 'package:food_order_ui/configuration/food.dart';

Future<List<Food>> bringTheFoods() async {
  var foodList = <Food>[];

  var f1 = Food(
      id: "1",
      name: "Chicken Curry Pasta",
      imageUrl: "assets/food/ChickenCurryPasta.jpg",
      categories: [
        Category(categoryId: "1", categoryName: "Chicken", categoryImage: "assets/category/chicken.png")
      ],
      price: "22");
  var f2 = Food(
      id: "2",
      name: "Explosion Burger",
      imageUrl: "assets/food/ExplosionBurger.jpg",
      categories: [
        Category(categoryId: "1", categoryName: "Chicken", categoryImage: "assets/category/chicken.png")
      ],
      price: "15");

  foodList.addAll([f1, f2]);

  return foodList;
}

Future<List<Category>> bringTheCategory() async {
  var categoryList = <Category>[];

  var c1 = Category(
      categoryId: "1",
      categoryName: "Chicken",
      categoryImage: "assets/category/chicken.png");
  var c2 = Category(
      categoryId: "2",
      categoryName: "Bakery",
      categoryImage: "assets/category/bakery.png");
  var c3 = Category(
      categoryId: "3",
      categoryName: "Fast Food",
      categoryImage: "assets/category/fastfood.png");
  var c4 = Category(
      categoryId: "4",
      categoryName: "Fish",
      categoryImage: "assets/category/fish.png");
  var c5 = Category(
      categoryId: "5",
      categoryName: "Fruit",
      categoryImage: "assets/category/fruit.png");
  var c6 = Category(
      categoryId: "6",
      categoryName: "Soup",
      categoryImage: "assets/category/soup.png");
  var c7 = Category(
      categoryId: "7",
      categoryName: "Vegetable",
      categoryImage: "assets/category/vegetable.png");

  categoryList.add(c1);
  categoryList.add(c2);
  categoryList.add(c3);
  categoryList.add(c4);
  categoryList.add(c5);
  categoryList.add(c6);
  categoryList.add(c7);

  return categoryList;
}
