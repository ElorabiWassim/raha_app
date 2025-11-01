import 'package:flutter/material.dart';
import './hosetting.dart';
import '../models/profile_data.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  String _selectedActivityTab = 'upcoming';

  // Profile data
  ProfileData profileData = ProfileData(
    name: 'Mohamed RGB',
    email: 'Mohammedrgb89@email.com',
    phone: '0555897465',
    address: '123 Main Draria, Algiers, Algeria',
  );

  final Map<String, List<Map<String, String>>> _activityData = {
    'upcoming': [
      {
        'title': 'Deep Cleaning Service',
        'provider': 'with Maria Gaci',
        'date': 'Nov 15, 2025',
        'time': '2:00 PM',
        'status': 'CONFIRMED',
      },
      {
        'title': 'Plumbing Repair',
        'provider': 'with Ahmed Sahil',
        'date': 'Nov 28, 2025',
        'time': '10:00 AM',
        'status': 'CONFIRMED',
      },
    ],
    'history': [
      {
        'title': 'Electrical Repair',
        'provider': 'with Dounia Ledoua',
        'date': 'Oct 10, 2025',
        'time': '3:00 PM',
        'status': 'COMPLETED',
      },
      {
        'title': 'Carpet Cleaning',
        'provider': 'with Sarah Welsi',
        'date': 'Oct 5, 2025',
        'time': '11:00 AM',
        'status': 'COMPLETED',
      },
      {
        'title': 'AC Maintenance',
        'provider': 'with Raed elamine',
        'date': 'Sep 20, 2025',
        'time': '1:30 PM',
        'status': 'COMPLETED',
      },
    ],
    'saved': [
      {
        'title': 'Roof Inspection',
        'provider': 'with racim Andero',
        'date': 'Available',
        'time': 'Flexible',
        'status': 'SAVED',
      },
      {
        'title': 'Garden Landscaping',
        'provider': 'with Ali kamil',
        'date': 'Available',
        'time': 'Flexible',
        'status': 'SAVED',
      },
    ],
  };

  void _navigateToPage(String pageName) async {
    if (pageName == 'Edit Profile') {
      // Navigate to Edit Profile and wait for result
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditProfileScreen(profileData: profileData),
        ),
      );

      // If result is returned, update the profile data
      if (result != null && result is ProfileData) {
        setState(() {
          profileData = result;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Color(0xFF68E36C),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else if (pageName == 'Settings') {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SettingsScreen(profileData: profileData),
        ),
      );

      // If result is returned, update the profile data
      if (result != null && result is ProfileData) {
        setState(() {
          profileData = result;
        });
      }}
     
      
     else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Navigation to $pageName - Coming Soon'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            _navigateToPage('Previous Screen');
          },
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'My Profile',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _navigateToPage('Settings');
            },
            icon: Icon(Icons.settings_outlined),
            color: Colors.black,
          ),
        ],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: AssetImage('assets/images/MohammedPicture.png'),
                  ),
                  SizedBox(height: 16),
                  Text(
                    profileData.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Verified Homeowner',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF68E36C),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _navigateToPage('Edit Profile');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: const Color.fromARGB(255, 34, 204, 85),
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 12),

            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  _buildInfoTile(
                    icon: Icons.email_outlined,
                    text: profileData.email,
                    iconColor: Color(0xFF68E36C),
                    onTap: () {},
                  ),
                  Divider(height: 1, thickness: 1, color: Colors.grey[200]),
                  _buildInfoTile(
                    icon: Icons.phone_outlined,
                    text: profileData.phone,
                    iconColor: Color(0xFF68E36C),
                    onTap: () {},
                  ),
                  Divider(height: 1, thickness: 1, color: Colors.grey[200]),
                  _buildInfoTile(
                    icon: Icons.home_outlined,
                    text: profileData.address,
                    iconColor: Color(0xFF68E36C),
                    onTap: () {},
                  ),
                ],
              ),
            ),

            SizedBox(height: 12),

            Container(
              color: Colors.white,
              child: Column(
                children: [
                  _buildMenuTile(
                    icon: Icons.credit_card_outlined,
                    text: 'Payment Methods',
                    iconColor: Color(0xFF68E36C),
                    onTap: () {
                      _navigateToPage('Payment Methods');
                    },
                  ),
                  Divider(height: 1, thickness: 1, color: Colors.grey[200]),
                  _buildMenuTile(
                    icon: Icons.help_outline,
                    text: 'Help & Support',
                    iconColor: Color(0xFF68E36C),
                    onTap: () {
                      _navigateToPage('Help & Support');
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Activity Summary',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      _buildActivityTab('Upcoming', 'upcoming'),
                      SizedBox(width: 32),
                      _buildActivityTab('History', 'history'),
                      SizedBox(width: 32),
                      _buildActivityTab('Saved', 'saved'),
                    ],
                  ),
                  SizedBox(height: 20),
                  _buildActivityList(),
                  SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String text,
    required Color iconColor,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[700],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String text,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[700],
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityTab(String label, String value) {
    final isActive = _selectedActivityTab == value;

    return InkWell(
      onTap: () {
        setState(() => _selectedActivityTab = value);
      },
      child: Container(
        padding: EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? Color(0xFF68E36C) : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Color(0xFF68E36C) : Colors.grey[500],
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildActivityList() {
    final activities = _activityData[_selectedActivityTab] ?? [];

    if (activities.isEmpty) {
      return Container(
        padding: EdgeInsets.all(40),
        child: Center(
          child: Text(
            'No activities found',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
        ),
      );
    }

    return Column(
      children: activities.map((activity) {
        return Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: _buildActivityCard(
            title: activity['title']!,
            provider: activity['provider']!,
            date: activity['date']!,
            time: activity['time']!,
            status: activity['status']!,
            onTap: () {
              _navigateToPage('${activity['title']} Details');
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActivityCard({
    required String title,
    required String provider,
    required String date,
    required String time,
    required String status,
    VoidCallback? onTap,
  }) {
    Color statusColor;
    switch (status) {
      case 'CONFIRMED':
        statusColor = Color(0xFF68E36C);
        break;
      case 'COMPLETED':
        statusColor = Colors.blue;
        break;
      case 'SAVED':
        statusColor = Colors.orange;
        break;
      default:
        statusColor = Colors.grey;
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        provider,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.calendar_today_outlined,
                    size: 16, color: Colors.grey[600]),
                SizedBox(width: 6),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(width: 16),
                Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                SizedBox(width: 6),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Edit Profile Screen
class EditProfileScreen extends StatefulWidget {
  final ProfileData profileData;

  const EditProfileScreen({super.key, required this.profileData});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current profile data
    _nameController = TextEditingController(text: widget.profileData.name);
    _emailController = TextEditingController(text: widget.profileData.email);
    _phoneController = TextEditingController(text: widget.profileData.phone);
    _addressController = TextEditingController(text: widget.profileData.address);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),

              // Profile Picture with Edit Button
              Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: AssetImage('assets/images/MohammedPicture.png'),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xFF68E36C),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 40),

              _buildInputField(
                label: 'Full Name',
                controller: _nameController,
              ),

              SizedBox(height: 24),
              _buildInputField(
                label: 'Email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),

              SizedBox(height: 24),

              _buildInputField(
                label: 'Phone Number',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
              ),

              SizedBox(height: 24),

              _buildInputField(
                label: 'Home Address',
                controller: _addressController,
                maxLines: 3,
              ),

              SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _saveChanges();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF68E36C),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Save Changes',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: TextStyle(
            fontSize: 15,
            color: Colors.black87,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: maxLines > 1 ? 16 : 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFF68E36C), width: 2),
            ),
          ),
        ),
      ],
    );
  }

  void _saveChanges() {
  
    ProfileData updatedProfile = ProfileData(
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      address: _addressController.text,
    );

    Navigator.pop(context, updatedProfile);
  }
}