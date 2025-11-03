import 'package:flutter/material.dart';
import '../Models/Wilayas.dart';
import './service_provider_screen.dart';

class WilayaScreen extends StatelessWidget {
  final String category;
  const WilayaScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 50),
          child: Text(
            'Select Wilaya',
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
        itemCount: wilayas.length,
        itemBuilder: (context, index) {
          final wilaya = wilayas[index];

          if (!wilaya.serviceProvidersByCategory.containsKey(category)) {
            return SizedBox.shrink();
          }

          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              shadowColor: Colors.grey,
              child: ListTile(
                leading: Icon(
                  Icons.location_on,
                  color: Colors.green[700],
                  size: 32,
                ),
                title: Text(
                  wilaya.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: Colors.grey[600],
                ),
                tileColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ServiceProviderScreen(
                        serviceProviders:
                            wilaya.serviceProvidersByCategory[category]!,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
