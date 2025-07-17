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
    },
    {
      'name': 'BANANANUT',
      'price': 121,
      'image': '/assets/images/banananut.jpg',
    },
    {
      'name': 'UBE DE LECHE',
      'price': 122,
      'image': '/assets/images/ube_de_leche.jpg',
      'badge': 'Popular',
    },
    {
      'name': 'LA PRESAS',
      'price': 123,
      'image': '/assets/images/la_presas.jpg',
    },
    {
      'name': 'OREOHOLIC',
      'price': 124,
      'image': '/assets/images/oreoholic.jpg',
      'badge': 'Bestseller',
    },
    {
      'name': 'PRUTAS OVERLOAD',
      'price': 125,
      'image': '/assets/images/prutas_overload.jpg',
    },
    {
      'name': 'AVOCADO LOCO',
      'price': 126,
      'image': '/assets/images/avocado_loco_2.jpg',
    },
    {
      'name': 'MANGGA GRAHAM',
      'price': 127,
      'image': '/assets/images/mangga_graham.jpg',
      'badge': 'New',
    },
    {
      'name': 'COFFEE GELMOND',
      'price': 128,
      'image': '/assets/images/coffee_gelmond.jpg',
    },
    {
      'name': 'DIRTY MATCHARLIE',
      'price': 129,
      'image': '/assets/images/dirty_matcharlie.jpg',
    },
    {
      'name': 'SALTED CARAMEL',
      'price': 130,
      'image': '/assets/images/salted_caramel.jpg',
    },
    {
      'name': 'ESTRAWBERRY COFFEE',
      'price': 131,
      'image': '/assets/images/estraberry_coffee.jpg',
    },
    {
      'name': 'SPICED MICO LATTE',
      'price': 132,
      'image': '/assets/images/spice_mico_latte.jpg',
    },
    {
      'name': 'SALTED BANOFFEE JOSH',
      'price': 133,
      'image': '/assets/images/salted_banoffee_josh.jpg',
    },
    {
      'name': "PAU'S BISCOFF",
      'price': 134,
      'image': '/assets/images/paus_biscoff.jpg',
      'badge': 'Premium',
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
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8F0),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFFF8C42).withAlpha((0.2 * 255).toInt()),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Available Sizes',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF8B4513),
                        ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: ['MC-B1T1', 'MM', 'M'].map((size) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF8C42)
                              .withAlpha((0.1 * 255).toInt()),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFFFF8C42)
                                .withAlpha((0.3 * 255).toInt()),
                          ),
                        ),
                        child: Text(
                          size,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFFF8C42),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'MC-B1T1: Buy 1 Take 1 • MM: Medium • M: Small',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
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
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          flavor['name'],
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8B4513),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '₱${flavor['price']}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFF8C42),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF8C42)
                                    .withAlpha((0.1 * 255).toInt()),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.add,
                                size: 16,
                                color: Color(0xFFFF8C42),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
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
