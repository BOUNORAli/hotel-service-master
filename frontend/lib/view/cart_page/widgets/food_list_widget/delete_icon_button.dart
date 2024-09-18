import 'package:flutter/material.dart';
import 'package:food_order_ui/utils/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../cart_view.dart';

class DeleteIconButton extends StatelessWidget {
  final String foodName;
  final String id;

  const DeleteIconButton({Key? key, required this.foodName, required this.id}) : super(key: key);

  Future<void> _deleteOrderItem(BuildContext context) async {
    final sharedPrefsUtil = SharedPrefsUtil();
    await sharedPrefsUtil.initPrefs(); // Initialisation des préférences partagées
    final accessToken = sharedPrefsUtil.getToken();
    final cartId = sharedPrefsUtil.getCartId();
    final url = 'http://localhost:8080/api/v1/carts/$cartId/orderItems/$id';

    final headers = {'Authorization': 'Bearer $accessToken', 'accept': '*/*'};

    try {
      final response = await http.delete(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Successfully deleted $foodName')),
        );
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => CartView()));
      } else {
        throw Exception('Failed to delete $foodName: ${response.reasonPhrase}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Delete $foodName?"),
            action: SnackBarAction(
              label: "Yes",
              onPressed: () {
                _deleteOrderItem(context);
              },
            ),
          ),
        );
      },
      icon: const Icon(Icons.delete_outline, color: Colors.black54),
    );
  }
}
