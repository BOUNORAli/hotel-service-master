import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:food_order_ui/configuration/order.dart';
import 'package:food_order_ui/utils/shared_preferences.dart';

class OrderService {
  static const String baseUrl = 'http://localhost:8080/api/v1/orders';

  static Future<List<Order>> getOrders(String token) async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((order) => Order.fromJson(order)).toList();
    } else {
      throw Exception('Failed to load orders');
    }
  }

  static Future<void> createOrder(Order order, String token) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(order.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create order');
    }
  }

  static Future<void> updateOrder(String orderId, Order updatedOrder, String token) async {
    final url = '$baseUrl/$orderId';
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(updatedOrder.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update order');
    }
  }

  static Future<void> deleteOrder(String orderId, String token) async {
    final url = '$baseUrl/$orderId';
    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete order');
    }
  }
}
