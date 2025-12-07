import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../screens/dashboard.dart';
import '../screens/applications.dart';
import '../screens/reports.dart';
import '../../cubits/dashboard_cubit.dart';
import '../../cubits/applications_cubit.dart';
import '../../cubits/reports_cubit.dart';

class Ra7aBottomNav extends StatelessWidget {
  final int currentIndex;

  const Ra7aBottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        if (index == currentIndex) return;

        Widget nextPage;
        switch (index) {
          case 0:
            nextPage = BlocProvider(
              create: (_) =>
                  GetIt.instance<DashboardCubit>()..loadDashboardStats(),
              child: const DashboardPage(),
            );
            break;
          case 1:
            nextPage = BlocProvider(
              create: (_) =>
                  GetIt.instance<ApplicationsCubit>()..loadApplications(),
              child: const ApplicationsPage(),
            );
            break;
          case 2:
            nextPage = BlocProvider(
              create: (_) => GetIt.instance<ReportsCubit>()..loadReports(),
              child: const ReportsPage(),
            );
            break;
          default:
            nextPage = BlocProvider(
              create: (_) =>
                  GetIt.instance<DashboardCubit>()..loadDashboardStats(),
              child: const DashboardPage(),
            );
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => nextPage),
        );
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF4CAF50),
      unselectedItemColor: const Color(0xFF6B7280),
      selectedFontSize: 11,
      unselectedFontSize: 11,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.space_dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Applications',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.flag), label: 'Reports'),
      ],
    );
  }
}
