import 'package:flutter/material.dart';
import 'package:food_order_ui/view/backoffice_dashboard/components/side_menu.dart';
import 'package:food_order_ui/view/backoffice_dashboard/pages/overview_page.dart';

class BackOfficeDashboard extends StatefulWidget {
  const BackOfficeDashboard({Key? key}) : super(key: key);

  @override
  _BackOfficeDashboardState createState() => _BackOfficeDashboardState();
}

class _BackOfficeDashboardState extends State<BackOfficeDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Back Office Dashboard'),
        backgroundColor: Colors.orange,
      ),
      drawer: const SideMenu(),
      body: const OverviewPage(),
    );
  }
}
