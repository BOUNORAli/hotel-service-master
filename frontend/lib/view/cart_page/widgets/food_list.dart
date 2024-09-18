import 'package:flutter/material.dart';
import 'package:food_order_ui/configuration/order_item.dart';
import 'package:food_order_ui/view/cart_page/widgets/food_list_widget/delete_icon_button.dart';
import 'package:food_order_ui/view/cart_page/widgets/food_list_widget/food_image.dart';
import 'package:food_order_ui/view/cart_page/widgets/food_list_widget/food_text.dart';
import 'package:food_order_ui/view/home_page/components/size_config.dart';

class FoodListWidget extends StatelessWidget {
  final List<OrderItem> orderItemList;

  const FoodListWidget({Key? key, required this.orderItemList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (orderItemList.isEmpty) {
      return const Center(
        child: Text(
          'Your cart is empty',
          style: TextStyle(fontSize: 20),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth! / 20),
      child: ListView.builder(
        itemCount: orderItemList.length,
        itemBuilder: (context, index) {
          var orderItem = orderItemList[index];
          return Padding(
            padding:
                EdgeInsets.symmetric(vertical: SizeConfig.screenHeight! / 68.3),
            child: Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
              },
              background: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.screenWidth! / 20.55),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE6E6),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Row(
                  children: [
                    Spacer(),
                    Icon(Icons.delete_outline),
                  ],
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.0),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(4, 6),
                      blurRadius: 4,
                      color: Colors.black.withOpacity(0.1),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    FoodImage(foodImage: orderItem.food.imageUrl),
                    SizedBox(width: SizeConfig.screenWidth! / 20.55),
                    FoodText(
                      foodName: orderItem.food.name,
                      foodPrice: double.parse(orderItem.food.price),
                      quantity: orderItem.quantity,
                    ),
                    const Spacer(),
                    DeleteIconButton(foodName: orderItem.food.name, id: orderItem.id,),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
