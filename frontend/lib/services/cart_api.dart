import 'dart:convert';
import 'package:food_order_ui/configuration/cart.dart';
import 'package:food_order_ui/configuration/order_item.dart';
import 'package:food_order_ui/utils/api_endpoints.dart';
import 'package:food_order_ui/utils/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CartApi {
  static Future<void> createEmptyCart(String userId) async {
    final sharedPrefsUtil = SharedPrefsUtil();
    await sharedPrefsUtil.initPrefs();
    final accessToken = sharedPrefsUtil.getToken();

    var uri = Uri.parse(
        '${ApiEnPoints.baseUrl}${ApiEnPoints.cartEndpoints.emptyCart}?id=$userId');
    var response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer $accessToken', 'accept': '*/*'},
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create empty cart: ${response.reasonPhrase}');
    } else {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      String? cartId = responseData['results']['id'];
      await sharedPrefsUtil.saveCartId(cartId);
    }
  }

  static Future<void> addOrderItemToCart(String cartId, OrderItem orderItem) async {
    final sharedPrefsUtil = SharedPrefsUtil();
    await sharedPrefsUtil.initPrefs();
    final accessToken = sharedPrefsUtil.getToken();

    var uri = Uri.parse('${ApiEnPoints.baseUrl}${ApiEnPoints.cartEndpoints.carts}$cartId/orderItems');
    var response = await http.put(
      uri,
      headers: {'Authorization': 'Bearer $accessToken', 'Content-Type': 'application/json'},
      body: jsonEncode(orderItem.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add order item to cart: ${response.reasonPhrase}');
    }
  }

  static Future<Cart?> getCartById(String cartId) async {
    final sharedPrefsUtil = SharedPrefsUtil();
    await sharedPrefsUtil.initPrefs();
    final accessToken = sharedPrefsUtil.getToken();
    var uri = Uri.parse('${ApiEnPoints.baseUrl}${ApiEnPoints.cartEndpoints.carts}$cartId');
    var headers = {'Authorization': 'Bearer $accessToken'};
    var response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final responseBody = response.body;
      if (responseBody.isNotEmpty) {
        final Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
        final Map<String, dynamic> results = jsonResponse['results'];
        if (results.isNotEmpty) {
          return Cart.fromJson(results);
        } else {
          print('Error loading cart: Response body does not contain valid data');
          return null;
        }
      } else {
        print('Error loading cart: Response body is null or empty');
        return null;
      }
    } else {
      print('Error loading cart: ${response.reasonPhrase}');
      return null;
    }
  }
}
