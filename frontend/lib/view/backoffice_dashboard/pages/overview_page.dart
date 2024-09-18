import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:food_order_ui/services/food_api.dart';
import 'package:food_order_ui/services/order_service.dart';
import 'package:food_order_ui/services/client_api.dart';
import 'package:food_order_ui/configuration/food.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({Key? key}) : super(key: key);

  @override
  _OverviewPageState createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  List<Food> mostFavoritedFoods = [];
  List<Food> mostPurchasedFoods = [];
  int totalUsers = 0;
  List<OrderChartData> orderChartData = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      List<Food> favoritedFoods = await FoodApi.getMostFavoritedFoods();
      print("Most Favorited Foods: $favoritedFoods");

      List<Food> purchasedFoods = await OrderService.getMostPurchasedFoods();
      print("Most Purchased Foods: $purchasedFoods");

      int usersCount = await ClientApi.getTotalUsers();
      print("Total Users: $usersCount");

      List<OrderChartData> orders = await OrderService.getOrdersOverTime();
      print("Orders Over Time: $orders");

      setState(() {
        mostFavoritedFoods = favoritedFoods;
        mostPurchasedFoods = purchasedFoods;
        totalUsers = usersCount;
        orderChartData = orders;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          const Text(
            'Dashboard Statistics',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildStatCard('Most Favorited Foods', _buildMostFavoritedFoods()),
          const SizedBox(height: 20),
          _buildStatCard('Most Purchased Foods', _buildMostPurchasedFoods()),
          const SizedBox(height: 20),
          _buildStatCard('Orders Over Time', _buildOrderChart()),
          const SizedBox(height: 20),
          _buildStatCard('Total Users', _buildTotalUsers()),
        ],
      ),
    );
  }

  // statistics
  Widget _buildStatCard(String title, Widget content) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            content,
          ],
        ),
      ),
    );
  }

  // most favorited foods
  Widget _buildMostFavoritedFoods() {
    return Column(
      children: mostFavoritedFoods
          .map((food) => ListTile(title: Text(food.name)))
          .toList(),
    );
  }

  // most purchased foods
  Widget _buildMostPurchasedFoods() {
    return Column(
      children: mostPurchasedFoods
          .map((food) => ListTile(title: Text(food.name)))
          .toList(),
    );
  }

  // orders over time
  Widget _buildOrderChart() {
    return SizedBox(
      height: 300,
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        title: ChartTitle(text: 'Orders Over Time'),
        series: <LineSeries<OrderChartData, String>>[
          LineSeries<OrderChartData, String>(
            dataSource: orderChartData,
            xValueMapper: (OrderChartData data, _) => data.date,
            yValueMapper: (OrderChartData data, _) => data.orderCount,
          )
        ],
      ),
    );
  }

  Widget _buildTotalUsers() {
    return Text(
      '$totalUsers users',
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}
