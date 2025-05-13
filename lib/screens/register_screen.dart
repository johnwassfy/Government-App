import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  String role = 'citizen';

  void handleRegister() async {
    try {
      final authService = AuthService();
      await authService.register(
        emailController.text,
        passwordController.text,
        nameController.text,
        role,
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
    } catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Registration failed: $e')),
  );
}

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: "Name")),
            TextField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: "Password"), obscureText: true),
            DropdownButton<String>(
              value: role,
              items: ['citizen', 'advertiser'].map((role) => DropdownMenuItem(value: role, child: Text(role))).toList(),
              onChanged: (val) => setState(() => role = val!),
            ),
            ElevatedButton(onPressed: handleRegister, child: Text("Register"))
          ],
        ),
      ),
    );
  }
}
