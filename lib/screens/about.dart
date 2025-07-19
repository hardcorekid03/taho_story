import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Image banner at the top
          SizedBox(
            width: double.infinity,
            height: 200,
            child: Image.asset(
              'assets/images/taho_banner.jpg', // 👈 Replace with your actual image path
              fit: BoxFit.cover,
            ),
          ),

          // App bar-like header (since AppBar is hidden under image)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
            child: Row(
              children: const [
                Icon(Icons.info_outline, color: Color(0xFFFF8C42)),
                SizedBox(width: 8),
                Text(
                  'About Us',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF8C42),
                  ),
                ),
              ],
            ),
          ),

          // About content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Taho Story - A Sweet Journey',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF8C42),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Founded by friends with a playful name suggestion from a child—'
                    '“Taho Story”—this dessert startup launched its first store on April 29, 2024, '
                    'at the University of the Philippines Diliman2 campus.\n\n'
                    'They began with a bold idea: blending traditional tahô with ice cream and chilled flavors, '
                    'introducing varieties like Ube de Leche, Avocado Loco, Mangga Graham, and more.\n\n'
                    'As demand surged, they rapidly expanded—entering franchising after just one month and growing '
                    'from 33 branches early in 2025 to aiming for 200–250 nationwide by year-end.\n\n'
                    'Through colorful flavors, smart branding, and the tagline “Bakit Hindi?”, Taho Story has reimagined '
                    'a nostalgic Filipino favorite into a modern treat that brings people together over sweet, creamy cups.',
                    style: TextStyle(
                        fontSize: 14, color: Colors.black87, height: 1.5),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Version: 1.0.0',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Developer: Anthony F. Tolentino',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: Text(
                      '© 2025 Taho Story. All rights reserved.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
