import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:food_order_ui/configuration/order.dart';
import 'package:food_order_ui/utils/shared_preferences.dart';
import 'package:food_order_ui/utils/shared_preferences.dart';
import 'package:food_order_ui/configuration/food.dart';

class OrderApi {
  static const String baseUrl = 'http://localhost:8080/api/v1/orders';

  static Future<List<Order>> getOrders() async {
    final sharedPrefsUtil = SharedPrefsUtil();
    await sharedPrefsUtil.initPrefs();
    String token = sharedPrefsUtil.getToken();
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
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

  static Future<void> updateOrderStatus(String orderId, String status) async {
    final sharedPrefsUtil = SharedPrefsUtil();
    await sharedPrefsUtil.initPrefs();
    String token = sharedPrefsUtil.getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/$orderId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'status': status}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update order status');
    }
  }

  static Future<void> createOrder(Order order) async {
    final sharedPrefsUtil = SharedPrefsUtil();
    await sharedPrefsUtil.initPrefs();
    String token = sharedPrefsUtil.getToken();
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(order.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create order');
    }
  }

  static Future<List<Food>> getMostPurchasedFoods() async {
    final sharedPrefsUtil = SharedPrefsUtil();
    await sharedPrefsUtil.initPrefs();
    String? token = sharedPrefsUtil.getToken();
    final response = await http.get(
      Uri.parse('http://localhost:8080/api/v1/orders/most-purchased'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((food) => Food.fromJson(food)).toList();
    } else {
      throw Exception('Failed to load most purchased foods');
    }
  }

  static Future<List<OrderChartData>> getOrdersOverTime() async {
    final sharedPrefsUtil = SharedPrefsUtil();
    await sharedPrefsUtil.initPrefs();
    String? token = sharedPrefsUtil.getToken();
    final response = await http.get(
      Uri.parse('http://localhost:8080/api/v1/orders/over-time'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => OrderChartData.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load orders over time');
    }
  }
}

class OrderChartData {
  final String date;
  final int orderCount;

  OrderChartData({required this.date, required this.orderCount});

  factory OrderChartData.fromJson(Map<String, dynamic> json) {
    return OrderChartData(
      date: json['date'] as String,
      orderCount: json['orderCount'] as int,
    );
  }
}
