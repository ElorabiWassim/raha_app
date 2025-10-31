import 'package:flutter/material.dart';
import './pages/bottomNavbar.dart';
import './pages/book_service.dart';

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
