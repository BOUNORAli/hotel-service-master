import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:food_order_ui/configuration/food.dart';
import 'package:food_order_ui/view/cart_page/cart_view.dart';
import 'package:food_order_ui/view/food_detail_page/components/separator.dart';
import 'package:food_order_ui/view/home_page/components/colors.dart';
import 'package:food_order_ui/view/home_page/components/size_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class IncreaseDecrease extends StatefulWidget {
  final Food food;

  const IncreaseDecrease({Key? key, required this.food}) : super(key: key);

  @override
  _IncreaseDecreaseState createState() => _IncreaseDecreaseState();
}

class _IncreaseDecreaseState extends State<IncreaseDecrease> {
  int _counter = 1;

  void _increaseCart() {
    setState(() {
      _counter++;
    });
  }

  void _decreaseCart() {
    setState(() {
      if (_counter > 1) {
        _counter--;
      } else {
        _counter = 1;
      }
    });
  }

  double getTotalPrice() {
    double price = double.parse(widget.food.price.toString());
    return price * _counter;
  }

  Future<void> _addOrderItem() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String accessToken = prefs.getString('access_token') ?? '';
      String cartId = prefs.getString('cart_id') ?? '';

      if (cartId.isEmpty) {
        // Create a new cart if cartId is empty
        await _createEmptyCart();
        cartId = prefs.getString('cart_id') ?? '';
      }

      if (cartId.isEmpty) {
        // Still empty after trying to create, handle error
        print('Error: Failed to create or retrieve cart ID');
        return;
      }

      String url = 'http://localhost:8080/api/v1/carts/$cartId/orderItems';
      Map<String, dynamic> body = {
        'id': 'orderItemId', // Provide the correct orderItemId
        'food': {
          'id': widget.food.id,
          'name': widget.food.name,
          'price': widget.food.price,
          // Add other food details if necessary
        },
        'price': getTotalPrice(),
        'quantity': _counter,
      };

      // Convert body to JSON
      String jsonBody = jsonEncode(body);

      // Send PUT request
      var response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'accept': '*/*',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonBody,
      );

      if (response.statusCode == 200) {
        // Successfully added the item to the cart
        print('Item added to cart successfully');
        _showSuccessDialog();
      } else {
        // Failed to add the item to the cart
        print('Failed to add item to cart: ${response.reasonPhrase}');
      }
    } catch (error) {
      // Handle errors while consuming the API
      print('Error adding item to cart: $error');
    }
  }


  Future<void> _createEmptyCart() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String accessToken = prefs.getString('access_token') ?? '';
      String userId = 'yourUserId'; // Retrieve userId from SharedPreferences or other means
      String url = 'http://localhost:8080/api/v1/carts/createEmptyCart?id=$userId';

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'accept': '*/*',
        },
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        String? cartId = responseData['results']['id'];
        await prefs.setString('cart_id', cartId ?? '');
        print('Cart created successfully with ID: $cartId');
      } else {
        throw Exception('Failed to create empty cart: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error creating empty cart: $error');
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Successful",
            style: TextStyle(color: successColor),
          ),
          content: Text(
            "You have successfully added food to cart.",
            style: TextStyle(color: successColor),
          ),
          backgroundColor: Colors.white,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => CartView()),
                );
              },
              child: Text(
                "OK",
                style: TextStyle(color: successColor),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Padding(
      padding: EdgeInsets.only(top: SizeConfig.screenHeight! / 45.54),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: SizeConfig.screenHeight! / 68.3,
              bottom: SizeConfig.screenHeight! / 34.15,
            ),
            child: MySeparator(
              color: Colors.grey,
            ),
          ),
          Text(
            "Total",
            style: TextStyle(
                color: Colors.black54,
                fontSize: SizeConfig.screenHeight! / 42.69),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "\$${getTotalPrice().toStringAsFixed(2)}",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: SizeConfig.screenHeight! / 27.32),
                  ),
                ],
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        _decreaseCart();
                      },
                      child: Container(
                        height: SizeConfig.screenHeight! / 13.94,
                        width: SizeConfig.screenWidth! / 8.39,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: buttonColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(15),
                          color: textColor.withOpacity(0.1),
                        ),
                        child: Center(
                          child: Icon(Icons.remove, color: buttonColor),
                        ),
                      ),
                    ),
                    Container(
                      width: SizeConfig.screenWidth! / 6.85,
                      height: SizeConfig.screenHeight! / 13.94,
                      child: Center(
                        child: Text(
                          "${_counter}",
                          style: TextStyle(
                              fontSize: SizeConfig.screenHeight! / 37.95,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _increaseCart();
                      },
                      child: Container(
                        height: SizeConfig.screenHeight! / 13.94,
                        width: SizeConfig.screenWidth! / 8.39,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: buttonColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(15),
                          color: textColor.withOpacity(0.4),
                        ),
                        child: Center(
                          child: Icon(Icons.add, color: buttonColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              top: SizeConfig.screenHeight! / 34.15,
            ),
            child: Center(
              child: Container(
                width: SizeConfig.screenWidth! / 1.37,
                decoration: BoxDecoration(
                  color: buttonColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all(Size(
                        SizeConfig.screenWidth! / 1.37,
                        SizeConfig.screenHeight! / 11.66)),
                    backgroundColor:
                    MaterialStateProperty.all(Colors.transparent),
                    shadowColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  onPressed: _addOrderItem,
                  // Call _addOrderItem method when the button is pressed
                  child: Wrap(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            right: SizeConfig.screenWidth! / 51.38),
                        child: Icon(
                          Icons.shopping_cart_rounded,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Add to Cart",
                        style: TextStyle(
                          fontSize: SizeConfig.screenHeight! / 34.15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
