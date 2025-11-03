import 'package:flutter/material.dart';
import './onboarding.dart'; // make sure this path is correct

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to Onboarding after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg/bg.png'), // background image
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: ColorFiltered(
            colorFilter: const ColorFilter.mode(
              Color(0xFF33AD04), // primary green tint
              BlendMode.srcIn,
            ),
            child: Image.asset(
              'assets/logo/ra7a_logo.png',
              width: 200,
              height: 200,
            ),
          ),
        ),
      ),
    );
  }
}
