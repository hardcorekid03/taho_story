import 'package:flutter/material.dart';
import 'order_form_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Taho Story')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OrderFormScreen()),
            );
          },
          child: Text('Place Taho Order'),
        ),
      ),
    );
  }
}
