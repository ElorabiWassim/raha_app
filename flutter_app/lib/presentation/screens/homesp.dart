import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/serviceprovider_data.dart';
import '../../cubits/serviceprovider_cubit.dart';
import './addservicescreen.dart';
import './setting.dart';
import './demands.dart';
import './requests.dart';
import './edit_profile_screen.dart';
import './edit_service_screen.dart';
import '../../modules/upgrades/screens/plans.dart';
import './messages_screen.dart';
import 'package:ra7a/l10n/app_localizations.dart';
import '../../services/api_service.dart';



class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});
  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  final ApiService _apiService = ApiService(); 
  bool _isLoading = true; 

  @override
  void initState() {
    super.initState();
    _loadProviderData(); 
  }

  Future<void> _loadProviderData() async {
  try {
    final profileData = await _apiService.getProfile();
    final servicesData = await _apiService.getMyServices();

    // Fetch images for each service
    final List<Service> servicesWithImages = [];
    for (var s in servicesData) {
      List<dynamic> imageList = [];
      try {
        imageList = await _apiService.getImagesByServiceId(s['service_id']);
      } catch (e) {
        print('Failed to load images for service ${s['service_id']}: $e');
        // Continue even if images fail
      }

      // Extract image URLs
      List<String> imageUrls = imageList
          .map((img) => img['image_url'] as String)
          .where((url) => url.isNotEmpty)
          .toList();

      servicesWithImages.add(Service(
        title: s['name'],
        price: s['price_type'] == 'fixed'
            ? 'Starts at ${s['price_amount']} DA'
            : '${s['price_amount']} DA per hour',
        isActive: true,
        category: s['service_categories']['name'] ?? 'General',
        description: s['description'] ?? '',
        images: imageUrls, // 👈 Add images here
      ));
    }

    final provider = ServiceProvider(
      name: profileData['profile']['users']['full_name'],
      profession: profileData['profile']['service_type'] ?? 'Service Provider',
      location: profileData['profile']['working_address'] ?? 'Not specified',
      rating: 4.9,
      reviewCount: 125,
      jobsDone: profileData['profile']['jobs_done']?.toString() ?? '0',
      experience: '${profileData['profile']['experience_years'] ?? 0} yrs',
      responseTime: '< 1hr',
      pendingRequests: 5,
      confirmedJobs: 3,
      totalEarnings: 45000,
      services: servicesWithImages, // 👈 Updated list with images
    );

    context.read<ServiceProviderCubit>().initializeProvider(provider);

    setState(() {
      _isLoading = false;
    });
  } catch (e) {
    print('Error loading provider data: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to load profile data')),
    );
    setState(() {
      _isLoading = false;
    });
  }
}
  List<Widget> _getPages() {
    return [
      ServiceProviderHome(onRefresh: _loadProviderData), 
      DemandsPage(),
      RequestsPage(),
      MessagesScreen(),
      PlansPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF68E36C),
          ),
        ),
      );
    }
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
          elevation: 8,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: l10n.home,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.inbox_outlined),
              activeIcon: Icon(Icons.inbox),
              label: l10n.demands,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.check_circle_outline),
              activeIcon: Icon(Icons.check_circle),
              label: l10n.requests,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message_outlined),
              activeIcon: Icon(Icons.message),
              label: l10n.messages,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.card_membership_outlined),
              activeIcon: Icon(Icons.card_membership),
              label: l10n.plans,
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceProviderHome extends StatelessWidget {
  final VoidCallback onRefresh; // ← Add this

  const ServiceProviderHome({
    super.key,
    required this.onRefresh, // ← Make it required
  });

  void _navigateToPage(BuildContext context, String pageName, {Service? service, int? serviceIndex}) {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<ServiceProviderCubit>();
    final provider = cubit.provider;
    
    if (provider == null) return;

    Widget? page;

    switch (pageName) {
      case 'Add Service':
        page = AddServiceScreen(
          onServiceAdded: () {
            onRefresh(); // ✅ Call the passed-in refresh function
          },
        );
        break;

      case 'Settings':
        page = SettingsScreen(
          provider: provider,
          onProfileUpdated: (name) {
            cubit.updateProfile(name: name);
          },
        );
        break;

      case 'Edit Profile':
        page = EditProfileScreen(provider: provider);
        break;

      case 'Edit Service':
        if (service != null && serviceIndex != null) {
          page = EditServiceScreen(
            service: service,
            serviceIndex: serviceIndex,
          );
        }
        break;

      case 'Notifications':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.notifications_active, color: Colors.white),
                SizedBox(width: 12),
                Text(l10n.notificationsComingSoon),
              ],
            ),
            backgroundColor: Color(0xFF68E36C),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            duration: Duration(seconds: 2),
          ),
        );
        return;

      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.navigationTo} $pageName - ${l10n.comingSoon}'),
            backgroundColor: Color(0xFF68E36C),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            duration: Duration(seconds: 1),
          ),
        );
        return;
    }

    if (page != null) {
     Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => page!), // Safe because of if (page != null)
  );
}
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return BlocBuilder<ServiceProviderCubit, ServiceProviderState>(
      builder: (context, state) {
        final provider = context.read<ServiceProviderCubit>().provider;
        
        if (provider == null) {
          return Center(child: CircularProgressIndicator());
        }
        
        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF68E36C), Color(0xFF5CD660)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            elevation: 0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.welcomeBack,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                Text(
                  provider.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () => _navigateToPage(context, 'Notifications'),
                icon: Stack(
                  children: [
                    Icon(Icons.notifications_outlined, color: Colors.white),
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
                icon: Icon(Icons.settings_outlined, color: Colors.white),
              ),
            ],
          ),
          body: RefreshIndicator(
            color: Color(0xFF68E36C),
            onRefresh: () async {
              onRefresh(); // Also use it here for pull-to-refresh
              await Future.delayed(Duration(milliseconds: 500));
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileCard(context, provider),
                  _buildStatsRow(context, provider),
                  SizedBox(height: 24),
                  _buildQuickActions(context),
                  SizedBox(height: 24),
                  _buildServicesSection(context, provider),
                  SizedBox(height: 32),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileCard(BuildContext context, ServiceProvider provider) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF68E36C), Color(0xFF5CD660)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF68E36C).withValues(alpha: 0.4),
            blurRadius: 20,
            spreadRadius: 2,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _navigateToPage(context, 'Edit Profile'),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 38,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 42, color: Color(0xFF68E36C)),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        provider.profession,
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 6),
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
                            '(${provider.reviewCount} ${l10n.reviews})',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.white.withValues(alpha: 0.9), size: 14),
                          SizedBox(width: 4),
                          Text(
                            provider.location,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

 Widget _buildStatsRow(BuildContext context, ServiceProvider provider) {
  final l10n = AppLocalizations.of(context)!;
  
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.payments_outlined,
            value: '${provider.totalEarnings} DA',
            label: l10n.totalEarnings,
            color: Color(0xFF68E36C),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.check_circle_outline,
            value: provider.jobsDone,
            label: l10n.jobsDone,
            color: Color(0xFF68E36C),
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
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    decoration: BoxDecoration(
      color: Color(0xFF68E36C),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Color(0xFF68E36C).withValues(alpha: 0.3),
          blurRadius: 12,
          spreadRadius: 0,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 24),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.white.withValues(alpha: 0.9),
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

Widget _buildQuickActions(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          l10n.quickActions,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      SizedBox(height: 14),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: _buildActionButton(
                icon: Icons.add_circle_outline,
                label: l10n.addService,
                gradient: [Color(0xFF68E36C), Color(0xFF5CD660)],
                shadowColor: Color(0xFF68E36C),
                onTap: () => _navigateToPage(context, 'Add Service'),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                icon: Icons.edit_outlined,
                label: l10n.editProfile,
                gradient: [Color(0xFF5CD660), Color(0xFF4CAF50)],
                shadowColor: Color(0xFF4CAF50),
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
  required List<Color> gradient,
  required Color shadowColor,
  required VoidCallback onTap,
}) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 22, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              spreadRadius: 0,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: shadowColor.withValues(alpha: 0.4),
                    blurRadius: 12,
                    spreadRadius: 0,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 32),
            ),
            SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    ),
  );
}
  Widget _buildServicesSection(BuildContext context, ServiceProvider provider) {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.myServices,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              TextButton.icon(
                onPressed: () => _navigateToPage(context, 'All Services'),
                icon: Text(
                  l10n.viewAll,
                  style: TextStyle(
                    color: Color(0xFF68E36C),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                label: Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Color(0xFF68E36C),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: provider.services.asMap().entries.map((entry) {
              int index = entry.key;
              Service service = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildServiceCard(context, service, index),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard(BuildContext context, Service service, int index) {
  final l10n = AppLocalizations.of(context)!;

  // Get first image or use placeholder
  String imageUrl = service.images.isNotEmpty
      ? service.images.first
      : 'https://share.google/DlrdB62D0M8pDPkgl';
      print('Service Image URL: $imageUrl');

  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: () => _navigateToPage(context, 'Edit Service', service: service, serviceIndex: index),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: service.isActive
                ? Color(0xFF68E36C).withValues(alpha: 0.3)
                : Colors.grey[300]!,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 15,
              spreadRadius: 0,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey[200],
                      child: Center(child: CircularProgressIndicator()),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey[200],
                      child: Icon(Icons.image, color: Colors.grey[600]),
                    );
                  },
                ),
              ),
              SizedBox(width: 12),
              // Service info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      service.description,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.attach_money, size: 14, color: Colors.grey[600]),
                        SizedBox(width: 2),
                        Text(
                          service.price,
                          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                        ),
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: service.isActive
                                ? Color(0xFF68E36C).withValues(alpha: 0.1)
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            service.isActive ? l10n.active : l10n.inactive,
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
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Color(0xFF68E36C), size: 18),
            ],
          ),
        ),
      ),
    ),
  );
}
}