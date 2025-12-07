import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/reports_cubit.dart';
import '../../cubits/reports_state.dart';
import '../../data/models/report.dart';
import '../widgets/bottom_nav_admin.dart';
import 'package:ra7a/l10n/app_localizations.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportsCubit, ReportsState>(
      builder: (context, state) {
        if (state is ReportsLoading) {
          return Scaffold(
            backgroundColor: const Color(0xFFF5F8F8),
            body: const Center(child: CircularProgressIndicator()),
            bottomNavigationBar: const Ra7aBottomNav(currentIndex: 2),
          );
        }

        if (state is ReportsError) {
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
                    onPressed: () => context.read<ReportsCubit>().loadReports(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: const Ra7aBottomNav(currentIndex: 2),
          );
        }

        if (state is ReportsLoaded) {
          return _ReportsContent(reports: state.reports);
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF5F8F8),
          body: const Center(child: Text('No data available')),
          bottomNavigationBar: const Ra7aBottomNav(currentIndex: 2),
        );
      },
    );
  }
}

class _ReportsContent extends StatefulWidget {
  final List<Report> reports;

  const _ReportsContent({required this.reports});

  @override
  State<_ReportsContent> createState() => _ReportsContentState();
}

class _ReportsContentState extends State<_ReportsContent> {
  int selectedFilter = 0;
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    // Filter reports based on search query
    final filteredReports = widget.reports.where((report) {
      if (searchQuery.isEmpty) return true;
      final homeowner = report.homeownerName.toLowerCase();
      final provider = report.providerName.toLowerCase();
      final issue = report.issue.toLowerCase();
      return homeowner.contains(searchQuery.toLowerCase()) ||
          provider.contains(searchQuery.toLowerCase()) ||
          issue.contains(searchQuery.toLowerCase());
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
                        Icons.flag,
                        color: Color(0xFF4CAF50),
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        localizations.reportsTitle,
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
                      hintText: localizations.reportsSearchHint,
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
                  const SizedBox(height: 16),
                  // Filter Tabs
                  Row(
                    children: [
                      _buildFilterButton(localizations.reportsFilterNew(3), 0),
                      const SizedBox(width: 8),
                      _buildFilterButton(
                        localizations.reportsFilterInProgress,
                        1,
                      ),
                      const SizedBox(width: 8),
                      _buildFilterButton(
                        localizations.reportsFilterResolved,
                        2,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Reports List
            Expanded(
              child: filteredReports.isEmpty
                  ? Center(
                      child: Text(
                        searchQuery.isEmpty
                            ? 'No reports available'
                            : 'No reports found',
                        style: const TextStyle(color: Color(0xFF6B7280)),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        await context.read<ReportsCubit>().loadReports();
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredReports.length,
                        itemBuilder: (context, index) {
                          final report = filteredReports[index];
                          return ReportCard(
                            reportId: report.reportId,
                            homeowner: report.homeownerName,
                            provider: report.providerName,
                            issue: report.issue,
                            description: report.description,
                            status: report.status,
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const Ra7aBottomNav(currentIndex: 2),
    );
  }

  Widget _buildFilterButton(String text, int index) {
    final isSelected = selectedFilter == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedFilter = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF4CAF50)
                  : const Color(0xFFE5E7EB),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected
                  ? const Color(0xFF4CAF50)
                  : const Color(0xFF6B7280),
            ),
          ),
        ),
      ),
    );
  }
}

class ReportCard extends StatelessWidget {
  final String reportId;
  final String homeowner;
  final String provider;
  final String issue;
  final String description;
  final String status;

  const ReportCard({
    super.key,
    required this.reportId,
    required this.homeowner,
    required this.provider,
    required this.issue,
    required this.description,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Homeowner and Provider
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.reportsHomeowner,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      homeowner,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.reportsProvider,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      provider,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 12),

          // Issue Title
          Text(
            issue,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4CAF50),
            ),
          ),
          const SizedBox(height: 8),

          // Description
          Text(
            description,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF6B7280),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
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
                    localizations.reportsDetails,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF4CAF50),
                    side: const BorderSide(color: Color(0xFF4CAF50)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    localizations.reportsResolve,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
