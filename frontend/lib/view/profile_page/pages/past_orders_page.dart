import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:food_order_ui/services/order_service.dart';
import 'package:food_order_ui/configuration/order.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PastOrdersPage extends StatefulWidget {
  const PastOrdersPage({Key? key}) : super(key: key);

  @override
  _PastOrdersPageState createState() => _PastOrdersPageState();
}

class _PastOrdersPageState extends State<PastOrdersPage> {
  List<Order> pastOrders = [];
  String? selectedStatus = 'All';
  final List<String> statusOptions = ['All', 'DELIVERED', 'PENDING', 'CONFIRMED'];

  @override
  void initState() {
    super.initState();
    _loadPastOrders();
  }

  Future<List<Order>> _fetchPastOrders({String? status}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    if (token != null && token.isNotEmpty) {
      Uri uri;
      if (status == null || status == "All") {
        uri = Uri.parse('http://localhost:8080/api/v1/orders/past');
      } else {
        uri = Uri.parse('http://localhost:8080/api/v1/orders/past?status=$status');
      }

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)['results'];
        return data.map((json) => Order.fromJson(json)).toList();
      } else {
        print("Error fetching past orders: ${response.statusCode}");
        return [];
      }
    } else {
      print("Token is null or empty.");
      return [];
    }
  }

  Future<void> _loadPastOrders({String? status}) async {
    List<Order> orders;
    orders = await _fetchPastOrders(status: status);
    setState(() {
      pastOrders = orders;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Past Orders'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: DropdownButton<String>(
              value: selectedStatus ?? 'All',
              isExpanded: true,
              icon: const Icon(Icons.filter_list),
              onChanged: (String? newValue) {
                setState(() {
                  selectedStatus = newValue;
                });
                _loadPastOrders(status: selectedStatus);
              },
              items: statusOptions.map((String status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: pastOrders.isEmpty
                ? const Center(child: Text('No past orders found'))
                : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListView.builder(
                itemCount: pastOrders.length,
                itemBuilder: (context, index) {
                  var order = pastOrders[index];
                  var totalPrice = order.totalPrice != null
                      ? order.totalPrice.toStringAsFixed(2)
                      : 'N/A';
                  var orderItems = order.items;

                  return Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 4.0),
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order ID: ${order.id}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Total Price: \$$totalPrice',
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Status: ${order.status}',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.grey),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Items:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          const SizedBox(height: 5),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: orderItems.map((item) {
                              var food = item.food;
                              return Padding(
                                padding:
                                const EdgeInsets.only(bottom: 4.0),
                                child: Text(
                                  '${food.name} x ${item.quantity} (\$${item.price})',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
