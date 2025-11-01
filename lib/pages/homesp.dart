import 'package:flutter/material.dart';
import '../models/serviceprovider_data.dart';
import './addservicescreen.dart';
import './setting.dart';

void main() {
  runApp(
    MaterialApp(debugShowCheckedModeBanner: false, home: ServiceProviderHome()),
  );
}

class ServiceProviderHome extends StatefulWidget {
  const ServiceProviderHome({super.key});

  @override
  State<ServiceProviderHome> createState() => _ServiceProviderHomeState();
}

class _ServiceProviderHomeState extends State<ServiceProviderHome> {
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

  void _navigateToPage(String pageName) {
    Widget? page;

    switch (pageName) {
      case 'Add Service':
        page = AddServiceScreen(
          onServiceAdded: (newService) {
            setState(() {
              provider.services.add(newService);
            });
          },
        );
        break;
      case 'Settings':
        page = SettingsScreen(
          provider: provider,
          onProfileUpdated: (name) {
            setState(() {
              provider.name = name;
            });
          },
        );
        break;
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
            onPressed: () => _navigateToPage('Notifications'),
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
            onPressed: () => _navigateToPage('Settings'),
            icon: Icon(Icons.settings_outlined, color: Colors.black),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileCard(),
            _buildStatsRow(),
            SizedBox(height: 24),
            _buildQuickActions(),
            SizedBox(height: 24),
            _buildRequestsSection(),
            SizedBox(height: 24),
            _buildServicesSection(),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
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
            onPressed: () => _navigateToPage('My Profile'),
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

  Widget _buildQuickActions() {
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
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.add_circle_outline,
                      label: 'Add Service',
                      color: Color(0xFF68E36C),
                      onTap: () => _navigateToPage('Add Service'),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.edit_outlined,
                      label: 'Edit Profile',
                      color: Colors.blue,
                      onTap: () => _navigateToPage('Edit Profile'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.card_membership_outlined,
                      label: 'Plans',
                      color: Colors.purple,
                      onTap: () => _navigateToPage('Plans'),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.message_outlined,
                      label: 'Messages',
                      color: Colors.teal,
                      onTap: () => _navigateToPage('Messages'),
                    ),
                  ),
                ],
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

  Widget _buildRequestsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Requests & Jobs',
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
          child: Column(
            children: [
              _buildRequestCard(
                icon: Icons.inbox_outlined,
                title: 'Pending Requests',
                count: provider.pendingRequests,
                subtitle: 'New service requests',
                color: Colors.orange,
                onTap: () => _navigateToPage('Demands'),
              ),
              SizedBox(height: 12),
              _buildRequestCard(
                icon: Icons.check_circle_outline,
                title: 'Confirmed Jobs',
                count: provider.confirmedJobs,
                subtitle: 'Upcoming scheduled jobs',
                color: Color(0xFF68E36C),
                onTap: () => _navigateToPage('Confirmed Requests'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRequestCard({
    required IconData icon,
    required String title,
    required int count,
    required String subtitle,
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
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$count',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesSection() {
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
                onPressed: () => _navigateToPage('All Services'),
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
                child: _buildServiceCard(service),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard(Service service) {
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
                      ? Color(0xFF68E36C).withValues(alpha: 1)
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
        onTap: () => _navigateToPage('Edit Service: ${service.title}'),
      ),
    );
  }
}
