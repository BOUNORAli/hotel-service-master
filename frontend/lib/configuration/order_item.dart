import 'package:food_order_ui/configuration/food.dart';

class OrderItem {
  late String id;
  late Food food;
  late String price;
  late int quantity;

  OrderItem({
    required this.id,
    required this.food,
    required this.price,
    required this.quantity,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] ?? '',
      food: json['food'] != null ? Food.fromJson(json['food']) : Food(id: '', name: '', price: '0', categories: [], imageUrl: ''),
      price: (json['price'] ?? '0').toString(),
      quantity: json['quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'food': food.toJson(),
    'price': price,
    'quantity': quantity,
  };
}
