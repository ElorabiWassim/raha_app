import 'package:flutter/material.dart';
import '../widgets/proffesionalCardWidget.dart';

class ServiceProviderScreen extends StatelessWidget {
  final List<String> serviceProviders;
  //at the moment it is a list of strings not profiles
  const ServiceProviderScreen({super.key, required this.serviceProviders});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            'Available Service Providers',
            style: TextStyle(
              color: Color(0xFF1E293B),
              fontWeight: FontWeight.bold,
              fontSize: 20,
              letterSpacing: 0,
            ),
          ),
        ),
        iconTheme: IconThemeData(color: Color(0xFF51B035)),
      ),
      body: ListView.builder(
        itemCount: serviceProviders.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 4.0,
            ),
            child: ProfessionalCard(
              name: serviceProviders[index],
              profession: 'proffesion',
              rating: 0,
              reviews: 0,
              imagePath: 'assets/images/JohnDoe.png',
            ),
          );
        },
      ),
    );
  }
}
