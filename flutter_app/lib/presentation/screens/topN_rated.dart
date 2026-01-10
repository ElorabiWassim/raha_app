import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/proffesionalCardWidget.dart';
import 'profile.dart';
import '../../cubits/load_service_providers_cubit.dart';
import '../../cubits/ServiceProviderFetchProfileCubit.dart';

class TopNRated extends StatelessWidget {
  final String categoryId;
  final String location;
  final int topN;

  const TopNRated({
    Key? key,
    required this.categoryId,
    required this.location,
    this.topN = 3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ServiceProviderCubit()
        ..fetchTopNProviders(
          categoryId: categoryId,
          location: location,
          topN: topN,
        ),
      child: BlocBuilder<ServiceProviderCubit, ServiceProviderState>(
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
                child: Text('No top rated providers available.'),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
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
