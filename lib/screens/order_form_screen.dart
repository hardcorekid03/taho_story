import 'package:flutter/material.dart';
import '../../widgets/order_form.dart';

class OrderFormScreen extends StatelessWidget {
  const OrderFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Taho Order Form')),
      body: SingleChildScrollView(child: OrderForm()),
    );
  }
}
