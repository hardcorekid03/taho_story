import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class OrderForm extends StatefulWidget {
  final Map<String, dynamic>? existingOrder;
  final int? index;

  const OrderForm({this.existingOrder, this.index, super.key});

  @override
  State<OrderForm> createState() => _OrderFormState();
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

  @override
  void initState() {
    super.initState();

    if (widget.existingOrder != null) {
      final order = widget.existingOrder!;
      selectedDate = DateTime.parse(order['date']);
      selectedPayment = order['payment'];
      orderNumberController.text = order['orderNumber'];
      customerNameController.text = order['customerName'];
      selectedMainFlavor = order['mainFlavor'];
      selectedSize = order['size'];
      selectedAdditionalFlavor = order['additionalFlavor'];
      priceController.text = order['price'].toString();
    } else {
      autoGenerateOrderNumber();
    }
  }

  void calculatePrices() {
    double price = double.tryParse(priceController.text) ?? 0;
    discount = price * 0.20;
    netPrice = price - discount;
  }

  Future<void> autoGenerateOrderNumber() async {
    final prefs = await SharedPreferences.getInstance();
    final ordersString = prefs.getString('taho_orders');

    if (ordersString != null) {
      final orders = List<Map<String, dynamic>>.from(jsonDecode(ordersString));
      final lastOrder = orders.isNotEmpty ? orders.last : null;
      int lastNumber = 0;
      if (lastOrder != null) {
        lastNumber = int.tryParse(lastOrder['orderNumber']) ?? 0;
      }
      orderNumberController.text = (lastNumber + 1).toString().padLeft(4, '0');
    } else {
      orderNumberController.text = '0001';
    }
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

    if (widget.index != null) {
      // Editing existing
      orderList[widget.index!] = orderData;
    } else {
      // New order
      orderList.add(orderData);
    }

    await prefs.setString('taho_orders', jsonEncode(orderList));
  }

  @override
  Widget build(BuildContext context) {
    calculatePrices();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
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
                const Text('Cash'),
                Radio(
                  value: 'GCash',
                  groupValue: selectedPayment,
                  onChanged: (value) {
                    setState(() => selectedPayment = value.toString());
                  },
                ),
                const Text('GCash'),
              ],
            ),

            TextField(
              controller: orderNumberController,
              decoration: const InputDecoration(labelText: 'Order Number'),
              readOnly: true,
            ),

            TextField(
              controller: customerNameController,
              decoration: const InputDecoration(labelText: 'Customer Name'),
            ),

            const SizedBox(height: 20),
            const Text(
              "Product Details",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            DropdownButtonFormField(
              value: selectedMainFlavor,
              decoration: const InputDecoration(labelText: "Main Flavor"),
              items: flavors.map((flavor) {
                return DropdownMenuItem(value: flavor, child: Text(flavor));
              }).toList(),
              onChanged: (value) {
                setState(() => selectedMainFlavor = value.toString());
              },
            ),

            DropdownButtonFormField(
              value: selectedSize,
              decoration: const InputDecoration(labelText: "Size"),
              items: sizes.map((size) {
                return DropdownMenuItem(value: size, child: Text(size));
              }).toList(),
              onChanged: (value) {
                setState(() => selectedSize = value.toString());
              },
            ),

            DropdownButtonFormField(
              value: selectedAdditionalFlavor,
              decoration: const InputDecoration(labelText: "Additional Flavor"),
              items: additionalFlavors.map((flavor) {
                return DropdownMenuItem(value: flavor, child: Text(flavor));
              }).toList(),
              onChanged: (value) {
                setState(() => selectedAdditionalFlavor = value.toString());
              },
            ),

            const SizedBox(height: 20),
            const Text(
              "Pricing",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            TextField(
              controller: priceController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              decoration: const InputDecoration(labelText: "Price (₱)"),
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
                      const SnackBar(
                        content: Text("Please fill out all fields."),
                      ),
                    );
                    return;
                  }

                  await saveOrder();

                  showDialog(
                    // ignore: use_build_context_synchronously
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Order Saved"),
                      content: Text(
                        widget.existingOrder != null
                            ? "Order #${orderNumberController.text} updated."
                            : "Order placed successfully!",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // close dialog
                            Navigator.pop(context); // go back to view screen
                          },
                          child: const Text("OK"),
                        ),
                      ],
                    ),
                  );
                },
                child: Text(
                  widget.existingOrder != null
                      ? "UPDATE ORDER"
                      : "PLACE TAHO ORDER",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
