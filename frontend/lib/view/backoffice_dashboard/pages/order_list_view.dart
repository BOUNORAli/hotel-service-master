import 'package:flutter/material.dart';
import 'package:food_order_ui/configuration/order.dart' as order_conf;
import 'package:food_order_ui/configuration/order.dart';
import 'package:food_order_ui/services/order_service.dart';
import 'package:food_order_ui/utils/shared_preferences.dart';

class OrderListView extends StatefulWidget {
  final SharedPrefsUtil sharedPrefsUtil;
  const OrderListView({Key? key, required this.sharedPrefsUtil}) : super(key: key);

  @override
  _OrderListViewState createState() => _OrderListViewState();
}

class _OrderListViewState extends State<OrderListView> {
  List<order_conf.Order> _orders = [];
  bool _isLoading = true;
  String? _statusFilter;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    widget.sharedPrefsUtil.initPrefs().then((_) {
      _initialize();
    });
  }

  Future<void> _initialize() async {
    await _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String token = await widget.sharedPrefsUtil.getToken();
      var fetchedOrders = await OrderService.getOrders(token, status: _statusFilter == 'All' ? null : _statusFilter);
      setState(() {
        _orders = fetchedOrders;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void filterOrders(String status) async {
    try {
      String token = await SharedPrefsUtil().getToken();
      print('Retrieved Token: $token');
      List<Order> orders = await OrderService.getOrders(token, status: status);
      setState(() {
        _orders = orders;
      });
    } catch (e) {
      print("Failed to filter orders: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Order List'),
        ),
        body: Center(
          child: Text('Error: $_errorMessage'),
        ),
      );
    }

    if (_orders.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Order List'),
        ),
        body: const Center(
          child: Text('No orders found'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order List'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String result) {
              filterOrders(result);
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'All',
                child: Text('All'),
              ),
              const PopupMenuItem<String>(
                value: 'Pending',
                child: Text('Pending'),
              ),
              const PopupMenuItem<String>(
                value: 'Confirmed',
                child: Text('Confirmed'),
              ),
              const PopupMenuItem<String>(
                value: 'Delivered',
                child: Text('Delivered'),
              ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _orders.length,
        itemBuilder: (context, index) {
          var order = _orders[index];

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: _getOrderIcon(order.status),
                title: Text(
                  order.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  'Total: ${order.totalPrice} \$\nStatus: ${order.status}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/order_detail',
                    arguments: order,
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Icon _getOrderIcon(String status) {
    switch (status) {
      case 'Pending':
        return const Icon(Icons.hourglass_empty, color: Colors.orange);
      case 'Confirmed':
        return const Icon(Icons.check_circle, color: Colors.blue);
      case 'Delivered':
        return const Icon(Icons.delivery_dining, color: Colors.green);
      default:
        return const Icon(Icons.help_outline, color: Colors.grey);
    }
  }
}
