import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderForm extends StatefulWidget {
  const OrderForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OrderFormState createState() => _OrderFormState();
}

class _OrderFormState extends State<OrderForm> {
  // Controllers
  final TextEditingController orderNumberController = TextEditingController();
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  // Form Values
  String selectedPayment = 'Cash';
  String selectedMainFlavor = 'Classic';
  String selectedSize = 'Small';
  String selectedAdditionalFlavor = 'None';

  double discount = 0.0;
  double netPrice = 0.0;

  DateTime selectedDate = DateTime.now();

  final List<String> flavors = ['Classic', 'Ube', 'Mango'];
  final List<String> sizes = ['Small', 'Medium', 'Large'];
  final List<String> additionalFlavors = [
    'None',
    'Ube Syrup',
    'Chocolate',
    'Strawberry',
  ];

  void calculatePrices() {
    double price = double.tryParse(priceController.text) ?? 0;
    discount = price * 0.20;
    netPrice = price - discount;
  }

  Future<void> saveOrder() async {
    final prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> orderData = {
      'date': selectedDate.toIso8601String(),
      'payment': selectedPayment,
      'orderNumber': orderNumberController.text,
      'customerName': customerNameController.text,
      'mainFlavor': selectedMainFlavor,
      'size': selectedSize,
      'additionalFlavor': selectedAdditionalFlavor,
      'price': double.tryParse(priceController.text) ?? 0,
      'discount': discount,
      'netPrice': netPrice,
    };

    final String? existingOrders = prefs.getString('taho_orders');
    List<Map<String, dynamic>> orderList = [];

    if (existingOrders != null) {
      orderList = List<Map<String, dynamic>>.from(jsonDecode(existingOrders));
    }

    orderList.add(orderData);
    await prefs.setString('taho_orders', jsonEncode(orderList));
  }

  @override
  Widget build(BuildContext context) {
    calculatePrices();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Date: ${DateFormat.yMd().format(selectedDate)}"),
          const SizedBox(height: 10),

          Text("Payment Method:"),
          Row(
            children: [
              Radio(
                value: 'Cash',
                groupValue: selectedPayment,
                onChanged: (value) {
                  setState(() => selectedPayment = value.toString());
                },
              ),
              Text('Cash'),
              Radio(
                value: 'GCash',
                groupValue: selectedPayment,
                onChanged: (value) {
                  setState(() => selectedPayment = value.toString());
                },
              ),
              Text('GCash'),
            ],
          ),

          TextField(
            controller: orderNumberController,
            decoration: InputDecoration(labelText: 'Order Number'),
          ),

          TextField(
            controller: customerNameController,
            decoration: InputDecoration(labelText: 'Customer Name'),
          ),

          const SizedBox(height: 20),
          Text(
            "Product Details",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          DropdownButtonFormField(
            value: selectedMainFlavor,
            decoration: InputDecoration(labelText: "Main Flavor"),
            items: flavors
                .map(
                  (flavor) =>
                      DropdownMenuItem(value: flavor, child: Text(flavor)),
                )
                .toList(),
            onChanged: (value) {
              setState(() => selectedMainFlavor = value.toString());
            },
          ),

          DropdownButtonFormField(
            value: selectedSize,
            decoration: InputDecoration(labelText: "Size"),
            items: sizes
                .map((size) => DropdownMenuItem(value: size, child: Text(size)))
                .toList(),
            onChanged: (value) {
              setState(() => selectedSize = value.toString());
            },
          ),

          DropdownButtonFormField(
            value: selectedAdditionalFlavor,
            decoration: InputDecoration(labelText: "Additional Flavor"),
            items: additionalFlavors
                .map(
                  (flavor) =>
                      DropdownMenuItem(value: flavor, child: Text(flavor)),
                )
                .toList(),
            onChanged: (value) {
              setState(() => selectedAdditionalFlavor = value.toString());
            },
          ),

          const SizedBox(height: 20),
          Text("Pricing", style: TextStyle(fontWeight: FontWeight.bold)),

          TextField(
            controller: priceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "Price (₱)"),
            onChanged: (value) {
              setState(() {
                calculatePrices();
              });
            },
          ),

          const SizedBox(height: 10),

          Text("SC/PWD Discount (20%): ₱${discount.toStringAsFixed(2)}"),
          Text("Net Price: ₱${netPrice.toStringAsFixed(2)}"),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                if (orderNumberController.text.isEmpty ||
                    customerNameController.text.isEmpty ||
                    priceController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please fill out all fields.")),
                  );
                  return;
                }

                await saveOrder();

                showDialog(
                  // ignore: use_build_context_synchronously
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Order Submitted"),
                    content: Text("Thank you, ${customerNameController.text}!"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("OK"),
                      ),
                    ],
                  ),
                );

                // Clear fields
                setState(() {
                  orderNumberController.clear();
                  customerNameController.clear();
                  priceController.clear();
                  selectedMainFlavor = 'Classic';
                  selectedSize = 'Small';
                  selectedAdditionalFlavor = 'None';
                  selectedPayment = 'Cash';
                });
              },
              child: Text("PLACE TAHO ORDER"),
            ),
          ),
        ],
      ),
    );
  }
}
