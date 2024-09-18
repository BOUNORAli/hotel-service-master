import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:food_order_ui/configuration/order.dart';
import 'package:food_order_ui/utils/shared_preferences.dart';
import 'package:food_order_ui/configuration/food.dart';

class OrderService {
  static Future<List<Order>> getOrders(String token, {String? status}) async {
    Uri uri = Uri.parse('http://localhost:8080/api/v1/orders');
    if (status != null && status.isNotEmpty) {
      uri = Uri.parse('http://localhost:8080/api/v1/orders?status=$status');
    }

    print('Fetching orders with status: $status');
    print('Token: $token');

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['results'];
      List<Order> orders = data.map((orderJson) => Order.fromJson(orderJson)).toList();
      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return orders;
    } else {
      throw Exception('Failed to load orders');
    }
  }

  static Future<void> updateOrderStatus(String orderId, String newStatus, String token) async {
    print('Token: $token');

    final response = await http.patch(
      Uri.parse('http://localhost:8080/api/v1/orders/$orderId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'orderId': orderId,
        'status': newStatus,
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    print('Request body: ${jsonEncode({'orderId': orderId, 'status': newStatus})}');
    print('Headers: ${response.headers}');

    if (response.statusCode != 200) {
      throw Exception('Failed to update order status');
    }
  }

  static Future<List<Food>> getMostPurchasedFoods() async {
    try {
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

        var jsonResponse = json.decode(response.body);


        List jsonResponseResults = jsonResponse['results'];


        return jsonResponseResults.map((food) => Food.fromJson(food)).toList();
      } else {
        throw Exception('Failed to load most purchased foods');
      }
    } catch (e) {
      print('Error fetching most purchased foods: $e');
      throw e;
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
      var jsonResponse = json.decode(response.body);


      List<dynamic> jsonResponseResults = jsonResponse['results'];
      return jsonResponseResults.map((data) => OrderChartData.fromJson(data)).toList();
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

  static Future<List<Order>> getPastOrders(String token) async {
    Uri uri = Uri.parse('http://localhost:8080/api/v1/orders?status=DELIVERED');

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['results'];
      List<Order> orders = data.map((orderJson) => Order.fromJson(orderJson)).toList();
      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return orders;
    } else {
      throw Exception('Failed to load past orders');
    }
  }


}
