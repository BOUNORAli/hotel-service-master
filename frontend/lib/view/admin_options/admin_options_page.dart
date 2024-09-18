import 'package:flutter/material.dart';

class AdminOptionsPage extends StatelessWidget {
  const AdminOptionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Options"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildOptionButton(
              context,
              icon: Icons.dashboard,
              label: "Go to Dashboard",
              route: '/dashboard',
            ),
            const SizedBox(height: 20),
            _buildOptionButton(
              context,
              icon: Icons.home,
              label: "Go to Home Page",
              route: '/home',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(BuildContext context, {required IconData icon, required String label, required String route}) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
      icon: Icon(icon, size: 24),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(fontSize: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
