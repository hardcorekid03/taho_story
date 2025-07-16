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
  final TextEditingController orderNumberController = TextEditingController();
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController gcashRefController = TextEditingController();

  String selectedPayment = 'Cash';
  String selectedMainFlavor = 'KLASIKONG TAHO';
  String selectedSize = 'MC-B1T1';
  String selectedTakeOneFlavor = 'KLASIKONG TAHO';
  bool isBuyOneTakeOne = false;

  double discount = 0.0;
  double netPrice = 0.0;
  DateTime selectedDate = DateTime.now();

  final List<String> flavors = [
    'KLASIKONG TAHO',
    'BANANANUT',
    'UBE DE LECHE',
    'LA PRESAS',
    'OREOHOLIC',
    'PRUTAS OVERLOAD',
    'AVOCADO LOCO',
    'MANGGA GRAHAM',
    'COFFEE GELMOND',
    'DIRTY MATCHARLIE',
    'SALTED CARAMEL',
    'ESTRAWBERRY COFFEE',
    'SPICED MICO LATTE',
    'SALTED BANOFFEE JOSH',
    "PAU'S BISCOFF",
  ];

  final List<String> sizes = ['MC-B1T1', 'MM', 'M'];

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
      isBuyOneTakeOne = order['isB1T1'] ?? false;
      selectedTakeOneFlavor = order['takeOneFlavor'] ?? flavors[0];
      priceController.text = order['price'].toString();
      gcashRefController.text = order['gcashRef'] ?? '';
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
      'gcashRef': selectedPayment == 'GCash' ? gcashRefController.text : null,
      'orderNumber': orderNumberController.text,
      'customerName': customerNameController.text,
      'mainFlavor': selectedMainFlavor,
      'size': selectedSize,
      'isB1T1': isBuyOneTakeOne,
      'takeOneFlavor': isBuyOneTakeOne ? selectedTakeOneFlavor : null,
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
      orderList[widget.index!] = orderData;
    } else {
      orderList.add(orderData);
    }

    await prefs.setString('taho_orders', jsonEncode(orderList));
  }

  void showGCashDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Enter GCash Reference Number"),
        content: TextField(
          controller: gcashRefController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(hintText: "e.g., 123456789012"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Save"),
          ),
        ],
      ),
    );
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
                    setState(() {
                      selectedPayment = value.toString();
                      showGCashDialog();
                    });
                  },
                ),
                const Text('GCash'),
              ],
            ),

            TextField(
              controller: orderNumberController,
              readOnly: true,
              decoration: const InputDecoration(labelText: 'Order Number'),
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

            SwitchListTile(
              title: const Text("Buy 1 Take 1"),
              value: isBuyOneTakeOne,
              onChanged: (value) {
                setState(() {
                  isBuyOneTakeOne = value;
                });
              },
            ),

            if (isBuyOneTakeOne)
              DropdownButtonFormField(
                value: selectedTakeOneFlavor,
                decoration: const InputDecoration(labelText: "Take 1 Flavor"),
                items: flavors.map((flavor) {
                  return DropdownMenuItem(value: flavor, child: Text(flavor));
                }).toList(),
                onChanged: (value) {
                  setState(() => selectedTakeOneFlavor = value.toString());
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
                      priceController.text.isEmpty ||
                      (selectedPayment == 'GCash' &&
                          gcashRefController.text.isEmpty)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please complete all required fields."),
                      ),
                    );
                    return;
                  }

                  await saveOrder();

                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Order Saved"),
                      content: Text(
                        "Order #${orderNumberController.text} has been saved.",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
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
