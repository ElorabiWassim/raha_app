import 'package:flutter/material.dart';
import '../models/serviceprovider_data.dart';
import './addservicescreen.dart';
import './setting.dart';

void main() {
  runApp(
    MaterialApp(debugShowCheckedModeBanner: false, home: MainNavigationScreen()),
  );
}
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});
  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  late ServiceProvider provider;

  @override
  void initState() {
    super.initState();
    provider = ServiceProvider(
      name: "Amjad axlo",
      profession: "Master Plumber",
      location: "Algiers, Draria",
      rating: 4.9,
      reviewCount: 125,
      jobsDone: "150+",
      experience: "10 yrs",
      responseTime: "< 1hr",
      pendingRequests: 5,
      confirmedJobs: 3,
      totalEarnings: 45000,
      services: [
        Service(
          title: 'Leak Detection & Repair',
          price: 'Starts at 1300 DA',
          isActive: true,
        ),
        Service(
          title: 'Drain Cleaning',
          price: '2500 DA per hour',
          isActive: true,
        ),
        Service(
          title: 'Water Heater Installation',
          price: 'Starts at 5000 DA',
          isActive: false,
        ),
      ],
    );
  }

  void _onServiceAdded(Service newService) {
    setState(() {
      provider.services.add(newService);
    });
  }

  void _onProfileUpdated(String name) {
    setState(() {
      provider.name = name;
    });
  }

  List<Widget> _getPages() {
    return [
      ServiceProviderHome(provider: provider, onServiceAdded: _onServiceAdded, onProfileUpdated: _onProfileUpdated),
      DemandsScreen(), 
      RequestsScreen(), 
      MessagesScreen(), 
      PlansScreen(), 
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getPages()[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              spreadRadius: 0,
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFF68E36C),
          unselectedItemColor: Colors.grey[600],
          selectedFontSize: 12,
          unselectedFontSize: 12,
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.inbox_outlined),
              activeIcon: Icon(Icons.inbox),
              label: 'Demands',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.check_circle_outline),
              activeIcon: Icon(Icons.check_circle),
              label: 'Requests',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message_outlined),
              activeIcon: Icon(Icons.message),
              label: 'Messages',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.card_membership_outlined),
              activeIcon: Icon(Icons.card_membership),
              label: 'Plans',
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceProviderHome extends StatelessWidget {
  final ServiceProvider provider;
  final Function(Service) onServiceAdded;
  final Function(String) onProfileUpdated;

  const ServiceProviderHome({
    super.key,
    required this.provider,
    required this.onServiceAdded,
    required this.onProfileUpdated,
  });

  void _navigateToPage(BuildContext context, String pageName) {
    Widget? page;

    switch (pageName) {
      case 'Add Service':
        page = AddServiceScreen(
          onServiceAdded: onServiceAdded,
        );
        break;
      case 'Settings':
        page = SettingsScreen(
          provider: provider,
          onProfileUpdated: onProfileUpdated,
        );
        break;
      case 'Notifications':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Notifications - Coming Soon'),
            duration: Duration(seconds: 1),
          ),
        );
        return;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Navigation to $pageName - Coming Soon'),
            duration: Duration(seconds: 1),
          ),
        );
        return;
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) => page!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        elevation: 2,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back,',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.grey[600],
              ),
            ),
            Text(
              provider.name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => _navigateToPage(context, 'Notifications'),
            icon: Stack(
              children: [
                Icon(Icons.notifications_outlined, color: Colors.black),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '3',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _navigateToPage(context, 'Settings'),
            icon: Icon(Icons.settings_outlined, color: Colors.black),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileCard(context),
            _buildStatsRow(),
            SizedBox(height: 24),
            _buildQuickActions(context),
            SizedBox(height: 24),
            _buildServicesSection(context),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF68E36C),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF68E36C).withValues(alpha: 0.3),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 40, color: Color(0xFF68E36C)),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  provider.profession,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 18),
                    SizedBox(width: 4),
                    Text(
                      '${provider.rating}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      '(${provider.reviewCount} reviews)',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _navigateToPage(context, 'My Profile'),
            icon: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              icon: Icons.attach_money,
              value: '${provider.totalEarnings} DA',
              label: 'Total Earnings',
              color: Colors.blue,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              icon: Icons.work_outline,
              value: provider.jobsDone,
              label: 'Jobs Done',
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  icon: Icons.add_circle_outline,
                  label: 'Add Service',
                  color: Color(0xFF68E36C),
                  onTap: () => _navigateToPage(context, 'Add Service'),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  icon: Icons.edit_outlined,
                  label: 'Edit Profile',
                  color: Colors.blue,
                  onTap: () => _navigateToPage(context, 'Edit Profile'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Services',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              TextButton(
                onPressed: () => _navigateToPage(context, 'All Services'),
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: Color(0xFF68E36C),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: provider.services.map((service) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildServiceCard(context, service),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard(BuildContext context, Service service) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          service.title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            children: [
              Text(
                service.price,
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
              SizedBox(width: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: service.isActive
                      ? Color(0xFF68E36C).withValues(alpha: 0.1)
                      : Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  service.isActive ? 'Active' : 'Inactive',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: service.isActive
                        ? Color(0xFF68E36C)
                        : Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ),
        trailing: Icon(Icons.edit_outlined, color: Color(0xFF68E36C), size: 20),
        onTap: () => _navigateToPage(context, 'Edit Service: ${service.title}'),
      ),
    );
  }
}

class DemandsScreen extends StatelessWidget {
  const DemandsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: Text('Pending Demands', style: TextStyle(color: Colors.black)),
      ),
      body: Center(
        child: Text('Demands Screen - Coming Soon'),
      ),
    );
  }
}

class RequestsScreen extends StatelessWidget {
  const RequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: Text('Confirmed Requests', style: TextStyle(color: Colors.black)),
      ),
      body: Center(
        child: Text('Requests Screen - Coming Soon'),
      ),
    );
  }
}

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: Text('Messages', style: TextStyle(color: Colors.black)),
      ),
      body: Center(
        child: Text('Messages Screen - Coming Soon'),
      ),
    );
  }
}

class PlansScreen extends StatelessWidget {
  const PlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: Text('Subscription Plans', style: TextStyle(color: Colors.black)),
      ),
      body: Center(
        child: Text('Plans Screen - Coming Soon'),
      ),
    );
  }
}