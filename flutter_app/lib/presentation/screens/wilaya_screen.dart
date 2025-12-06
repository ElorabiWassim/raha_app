import 'package:flutter/material.dart';
import '../../data/models/Wilayas.dart';
import '../../database/DbHelper.dart'; // Make sure this points to your DatabaseHelper
import 'service_provider_screen.dart';
import 'package:ra7a/l10n/app_localizations.dart';

class WilayaScreen extends StatelessWidget {
  final String category;
  const WilayaScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 50),
          child: Text(
            l10n.selectWilaya,
            style: const TextStyle(
              color: Color(0xFF1E293B),
              fontWeight: FontWeight.bold,
              fontSize: 20,
              letterSpacing: 0,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF51B035)),
      ),
      body: FutureBuilder<List<Wilaya>>(
        future: _loadWilayas(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final wilayas = snapshot.data ?? [];

          if (wilayas.isEmpty) {
            return Center(child: Text('No wilayas found'));
          }

          return ListView.builder(
            itemCount: wilayas.length,
            itemBuilder: (context, index) {
              final wilaya = wilayas[index];

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
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    onTap: () {
                      // If service providers exist, navigate to the screen
                      if (wilaya.serviceProvidersByCategory.containsKey(
                        category,
                      )) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ServiceProviderScreen(
                              serviceProviders:
                                  wilaya.serviceProvidersByCategory[category]!,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// Load wilayas from the local database
  Future<List<Wilaya>> _loadWilayas(BuildContext context) async {
    final dbHelper = DatabaseHelper();
    final data = await dbHelper.getWilayas();

    // Use Arabic or French depending on app locale
    final locale = Localizations.localeOf(context).languageCode;

    return data.map((row) {
      return Wilaya(
        name: locale == 'ar' ? row['name_ar'] : row['name_fr'],
        serviceProvidersByCategory: {}, // Keep empty for now
      );
    }).toList();
  }
}
