import 'package:flutter/material.dart';
import '../screens/start_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/citizen_dashboard.dart';
import '../screens/advertiser_dashboard.dart';
import '../screens/admin_dashboard.dart';
import '../screens/messages_screen.dart';
import '../screens/emergency_contacts_screen.dart';
class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/': (context) => StartScreen(),
    '/login': (context) => LoginScreen(),
    '/register': (context) => RegisterScreen(),
    '/citizen': (context) => CitizenDashboard(),
    '/advertiser': (context) => AdvertiserDashboard(),
    '/admin': (context) => AdminDashboard(),
    '/admin/messages': (context) => MessagesScreen(),
    '/emergency_contacts': (context) => EmergencyContactsScreen(),
  };
}