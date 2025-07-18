import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/data/menu_items.dart';
import '../widgets/dialogs/gcash_dialog.dart';

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
  bool applyDiscount = false;

  double discount = 0.0;
  double netPrice = 0.0;
  DateTime selectedDate = DateTime.now();

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
      applyDiscount = order['applyDiscount'] ?? false;
    } else {
      autoGenerateOrderNumber();
    }
  }

  void calculatePrices() {
    double price = double.tryParse(priceController.text) ?? 0;
    discount = applyDiscount ? price * 0.20 : 0.0;
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
      'applyDiscount': applyDiscount,
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

  @override
  Widget build(BuildContext context) {
    calculatePrices();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, color: Color(0xFFFF8C42)),
                  const SizedBox(width: 12),
                  Text(
                    "Date: ${DateFormat.yMd().format(selectedDate)}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Payment Method
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Payment Method",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile(
                          value: 'Cash',
                          groupValue: selectedPayment,
                          onChanged: (value) {
                            setState(() => selectedPayment = value.toString());
                          },
                          title: const Text('Cash'),
                          activeColor: const Color(0xFFFF8C42),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      Expanded(
                        child: RadioListTile(
                          value: 'GCash',
                          groupValue: selectedPayment,
                          onChanged: (value) {
                            setState(() {
                              selectedPayment = value.toString();
                              showGCashDialog(
                                  context: context,
                                  controller: gcashRefController);
                            });
                          },
                          title: const Text('GCash'),
                          activeColor: const Color(0xFFFF8C42),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Order Details
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Order Details",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: orderNumberController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Order Number',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.receipt),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: customerNameController,
                    inputFormatters: [
                      UpperCaseTextFormatter(),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Customer Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                      isDense: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Product Details
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Product Details",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField(
                    value: selectedMainFlavor,
                    decoration: const InputDecoration(
                      labelText: "Main Flavor",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.local_drink),
                      isDense: true,
                    ),
                    items: flavors.map((flavor) {
                      final name = flavor['name'] as String;
                      return DropdownMenuItem(
                        value: name,
                        child: Text(name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => selectedMainFlavor = value.toString());
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField(
                    value: selectedSize,
                    decoration: const InputDecoration(
                      labelText: "Size",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.straighten),
                      isDense: true,
                    ),
                    items: sizes.map((size) {
                      return DropdownMenuItem(value: size, child: Text(size));
                    }).toList(),
                    onChanged: (value) {
                      setState(() => selectedSize = value.toString());
                    },
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text("Buy 1 Take 1"),
                    value: isBuyOneTakeOne,
                    onChanged: (value) {
                      setState(() {
                        isBuyOneTakeOne = value;
                      });
                    },
                    activeColor: const Color(0xFFFF8C42),
                    contentPadding: EdgeInsets.zero,
                  ),
                  if (isBuyOneTakeOne) ...[
                    const SizedBox(height: 16),
                    DropdownButtonFormField(
                      value: selectedTakeOneFlavor,
                      decoration: const InputDecoration(
                        labelText: "Take 1 Flavor",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.add_circle),
                        isDense: true,
                      ),
                      items: flavors.map((flavor) {
                        final name = flavor['name'] as String;
                        return DropdownMenuItem(
                          value: name,
                          child: Text(name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(
                            () => selectedTakeOneFlavor = value.toString());
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Pricing
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Pricing",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: priceController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    decoration: const InputDecoration(
                      labelText: "Price (₱)",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.attach_money),
                      isDense: true,
                    ),
                    onChanged: (value) {
                      setState(() {
                        calculatePrices();
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  CheckboxListTile(
                    title: const Text("Apply SC/PWD Discount (20%)"),
                    subtitle: const Text(
                        "For Senior Citizens & Persons with Disabilities"),
                    value: applyDiscount,
                    onChanged: (value) {
                      setState(() {
                        applyDiscount = value ?? false;
                        calculatePrices();
                      });
                    },
                    activeColor: const Color(0xFFFF8C42),
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8F0),
                      borderRadius: BorderRadius.circular(8),
                      // ignore: deprecated_member_use
                      border: Border.all(
                          // ignore: deprecated_member_use
                          color: const Color(0xFFFF8C42).withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Original Price:"),
                            Text(
                                "₱${(double.tryParse(priceController.text) ?? 0).toStringAsFixed(2)}"),
                          ],
                        ),
                        if (applyDiscount) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("SC/PWD Discount (20%):"),
                              Text("-₱${discount.toStringAsFixed(2)}",
                                  style: const TextStyle(color: Colors.green)),
                            ],
                          ),
                        ],
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Net Price:",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              "₱${netPrice.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFF8C42),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Submit Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () async {
                if (orderNumberController.text.isEmpty ||
                    customerNameController.text.isEmpty ||
                    priceController.text.isEmpty ||
                    (selectedPayment == 'GCash' &&
                        gcashRefController.text.isEmpty)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          const Text("Please complete all required fields."),
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                  return;
                }

                await saveOrder();

                if (mounted) {
                  showDialog(
                    // ignore: use_build_context_synchronously
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: const Text("Order Saved"),
                      content: Text(
                        "Order #${orderNumberController.text} has been saved successfully!",
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: const Text("OK"),
                        ),
                      ],
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF8C42),
                foregroundColor: Colors.white,
                elevation: 8,
                // ignore: deprecated_member_use
                shadowColor: const Color(0xFFFF8C42).withOpacity(0.4),
              ),
              child: Text(
                widget.existingOrder != null
                    ? "UPDATE ORDER"
                    : "PLACE TAHO ORDER",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32), // Extra bottom padding for safe area
        ],
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
