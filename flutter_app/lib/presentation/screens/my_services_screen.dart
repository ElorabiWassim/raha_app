import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/cubits/bookings/bookings_cubit.dart';
import '../../logic/cubits/demands/demands_cubit.dart';
import '../../logic/cubits/auth/auth_cubit.dart';
import '../../data/local/local_cache_repository.dart';
import '../../data/remote/bookings_api.dart';
import '../../l10n/app_localizations.dart';
import '../themes/app_text_style.dart';
import 'my_bookings_tab.dart';
import 'my_demands_tab.dart';

class MyServicesScreen extends StatefulWidget {
  const MyServicesScreen({super.key});

  @override
  State<MyServicesScreen> createState() => _MyServicesScreenState();
}

class _MyServicesScreenState extends State<MyServicesScreen> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Get userId and access token from AuthCubit
    final authState = context.read<AuthCubit>().state;
    String? userId;
    String? accessToken;
    
    if (authState is AuthAuthenticated) {
      userId = authState.userId;
      accessToken = authState.accessToken;
    }
    
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => BookingsCubit(
            cacheRepository: context.read<LocalCacheRepository>(),
            bookingsApi: BookingsApi(),
            userId: userId,
            accessToken: accessToken,
          )..loadBookings(),
        ),
        BlocProvider(create: (context) => DemandsCubit()..loadDemands()),
      ],
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE6F6E0), Color(0xFFFFFFFF), Color(0xFFF9FFF7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                _buildTabSelector(),
                Expanded(
                  child: _selectedTabIndex == 0
                      ? const MyBookingsTab()
                      : const MyDemandsTab(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return BlocBuilder<BookingsCubit, BookingsState>(
      builder: (context, state) {
        final isOffline = state is BookingsLoaded && !state.isOnline;
        
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF7E6).withValues(alpha: .8),
          ),
          child: Row(
            children: [
              Container(width: 48, height: 48, alignment: Alignment.centerLeft),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.myServicesTitle,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.heading4.copyWith(color: AppColors.textDark),
                    ),
                    if (isOffline)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.cloud_off, size: 12, color: Colors.orange.shade700),
                            const SizedBox(width: 4),
                            Text(
                              'Offline Mode',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.orange.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(
                width: 48,
                height: 48,
                child: IconButton(
                  icon: Icon(
                    Icons.notifications_outlined,
                    color: AppColors.textDark,
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabSelector() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Container(
        height: 36,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .6),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: _buildTabButton(
                label: AppLocalizations.of(context)!.myBookingsTab,
                isSelected: _selectedTabIndex == 0,
                onTap: () => setState(() => _selectedTabIndex = 0),
              ),
            ),
            Expanded(
              child: _buildTabButton(
                label: AppLocalizations.of(context)!.myDemandsTab,
                isSelected: _selectedTabIndex == 1,
                onTap: () => setState(() => _selectedTabIndex = 1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.label.copyWith(
              color: isSelected ? AppColors.primary : AppColors.textLight,
            ),
          ),
        ),
      ),
    );
  }
}
