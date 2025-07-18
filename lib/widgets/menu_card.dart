import 'package:flutter/material.dart';

class MenuCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const MenuCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Menu image
            ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset('assets/images/klasikong_taho.jpg')),
            const SizedBox(width: 12),
            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + Classic Badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item['name'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (item['isClassic'] == true)
                        const Text(
                          'Classic',
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Description
                  if (item['description'] != null)
                    Text(
                      item['description'],
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                  const SizedBox(height: 8),

                  // Sizes badge
                  if (item['sizes'] != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFFF8C42)),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        item['sizes'],
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFFFF8C42),
                        ),
                      ),
                    ),

                  const SizedBox(height: 8),

                  // Price
                  Text(
                    '₱${item['price']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
