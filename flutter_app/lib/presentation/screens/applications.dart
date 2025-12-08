import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/applications_cubit.dart';
import '../../cubits/applications_state.dart';
import '../../data/models/provider_application.dart';
import '../widgets/bottom_nav_admin.dart';
import 'package:ra7a/l10n/app_localizations.dart';

class ApplicationsPage extends StatelessWidget {
  const ApplicationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApplicationsCubit, ApplicationsState>(
      builder: (context, state) {
        if (state is ApplicationsLoading) {
          return Scaffold(
            backgroundColor: const Color(0xFFF5F8F8),
            body: const Center(child: CircularProgressIndicator()),
            bottomNavigationBar: const Ra7aBottomNav(currentIndex: 1),
          );
        }

        if (state is ApplicationsError) {
          return Scaffold(
            backgroundColor: const Color(0xFFF5F8F8),
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
                        context.read<ApplicationsCubit>().loadApplications(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: const Ra7aBottomNav(currentIndex: 1),
          );
        }

        if (state is ApplicationsLoaded) {
          return _ApplicationsContent(applications: state.applications);
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF5F8F8),
          body: const Center(child: Text('No data available')),
          bottomNavigationBar: const Ra7aBottomNav(currentIndex: 1),
        );
      },
    );
  }
}

class _ApplicationsContent extends StatefulWidget {
  final List<ProviderApplication> applications;

  const _ApplicationsContent({required this.applications});

  @override
  State<_ApplicationsContent> createState() => _ApplicationsContentState();
}

class _ApplicationsContentState extends State<_ApplicationsContent> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    // Filter applications based on search query
    final filteredApplications = widget.applications.where((app) {
      if (searchQuery.isEmpty) return true;
      final name = app.fullName.toLowerCase();
      return name.contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8F8),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(color: Color(0xFFE8F5E9)),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.people,
                        color: Color(0xFF4CAF50),
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        localizations.applicationsTitle,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF388E3C),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Search Bar
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: localizations.applicationsSearchHint,
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFF6B7280),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Applications List
            Expanded(
              child: filteredApplications.isEmpty
                  ? Center(
                      child: Text(
                        searchQuery.isEmpty
                            ? 'No applications available'
                            : 'No applications found',
                        style: const TextStyle(color: Color(0xFF6B7280)),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        await context
                            .read<ApplicationsCubit>()
                            .loadApplications();
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredApplications.length,
                        itemBuilder: (context, index) {
                          final app = filteredApplications[index];
                          return ApplicationCard(
                            applicationId: app.applicationId,
                            name: app.fullName,
                            email: app.email,
                            services: app.services.isNotEmpty
                                ? app.services
                                : ['Service Provider'],
                            time: _formatTime(app.submittedAt),
                            status: app.status,
                            onAccept: () async {
                              await context
                                  .read<ApplicationsCubit>()
                                  .approveApplication(app.applicationId);

                              // Refresh the applications list
                              if (mounted) {
                                context
                                    .read<ApplicationsCubit>()
                                    .loadApplications();
                              }

                              _showSnackBar(
                                localizations.applicationsAccepted(
                                  app.fullName,
                                ),
                                true,
                              );
                            },
                            onDecline: () async {
                              await context
                                  .read<ApplicationsCubit>()
                                  .rejectApplication(app.applicationId);

                              // Refresh the applications list
                              if (mounted) {
                                context
                                    .read<ApplicationsCubit>()
                                    .loadApplications();
                              }

                              _showSnackBar(
                                localizations.applicationsDeclined(
                                  app.fullName,
                                ),
                                false,
                              );
                            },
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const Ra7aBottomNav(currentIndex: 1),
    );
  }

  String _formatTime(DateTime? timestamp) {
    if (timestamp == null) return 'Recently';
    try {
      final now = DateTime.now();
      final difference = now.difference(timestamp);

      if (difference.inDays > 7) {
        return '${(difference.inDays / 7).floor()} week${difference.inDays > 14 ? 's' : ''} ago';
      } else if (difference.inDays > 0) {
        return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
      } else {
        return 'Recently';
      }
    } catch (e) {
      return 'Recently';
    }
  }

  void _showSnackBar(String message, bool isSuccess) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess
            ? const Color(0xFF4CAF50)
            : const Color(0xFFF44336),
      ),
    );
  }
}

class ApplicationCard extends StatelessWidget {
  final String applicationId;
  final String name;
  final String email;
  final List<String> services;
  final String time;
  final String status;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const ApplicationCard({
    super.key,
    required this.applicationId,
    required this.name,
    required this.email,
    required this.services,
    required this.time,
    required this.status,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar and Name
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Color(0xFF4CAF50),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        Text(
                          '${localizations.applicationsApplied}: $time',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Services
                Text(
                  localizations.applicationsServicesOffered,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: services.map((service) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        service,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF388E3C),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          // Action Buttons or Status
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFFF5F8F8),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: status == 'pending'
                ? Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onDecline,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFEBEE),
                            foregroundColor: const Color(0xFFF44336),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(
                            localizations.applicationsDecline,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onAccept,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4CAF50),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(
                            localizations.applicationsAccept,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: status == 'verified'
                          ? const Color(0xFFE8F5E9)
                          : const Color(0xFFFFEBEE),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          status == 'verified'
                              ? Icons.check_circle
                              : Icons.cancel,
                          color: status == 'verified'
                              ? const Color(0xFF4CAF50)
                              : const Color(0xFFF44336),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          status == 'verified'
                              ? localizations.applicationsAccepted(name)
                              : localizations.applicationsDeclined(name),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: status == 'verified'
                                ? const Color(0xFF4CAF50)
                                : const Color(0xFFF44336),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
