import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
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

  final double basePrice = 110;

  MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Menu')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🖼️ Header Image
            Image.asset(
              'assets/images/taho_banner.jpg',
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover,
            ),

            const SizedBox(height: 16),

            // 🧋 Flavors List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Flavors',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  ...flavors.map((flavor) {
                    double price = basePrice;
                    if (flavor != 'KLASIKONG TAHO') {
                      price += 10 + flavors.indexOf(flavor);
                    }
                    return ListTile(
                      title: Text(flavor),
                      trailing: Text('₱${price.toStringAsFixed(0)}'),
                    );
                  }),

                  const Divider(height: 32),

                  // 📏 Sizes
                  Text('Sizes', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: sizes.map((s) => Chip(label: Text(s))).toList(),
                  ),

                  const Divider(height: 32),

                  // 🧋 Take-1 Flavors
                  Text(
                    'Take 1 Flavors (for B1T1 promos)',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  ...flavors.map(
                    (flavor) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Text('• $flavor'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
