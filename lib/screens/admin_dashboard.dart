import 'package:flutter/material.dart';
import 'admin_announcements_screen.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                Navigator.pushReplacementNamed(context, '/');
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'logout', child: Text('Logout')),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _DashboardCard(
            title: 'Announcements',
            icon: Icons.campaign,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AdminAnnouncementsScreen()),
            ),
          ),
          _DashboardCard(
            title: 'Polls',
            icon: Icons.poll,
            onTap: () {
              // Navigate to Polls screen
            },
          ),
          _DashboardCard(
            title: 'Messages',
            icon: Icons.message,
            onTap: () {
              // Navigate to Messages screen
            },
          ),
          _DashboardCard(
            title: 'Advertisements',
            icon: Icons.ad_units,
            onTap: () {
              // Navigate to Advertisements screen
            },
          ),
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, size: 28),
        title: Text(title, style: TextStyle(fontSize: 18)),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
