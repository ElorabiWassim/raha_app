import 'package:flutter/material.dart';
import '../../data/models/profile_data.dart';
import './profilehome.dart';
import '../../modules/authentication/screens/login.dart';

class SettingsScreen extends StatefulWidget {
  final ProfileData profileData;

  const SettingsScreen({super.key, required this.profileData});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late ProfileData currentProfileData;
  bool pushNotifications = true;
  bool emailNotifications = false;
  bool smsNotifications = true;

  @override
  void initState() {
    super.initState();
    currentProfileData = widget.profileData;
  }

  void _navigateToEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EditProfileScreen(profileData: currentProfileData),
      ),
    );

    if (result != null && result is ProfileData) {
      setState(() {
        currentProfileData = result;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Color(0xFF68E36C),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 2,
        shadowColor: Colors.black,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context, currentProfileData);
          },
        ),
        backgroundColor: Colors.white,
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16),

            // Profile Card
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
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
                contentPadding: EdgeInsets.all(16),
                leading: CircleAvatar(
                  radius: 28,
                  backgroundImage: AssetImage(
                    'assets/images/MohammedPicture.png',
                  ),
                ),
                title: Text(
                  currentProfileData.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    currentProfileData.email,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ),
                trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
                onTap: () {
                  // Navigate to profile view
                },
              ),
            ),

            SizedBox(height: 24),

            // ACCOUNT Section
            _buildSectionHeader('ACCOUNT'),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
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
                  _buildMenuItem(
                    icon: Icons.person_outline,
                    title: 'Edit Profile',
                    onTap: _navigateToEditProfile,
                  ),
                  Divider(height: 1, thickness: 1, color: Colors.grey[200]),
                  _buildMenuItem(
                    icon: Icons.credit_card_outlined,
                    title: 'Payment Methods',
                    onTap: () {
                      //  Navigate to payment methods
                    },
                  ),
                  Divider(height: 1, thickness: 1, color: Colors.grey[200]),
                  _buildMenuItem(
                    icon: Icons.location_on_outlined,
                    title: 'My Addresses',
                    onTap: () {
                      // Navigate to addresses
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),
            _buildSectionHeader('NOTIFICATIONS'),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
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
                  _buildSwitchItem(
                    icon: Icons.notifications_outlined,
                    title: 'Push Notifications',
                    value: pushNotifications,
                    onChanged: (val) {
                      setState(() => pushNotifications = val);
                    },
                  ),
                  Divider(height: 1, thickness: 1, color: Colors.grey[200]),
                  _buildSwitchItem(
                    icon: Icons.email_outlined,
                    title: 'Email Notifications',
                    value: emailNotifications,
                    onChanged: (val) {
                      setState(() => emailNotifications = val);
                    },
                  ),
                  Divider(height: 1, thickness: 1, color: Colors.grey[200]),
                  _buildSwitchItem(
                    icon: Icons.sms_outlined,
                    title: 'SMS Notifications',
                    value: smsNotifications,
                    onChanged: (val) {
                      setState(() => smsNotifications = val);
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            _buildSectionHeader('SECURITY & PRIVACY'),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
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
                  _buildMenuItem(
                    icon: Icons.lock_outline,
                    title: 'Change Password',
                    onTap: () {},
                  ),
                  Divider(height: 1, thickness: 1, color: Colors.grey[200]),
                  _buildMenuItem(
                    icon: Icons.security_outlined,
                    title: 'Two-Factor Authentication',
                    onTap: () {},
                  ),
                  Divider(height: 1, thickness: 1, color: Colors.grey[200]),
                  _buildMenuItem(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    onTap: () {},
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            _buildSectionHeader('SUPPORT & LEGAL'),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
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
                  _buildMenuItem(
                    icon: Icons.help_outline,
                    title: 'Help Center',
                    onTap: () {},
                  ),
                  Divider(height: 1, thickness: 1, color: Colors.grey[200]),
                  _buildMenuItem(
                    icon: Icons.headset_mic_outlined,
                    title: 'Contact Support',
                    onTap: () {},
                  ),
                  Divider(height: 1, thickness: 1, color: Colors.grey[200]),
                  _buildMenuItem(
                    icon: Icons.description_outlined,
                    title: 'Terms of Service',
                    onTap: () {},
                  ),
                ],
              ),
            ),

            SizedBox(height: 32),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _showLogoutDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF9800),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Log Out',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 32, bottom: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey[500],
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xFF68E36C).withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Color(0xFF68E36C), size: 22),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 15, color: Colors.black87),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchItem({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFF68E36C).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Color(0xFF68E36C), size: 22),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,

            activeTrackColor: Color(0xFF68E36C).withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false,
              );
            },
            child: Text('Logout', style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }
}
