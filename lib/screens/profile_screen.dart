import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFFFF8C42),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF8C42), Color(0xFFFFB366)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Color(0xFFFF8C42),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Welcome to Taho Story!',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enjoy our delicious taho flavors',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          // ignore: deprecated_member_use
                          color: Colors.white.withOpacity(0.9),
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Dropdown-style Menu Items
            _buildExpandableMenuItem(
              icon: Icons.favorite_outline,
              title: 'Social Media',
              subtitle: 'Follow us on social media',
              children: const [
                ListTile(
                  leading: Icon(Icons.facebook, color: Color(0xFF1877F2)),
                  title: Text('Facebook: @TahoStory'),
                ),
                ListTile(
                  leading: Icon(Icons.camera_alt_outlined,
                      color: Color(0xFFC13584)), // Instagram
                  title: Text('Instagram: @taho.story'),
                ),
                ListTile(
                  leading: Icon(Icons.music_note,
                      color: Color(0xFF010101)), // TikTok
                  title: Text('TikTok: @taho_story_official'),
                ),
              ],
            ),
            _buildExpandableMenuItem(
              icon: Icons.phone_outlined,
              title: 'Contact Us',
              subtitle: 'Get in touch with us',
              children: const [
                ListTile(
                  leading: Icon(Icons.phone, color: Colors.green),
                  title: Text('Phone: +63 912 345 6789'),
                ),
                ListTile(
                  leading: Icon(Icons.email_outlined, color: Colors.orange),
                  title: Text('Email: support@tahostory.ph'),
                ),
              ],
            ),
            _buildExpandableMenuItem(
              icon: Icons.help_outline,
              title: 'Help & Support',
              subtitle: 'Get help with your orders',
              children: const [
                ListTile(
                  leading: Icon(Icons.help_outline, color: Colors.blue),
                  title: Text('FAQs'),
                ),
                ListTile(
                  leading:
                      Icon(Icons.report_problem_outlined, color: Colors.red),
                  title: Text('Report an Issue'),
                ),
              ],
            ),
            _buildExpandableMenuItem(
              icon: Icons.info_outline,
              title: 'About',
              subtitle: 'Learn more about Taho Story',
              children: const [
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  child: Text(
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: const Color(0xFFFF8C42).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFFFF8C42)),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
          childrenPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}
