import 'package:flutter/material.dart';
import 'order_form_screen.dart';
import 'menu_screen.dart';
import './data/menu_items.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/banner.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Action Buttons Row
                          Row(
                            children: [
                              Expanded(
                                child: _buildActionButton(
                                  context,
                                  'Place Order',
                                  Icons.add_shopping_cart,
                                  const Color(0xFFFF8C42),
                                  () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const OrderFormScreen(),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildOutlineButton(
                                  context,
                                  'View Menu',
                                  Icons.restaurant_menu,
                                  const Color(0xFFFF8C42),
                                  () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const MenuScreen(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Popular Menu
                          const Text(
                            "Popular Menu",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFF8C42),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 220,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 4,
                              itemBuilder: (context, index) {
                                final item = flavors[index];
                                return _buildMenuItemCard(context, item);
                              },
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Promo Card
                          _buildPromoCard(
                            context,
                            'Free Delivery!',
                            'For orders above ₱200.',
                            'assets/images/delivery.png',
                            const Color(0xFFE8F5E9),
                            const Color(0xFFFF8C42),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String text,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      height: 56,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 24),
        label: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          side: BorderSide(color: color, width: 2),
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 8,
          // ignore: deprecated_member_use
          shadowColor: color.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildOutlineButton(
    BuildContext context,
    String text,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      height: 56,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 24, color: color),
        label: Text(
          text,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: color),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color, width: 2),
          foregroundColor: color,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItemCard(BuildContext context, Map<String, dynamic> item) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                item['image'],
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₱${item['price']}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFFFF8C42),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (item['description'] != null)
                    Text(
                      item['description'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
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

  Widget _buildPromoCard(
    BuildContext context,
    String title,
    String description,
    String imageUrl,
    Color backgroundColor,
    Color accentColor,
  ) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                // ignore: deprecated_member_use
                color: accentColor.withOpacity(0.2),
                image: DecorationImage(
                  image: AssetImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: accentColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: accentColor, size: 18),
          ],
        ),
      ),
    );
  }
}
