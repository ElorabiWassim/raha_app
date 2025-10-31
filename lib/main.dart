import 'package:flutter/material.dart';
import './pages/home_screen_home_owner.dart';
import './pages/bottomNavbar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(body: HomeBottomNav()),
    ); //Main Navigation For The HomeOwner
  }
}
