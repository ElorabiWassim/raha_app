import 'package:flutter/material.dart';
import '../widgets/proffesionalCardWidget.dart';
import '../models/service_provider_model.dart';
import './profile.dart';

class ServiceProviderScreen extends StatelessWidget {
  final List<ServiceProvider> serviceProviders;

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
          final provider = serviceProviders[index];
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 4.0,
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Providerprofile(
                      serviceProvider: provider,
                    ),
                  ),
                );
              },
              child: ProfessionalCard(
                name: provider.name,
                profession: provider.profession,
                rating: provider.rating,
                reviews: provider.reviewCount,
                imagePath: provider.imagePath,
              ),
            ),
          );
        },
      ),
    );
  }
}