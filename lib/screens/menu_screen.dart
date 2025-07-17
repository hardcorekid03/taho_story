import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  final List<Map<String, dynamic>> flavors = const [
    {
      'name': 'KLASIKONG TAHO',
      'price': 110,
      'image': '/assets/images/klasikong_taho.jpg',
      'isClassic': true,
      'description': 'Traditional warm taho with fresh arnibal and sago.'
    },
    {
      'name': 'BANANANUT',
      'price': 121,
      'image': '/assets/images/banananut.jpg',
      'description': 'A nutty banana twist on the classic taho.'
    },
    {
      'name': 'UBE DE LECHE',
      'price': 122,
      'image': '/assets/images/ube_de_leche.jpg',
      'badge': 'Popular',
      'description': 'Creamy ube flavor with a rich leche drizzle.'
    },
    {
      'name': 'LA PRESAS',
      'price': 123,
      'image': '/assets/images/la_presas.jpg',
      'description': 'Sweet and tangy strawberry-infused taho.'
    },
    {
      'name': 'OREOHOLIC',
      'price': 124,
      'image': '/assets/images/oreoholic.jpg',
      'badge': 'Bestseller',
      'description': 'Crunchy Oreo bits on silky taho base.'
    },
    {
      'name': 'PRUTAS OVERLOAD',
      'price': 125,
      'image': '/assets/images/prutas_overload.jpg',
      'description': 'Topped with a mix of fresh seasonal fruits.'
    },
    {
      'name': 'AVOCADO LOCO',
      'price': 126,
      'image': '/assets/images/avocado_loco_2.jpg',
      'description': 'Luscious avocado cream meets taho goodness.'
    },
    {
      'name': 'MANGGA GRAHAM',
      'price': 127,
      'image': '/assets/images/mangga_graham.jpg',
      'badge': 'New',
      'description': 'Mango and graham combo with a taho twist.'
    },
    {
      'name': 'COFFEE GELMOND',
      'price': 128,
      'image': '/assets/images/coffee_gelmond.jpg',
      'description': 'Coffee taho layered with almond jelly.'
    },
    {
      'name': 'DIRTY MATCHARLIE',
      'price': 129,
      'image': '/assets/images/dirty_matcharlie.jpg',
      'description': 'Bold matcha mixed with chocolatey taho.'
    },
    {
      'name': 'SALTED CARAMEL',
      'price': 130,
      'image': '/assets/images/salted_caramel.jpg',
      'description': 'Sweet and salty caramel blend on warm taho.'
    },
    {
      'name': 'ESTRAWBERRY COFFEE',
      'price': 131,
      'image': '/assets/images/estraberry_coffee.jpg',
      'description': 'A unique fusion of strawberry and coffee flavors.'
    },
    {
      'name': 'SPICED MICO LATTE',
      'price': 132,
      'image': '/assets/images/spice_mico_latte.jpg',
      'description': 'Taho infused with aromatic spiced latte blend.'
    },
    {
      'name': 'SALTED BANOFFEE JOSH',
      'price': 133,
      'image': '/assets/images/salted_banoffee_josh.jpg',
      'description': 'Banana, toffee, and a hint of salt in creamy taho.'
    },
    {
      'name': "PAU'S BISCOFF",
      'price': 134,
      'image': '/assets/images/paus_biscoff.jpg',
      'badge': 'Premium',
      'description': 'Premium Biscoff spread layered on smooth taho.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Menu',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFFFF8C42),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF8C42), Color(0xFFFFB366)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Taho Flavors',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Choose from our delicious selection',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withAlpha((0.9 * 255).toInt()),
                        ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final flavor = flavors[index];
                  return AnimationConfiguration.staggeredGrid(
                    position: index,
                    columnCount: 2,
                    duration: const Duration(milliseconds: 300),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: _buildFlavorCard(context, flavor),
                      ),
                    ),
                  );
                },
                childCount: flavors.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlavorCard(BuildContext context, Map<String, dynamic> flavor) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: Card(
          elevation: 6,
          shadowColor: const Color(0xFFFF8C42).withAlpha((0.2 * 255).toInt()),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Color(0xFFFFF8F0)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          image: DecorationImage(
                            image: NetworkImage(flavor['image']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      if (flavor['badge'] != null)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getBadgeColor(flavor['badge']),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              flavor['badge'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  flavor['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '₱${flavor['price']}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFFFF8C42),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                if (flavor['description'] != null)
                  Text(
                    flavor['description'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                  ),
                const SizedBox(height: 4),
                Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(right: 6),
                      child: _SizeBadge(label: 'MC-B1T1'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 6),
                      child: _SizeBadge(label: 'MM'),
                    ),
                    _SizeBadge(label: 'M'),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getBadgeColor(String badge) {
    switch (badge.toLowerCase()) {
      case 'popular':
        return Colors.orange;
      case 'b1t1':
        return Colors.green;
      case 'bestseller':
        return Colors.red;
      case 'new':
        return Colors.blue;
      case 'premium':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}

class _SizeBadge extends StatelessWidget {
  final String label;

  const _SizeBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFFFF8C42)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.bold,
          color: Color(0xFFFF8C42),
        ),
      ),
    );
  }
}
