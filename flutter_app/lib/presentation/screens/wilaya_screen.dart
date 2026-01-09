import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/wilaya_cubit.dart';
import 'service_provider_screen.dart';
import 'package:ra7a/l10n/app_localizations.dart';
import '../../cubits/load_service_providers_cubit.dart';

class WilayaScreen extends StatelessWidget {
  final String category;

  WilayaScreen({super.key, required this.category});

  final Map<String, String> categoryToId = {
    "Electrical": "069dc664-5fd9-435c-a688-cc002e46243b",
    "Gardening": "3e53048d-1367-4e9f-ac4e-e39e5936dc0e",
    "Cleaning": "6ca0c6a3-efa3-481e-b40a-a173bbcdb283",
    "Handyman": "74738160-4b3e-4c15-a8e6-9a2dd26f0c03",
    "Moving": "837ecd35-78de-4320-be91-9cfa67a8bd1f",
    "Plumbing": "a75af59d-3e61-402d-9bd2-54a5e64fc950",
    "Painting": "da59048e-86e6-4a7e-b342-1784687004f7",
  };

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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                create: (_) =>
                                    ServiceProviderCubit()..fetchProviders(
                                      categoryId: categoryToId[category]!,
                                      location: wilaya.name,
                                    ),
                                child: ServiceProviderScreen(),
                              ),
                            ),
                          );
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
