import 'package:food_order_ui/configuration/order_item.dart';

class Order {
  final String id;
  final String name;
  final String address;
  final String paymentId;
  final double totalPrice;
  final List<OrderItem> items;
  final String status;
  final String user;
  final DateTime createdAt;
  final DateTime updatedAt;

  Order({
    required this.id,
    required this.name,
    required this.address,
    required this.paymentId,
    required this.totalPrice,
    required this.items,
    required this.status,
    required this.user,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      paymentId: json['paymentId'],
      totalPrice: json['totalPrice'],
      items: (json['items'] as List).map((i) => OrderItem.fromJson(i)).toList(),
      status: json['status'],
      user: json['user'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'paymentId': paymentId,
      'totalPrice': totalPrice,
      'items': items.map((i) => i.toJson()).toList(),
      'status': status,
      'user': user,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Order copyWith({
    String? id,
    String? name,
    String? address,
    String? paymentId,
    double? totalPrice,
    List<OrderItem>? items,
    String? status,
    String? user,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Order(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      paymentId: paymentId ?? this.paymentId,
      totalPrice: totalPrice ?? this.totalPrice,
      items: items ?? this.items,
      status: status ?? this.status,
      user: user ?? this.user,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
