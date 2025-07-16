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
              Navigator.pop(context);
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
      appBar: AppBar(title: const Text('Saved Taho Orders')),
      body: orders.isEmpty
          ? const Center(child: Text("No orders found."))
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(
                      "Order #${order['orderNumber']} - ₱${order['netPrice']}",
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Customer: ${order['customerName']}"),
                        Text("Date: ${formatDate(order['date'])}"),
                        Text(
                          "Flavor: ${order['mainFlavor']} | Size: ${order['size']}",
                        ),
                        Text("Payment: ${order['payment']}"),
                        if (order['payment'] == 'GCash' &&
                            order['gcashRef'] != null)
                          Text("GCash Ref: ${order['gcashRef']}"),
                      ],
                    ),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Scaffold(
                                  appBar: AppBar(
                                    title: const Text("Edit Order"),
                                  ),
                                  body: OrderForm(
                                    existingOrder: order,
                                    index: index,
                                  ),
                                ),
                              ),
                            ).then((_) => loadOrders()); // refresh when back
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => confirmDelete(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
