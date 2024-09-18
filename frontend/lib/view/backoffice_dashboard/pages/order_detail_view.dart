import 'package:flutter/material.dart';
import 'package:food_order_ui/configuration/order.dart';
import 'package:food_order_ui/services/order_service.dart';
import 'package:food_order_ui/utils/shared_preferences.dart';

class OrderDetailView extends StatefulWidget {
  final Order order;

  const OrderDetailView({Key? key, required this.order}) : super(key: key);

  @override
  _OrderDetailViewState createState() => _OrderDetailViewState();
}

class _OrderDetailViewState extends State<OrderDetailView> {
  late Order _order;
  bool _isUpdating = false;
  late SharedPrefsUtil _sharedPrefsUtil;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _order = widget.order;
    _sharedPrefsUtil = SharedPrefsUtil();
  }

  Future<void> _updateOrderStatus(String newStatus) async {
    setState(() {
      _isUpdating = true;
    });

    try {
      await _sharedPrefsUtil.initPrefs();
      String token = _sharedPrefsUtil.getToken();

      if (token == null || token.isEmpty) {
        throw Exception('Token is null or empty');
      }

      await OrderService.updateOrderStatus(widget.order.id, newStatus, token);
      setState(() {
        _order = _order.copyWith(status: newStatus);
        _isUpdating = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to update order status: $e';
        _isUpdating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isUpdating
            ? const Center(child: CircularProgressIndicator())
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${_order.name}', style: TextStyle(fontSize: 18)),
            Text('Address: ${_order.address}', style: TextStyle(fontSize: 18)),
            Text('Payment ID: ${_order.paymentId}', style: TextStyle(fontSize: 18)),
            Text('Total Price: ${_order.totalPrice}', style: TextStyle(fontSize: 18)),
            Text('Status: ${_order.status}', style: TextStyle(fontSize: 18)),
            Text('User: ${_order.user}', style: TextStyle(fontSize: 18)),
            Text('Created At: ${_order.createdAt}', style: TextStyle(fontSize: 18)),
            Text('Updated At: ${_order.updatedAt}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text('Items:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ..._order.items.map((item) => Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text('${item.food.name} - ${item.quantity} x ${item.price}'),
            )).toList(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _order.status == 'CONFIRMED'
                  ? () => _updateOrderStatus('DELIVERED')
                  : () => _updateOrderStatus('CONFIRMED'),
              child: Text(_order.status == 'CONFIRMED' ? 'Deliver' : 'Confirm'),
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}