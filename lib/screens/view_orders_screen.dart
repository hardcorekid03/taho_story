import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/order_form.dart';

class ViewOrdersScreen extends StatefulWidget {
  const ViewOrdersScreen({super.key});

  @override
  State<ViewOrdersScreen> createState() => _ViewOrdersScreenState();
}

class _ViewOrdersScreenState extends State<ViewOrdersScreen> {
  List<Map<String, dynamic>> orders = [];

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  Future<void> loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final String? ordersString = prefs.getString('taho_orders');

    if (ordersString != null) {
      setState(() {
        orders = List<Map<String, dynamic>>.from(jsonDecode(ordersString));
      });
    }
  }

  String formatDate(String isoString) {
    final date = DateTime.tryParse(isoString);
    if (date == null) return 'Invalid Date';
    return DateFormat.yMd().format(date);
  }

  void confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Delete Order"),
        content: const Text("Are you sure you want to delete this order?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              final ordersString = prefs.getString('taho_orders');

              if (ordersString != null) {
                final orderList = List<Map<String, dynamic>>.from(
                  jsonDecode(ordersString),
                );
                orderList.removeAt(index);
                await prefs.setString('taho_orders', jsonEncode(orderList));
                setState(() => orders = orderList);
              }

              // ignore: use_build_context_synchronously
              if (mounted) Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order History',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFFFF8C42),
      ),
      body: orders.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 80,
                    color: Color(0xFFFF8C42),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No orders found',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Order #${order['orderNumber']}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFF8C42),
                                ),
                              ),
                              Text(
                                "₱${order['netPrice'].toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Customer: ${order['customerName']}",
                            style: const TextStyle(fontSize: 14),
                          ),
                          Text(
                            "Date: ${formatDate(order['date'])}",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            "Flavor: ${order['mainFlavor']} | Size: ${order['size']}",
                            style: const TextStyle(fontSize: 14),
                          ),
                          Text(
                            "Payment: ${order['payment']}",
                            style: const TextStyle(fontSize: 14),
                          ),
                          if (order['payment'] == 'GCash' &&
                              order['gcashRef'] != null)
                            Text(
                              "GCash Ref: ${order['gcashRef']}",
                              style: const TextStyle(fontSize: 14),
                            ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Color(0xFFFF8C42),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Scaffold(
                                        appBar: AppBar(
                                          title: const Text("Edit Order"),
                                          backgroundColor: Colors.transparent,
                                          elevation: 0,
                                          foregroundColor: const Color(
                                            0xFFFF8C42,
                                          ),
                                        ),
                                        body: OrderForm(
                                          existingOrder: order,
                                          index: index,
                                        ),
                                      ),
                                    ),
                                  ).then((_) => loadOrders());
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => confirmDelete(index),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
