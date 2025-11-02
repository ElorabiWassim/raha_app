import 'package:flutter/material.dart';
import 'package:ra7a/screens/splash.dart';

// import 'screens/my_services_screen.dart';
// import 'screens/home_screen_home_owner.dart';
// import 'screens/bottomNavbar.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ra7a',
      // theme: ThemeData(fontFamily: 'Inter'),
      home: const SplashScreen(),
    );
  }
}
