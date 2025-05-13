// lib/screens/advertiser_dashboard.dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../screens/start_screen.dart';

class AdvertiserDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Advertiser Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await AuthService().logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => StartScreen()),
                (route) => false,
              );
            },
          )
        ],
      ),
      body: Center(child: Text('Welcome, Advertiser!')),
    );
  }
}
