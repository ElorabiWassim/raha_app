import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/dashboard_cubit.dart';
import '../../cubits/dashboard_state.dart';
import '../../data/models/dashboard_stats.dart';
import '../widgets/bottom_nav_admin.dart';
import '../../modules/authentication/screens/login.dart';
import 'package:ra7a/l10n/app_localizations.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading) {
          return Scaffold(
            appBar: _buildAppBar(context),
            body: const Center(child: CircularProgressIndicator()),
            bottomNavigationBar: const Ra7aBottomNav(currentIndex: 0),
          );
        }

        if (state is DashboardError) {
          return Scaffold(
            appBar: _buildAppBar(context),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<DashboardCubit>().refreshStats(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: const Ra7aBottomNav(currentIndex: 0),
          );
        }

        if (state is DashboardLoaded) {
          return _buildDashboard(context, state.stats);
        }

        return Scaffold(
          appBar: _buildAppBar(context),
          body: const Center(child: Text('No data available')),
          bottomNavigationBar: const Ra7aBottomNav(currentIndex: 0),
        );
      },
    );
  }

  Widget _buildDashboard(BuildContext context, DashboardStats stats) {
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: const Color(0xFFF5F8F8),
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<DashboardCubit>().refreshStats();
        },
        child: _buildDashboardContent(context, stats),
      ),
      bottomNavigationBar: const Ra7aBottomNav(currentIndex: 0),
    );
  }

  Widget _buildDashboardContent(BuildContext context, DashboardStats stats) {
    final localizations = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.space_dashboard,
                  color: Color(0xFF4CAF50),
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    localizations.dashboardTitle,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF388E3C),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Stats Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.3,
            children: [
              _StatCard(
                title: localizations.dashboardTotalUsers,
                value: '${stats.totalUsers}',
                icon: Icons.people,
                color: const Color(0xFF2196F3),
              ),
              _StatCard(
                title: localizations.dashboardVerifiedSPs,
                value: '${stats.verifiedSPs}',
                icon: Icons.verified_user,
                color: const Color(0xFF4CAF50),
              ),
              _StatCard(
                title: localizations.dashboardActiveBookings,
                value: '${stats.activeBookings}',
                icon: Icons.event_available,
                color: const Color(0xFFFF9800),
              ),
              _StatCard(
                title: localizations.dashboardRevenue,
                value: '\$${stats.revenue.toStringAsFixed(0)}',
                icon: Icons.attach_money,
                color: const Color(0xFF9C27B0),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Recent Activities Section
          Text(
            localizations.dashboardRecentActivity,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 12),
          _buildActivityCard('New user registered', '1 hour ago'),
          _buildActivityCard('Service completed', '2 hours ago'),
          _buildActivityCard('Payment received', '3 hours ago'),
        ],
      ),
    );
  }

  Widget _buildActivityCard(String title, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.notifications, color: Color(0xFF4CAF50)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return AppBar(
      title: Text(localizations.dashboard),
      backgroundColor: const Color(0xFF4CAF50),
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false,
            );
          },
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(icon, color: color, size: 24),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
