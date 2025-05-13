// // lib/screens/splash_screen.dart
// import 'package:flutter/material.dart';
// import 'package:project/routes.dart'; // To navigate to the next screen

// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _navigateToHome();
//   }

//   void _navigateToHome() async {
//     await Future.delayed(Duration(seconds: 3)); // Show splash for 3 seconds
//     Navigator.pushReplacementNamed(context, Routes.login);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blue, // Your brand color
//       body: Center(
//         child: Text(
//           'Welcome to MyApp!',
//           style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }
// }
