import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../providers/user_provider.dart';
import 'citizen_dashboard.dart';
import 'advertiser_dashboard.dart';
import 'admin_dashboard.dart';

class LoginScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void handleLogin(BuildContext context) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final authService = AuthService();
      final user = await authService.login(emailController.text, passwordController.text);
      print(user?.role);
      if (user != null) {
        userProvider.setUser(user);
        if (user.role == 'citizen') {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => CitizenDashboard()));
        } else if (user.role == 'advertiser') {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AdvertiserDashboard()));
        } else if (user.role == 'admin') {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AdminDashboard()));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: "Password"), obscureText: true),
            ElevatedButton(onPressed: () => handleLogin(context), child: Text("Login"))
          ],
        ),
      ),
    );
  }
}
