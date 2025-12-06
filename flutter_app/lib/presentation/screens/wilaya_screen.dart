import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/Wilayas.dart';
import '../../cubits/wilaya_cubit.dart';
import 'service_provider_screen.dart';
import 'package:ra7a/l10n/app_localizations.dart';

class WilayaScreen extends StatelessWidget {
  final String category;
  const WilayaScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;

    return BlocProvider(
      create: (_) => WilayaCubit()..loadWilayas(locale: locale),
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(left: 50),
            child: Text(
              AppLocalizations.of(context)!.selectWilaya,
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
        body: BlocBuilder<WilayaCubit, WilayaState>(
          builder: (context, state) {
            if (state is WilayaLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is WilayaError) {
              return Center(child: Text(state.message));
            } else if (state is WilayaLoaded) {
              final wilayas = state.wilayas;

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
                          if (wilaya.serviceProvidersByCategory.containsKey(
                            category,
                          )) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ServiceProviderScreen(
                                  serviceProviders: wilaya
                                      .serviceProvidersByCategory[category]!,
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
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
