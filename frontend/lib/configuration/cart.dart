import 'package:food_order_ui/configuration/order_item.dart';

class Cart {
  late String id;
  late String userId;
  late List<OrderItem> items;
  late String status;
  late String totalPrice;
  late String createdAt;
  late String updatedAt;

  Cart({
    required this.id,
    required this.userId,
    required this.items,
    required this.status,
    required this.totalPrice,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Cart.fromJson(Map<String, dynamic>? json) {
    if (json == null || json.isEmpty) {
      throw ArgumentError('Invalid JSON: json parameter cannot be null or empty');
    }

    return Cart(
      id: json['id'] as String,
      userId: json['userId'] as String,
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => OrderItem.fromJson(item))
          .toList() ?? [],
      status: json['status'] as String,
      totalPrice: json['totalPrice'].toString(),
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );
  }
}
