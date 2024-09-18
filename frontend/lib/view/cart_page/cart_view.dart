import 'package:flutter/material.dart';
import 'package:food_order_ui/configuration/cart.dart';
import 'package:food_order_ui/services/cart_api.dart';
import 'package:food_order_ui/view/cart_page/widgets/bottom_bar.dart';
import 'package:food_order_ui/view/cart_page/widgets/food_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:food_order_ui/view/cart_page/widgets/bottom_bar_widget/checkout_button.dart';
import 'dart:convert';
import 'package:food_order_ui/configuration/order_item.dart';
import 'package:http/http.dart' as http;

class CartView extends StatefulWidget {
  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  List<OrderItem> _orderItems = [];

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('access_token') ?? '';
    String cartId = prefs.getString('cart_id') ?? '';

    if (cartId.isEmpty) {
      print('Cart ID is empty');
      return;
    }

    String url = 'http://localhost:8080/api/v1/carts/$cartId/orderItems';

    try {
      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'accept': '*/*',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)['results'];
        setState(() {
          _orderItems = data.map((item) => OrderItem.fromJson(item)).toList();
        });
      } else {
        print('Failed to load cart items: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error loading cart items: $error');
    }
  }

  Future<void> _addOrderItemToCart(OrderItem orderItem) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('access_token') ?? '';
    String cartId = prefs.getString('cart_id') ?? '';

    if (cartId.isEmpty) {
      print('Cart ID is empty');
      return;
    }

    String url = 'http://localhost:8080/api/v1/carts/$cartId/orderItems';

    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'accept': '*/*',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(orderItem.toJson()),
      );

      if (response.statusCode == 200) {
        _loadCartItems();
      } else {
        print('Failed to add cart item: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error adding cart item: $error');
    }
  }

  Future<void> _removeCartItem(String itemId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('access_token') ?? '';
    String cartId = prefs.getString('cart_id') ?? '';

    if (cartId.isEmpty) {
      print('Cart ID is empty');
      return;
    }

    String url = 'http://localhost:8080/api/v1/carts/$cartId/orderItems/$itemId';

    try {
      var response = await http.delete(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'accept': '*/*',
        },
      );

      if (response.statusCode == 200) {
        _loadCartItems();
      } else {
        print('Failed to remove cart item: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error removing cart item: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
      ),
      body: _orderItems.isEmpty
          ? Center(child: Text('Empty Cart'))
          : ListView.builder(
        padding: EdgeInsets.only(bottom: 80),
        itemCount: _orderItems.length,
        itemBuilder: (context, index) {
          final item = _orderItems[index];
          return ListTile(
            title: Text(item.food.name),
            subtitle: Text('Price: \$${item.price}, Quantity: ${item.quantity}'),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _removeCartItem(item.id),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CheckoutButton(),
      ),
    );
  }
}
