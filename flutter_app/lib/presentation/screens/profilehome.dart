import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ra7a/l10n/app_localizations.dart';
import './hosetting.dart';
import '../../data/models/profile_data.dart';
import '../../data/local/local_cache_repository.dart';
import '../../logic/cubits/auth/auth_cubit.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  late final LocalCacheRepository _cacheRepository;
  // Profile data
  ProfileData profileData = ProfileData(
    name: 'Mohamed RGB',
    email: 'Mohammedrgb89@email.com',
    phone: '0555897465',
    address: '123 Main Draria, Algiers, Algeria',
  );

  @override
  void initState() {
    super.initState();
    _cacheRepository = LocalCacheRepository();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    await _cacheRepository.init();
    final authState = mounted ? context.read<AuthCubit>().state : null;
    final authUserId = authState is AuthAuthenticated ? authState.userId : null;
    final authName = authState is AuthAuthenticated ? authState.username : null;

    final cachedProfile = await _cacheRepository.getUserProfile(
      userId: authUserId,
    );

    if (cachedProfile != null) {
      setState(() {
        profileData = ProfileData(
          name: cachedProfile.fullName.isNotEmpty
              ? cachedProfile.fullName
              : (authName ?? profileData.name),
          email: cachedProfile.email ?? profileData.email,
          phone: cachedProfile.phoneNumber ?? profileData.phone,
          address: cachedProfile.address ?? profileData.address,
        );
      });
    } else if (authName != null) {
      setState(() {
        profileData = ProfileData(
          name: authName,
          email: profileData.email,
          phone: profileData.phone,
          address: profileData.address,
        );
      });
    }
  }

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
      }
    } else {
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
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black,
        surfaceTintColor: Colors.transparent,
        title: Text(
          AppLocalizations.of(context)!.profileTitle,
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
                    backgroundImage: AssetImage(
                      'assets/images/MohammedPicture.png',
                    ),
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
                    AppLocalizations.of(context)!.profileVerifiedHomeowner,
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF68E36C),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
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
                        AppLocalizations.of(context)!.profileEditProfile,
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
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: TextStyle(fontSize: 15, color: Colors.grey[700]),
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
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: TextStyle(fontSize: 15, color: Colors.grey[700]),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
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
    _addressController = TextEditingController(
      text: widget.profileData.address,
    );
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
                    backgroundImage: AssetImage(
                      'assets/images/MohammedPicture.png',
                    ),
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
                      child: Icon(Icons.edit, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 40),

              _buildInputField(label: 'Full Name', controller: _nameController),

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
          style: TextStyle(fontSize: 15, color: Colors.black87),
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
