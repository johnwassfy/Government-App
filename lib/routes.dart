import 'package:flutter/material.dart';
import 'package:project/screens/admin_chat_details_screen.dart';
import '../screens/start_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/citizen_dashboard.dart';
import '../screens/advertiser_dashboard.dart';
import '../screens/admin_dashboard.dart';
import '../screens/messages_screen.dart';
import '../screens/emergency_contacts_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/admin_announcements_screen.dart';
import '../screens/admin_advertisements_screen.dart';
import '../screens/admin_polls_screen.dart';
import '../screens/admin_chat_screen.dart';
import '../screens/create_advertisement_screen.dart';
import '../screens/announcement_detail_screen.dart';
import '../screens/poll_details_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/': (context) => StartScreen(),
    '/login': (context) => LoginScreen(),
    '/register': (context) => RegisterScreen(),
    '/citizen': (context) => CitizenDashboard(),
    '/advertiser': (context) => AdvertiserDashboard(),
    '/admin': (context) => AdminDashboard(),
    '/messages': (context) => MessagesScreen(),
    '/emergency': (context) => EmergencyContactsScreen(),
    '/profile': (context) => ProfileScreen(),
    '/admin/announcements': (context) => AdminAnnouncementsScreen(),
    '/admin/advertisements': (context) => AdminAdvertisementsScreen(),
    '/admin/polls': (context) => AdminPollsScreen(),
    '/admin/chat': (context) => AdminChatScreen(),
    '/advertiser/create': (context) => CreateAdvertisementScreen(),
    '/personal_info': (context) => Scaffold(
      appBar: AppBar(
        title: Text('Personal Information'),
      ),
      body: Center(
        child: Text('Personal Information Screen'),
      ),
    ),
    '/help_support': (context) => Scaffold(
      appBar: AppBar(
        title: Text('Help & Support'),
      ),
      body: Center(
        child: Text('Help & Support Screen'),
      ),
    ),
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    if (settings.name == '/announcement_detail') {
      final args = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder: (_) => AnnouncementDetailScreen(
          announcement: args['announcement'],
        ),
      );
    }
    
    // New poll detail route
    if (settings.name == '/poll_detail') {
      final args = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder: (_) => PollDetailsScreen(
          poll: args['poll'],
        ),
      );
    }
    
    if (settings.name == '/admin/chat/detail') {
      final args = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder: (_) => AdminChatDetailScreen(
          userId: args['userId'],
          userName: args['userName'],
        ),
      );
    }
    
    // Default route
    return MaterialPageRoute(builder: (_) => StartScreen());
  }
}