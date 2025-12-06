import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/proffesionalCardWidget.dart';
import '../../data/models/fetched_service_provider.dart';

import 'profile.dart';
import 'package:ra7a/l10n/app_localizations.dart';
import '../../cubits/load_service_providers_cubit.dart';
import '../../cubits/ServiceProviderFetchProfileCubit.dart';

class ServiceProviderScreen extends StatelessWidget {
  const ServiceProviderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            l10n.availableServiceProviders,
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
      body: BlocBuilder<ServiceProviderCubit, ServiceProviderState>(
        builder: (context, state) {
          if (state is ServiceProviderLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ServiceProviderError) {
            return Center(child: Text(state.message));
          }

          if (state is ServiceProviderLoaded) {
            final providers = state.providers;

            if (providers.isEmpty) {
              return const Center(
                child: Text('No service providers available.'),
              );
            }

            return ListView.builder(
              itemCount: providers.length,
              itemBuilder: (context, index) {
                final p = providers[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider(
                            create: (_) =>
                                ServiceProviderProfileCubit()
                                  ..fetchProfile(p.id),
                            child: Providerprofile(spId: p.id),
                          ),
                        ),
                      );
                    },
                    child: ProfessionalCard(
                      name: p.name,
                      profession: p.profession,
                      rating: p.rating,
                      imagePath: p.profile_picture_url,
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
