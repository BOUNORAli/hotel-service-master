import 'package:flutter/material.dart';

class CreditCardPage extends StatelessWidget {
  const CreditCardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Credit Card'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'This is the Credit Card Page.',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
