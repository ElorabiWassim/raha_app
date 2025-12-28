import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'hosetting.dart';
import 'package:ra7a/l10n/app_localizations.dart';
import '../../data/models/profile_data.dart';
import '../../cubits/profile_cubit.dart';

class MyProfileScreen extends StatelessWidget {
  ProfileData profileData = ProfileData(
    name: 'Mohamed RGB',
    email: 'Mohammedrgb89@email.com',
    phone: '0555897465',
    address: '123 Main Draria, Algiers, Algeria',
  );

  MyProfileScreen({super.key});

  void _navigateToPage(BuildContext context, String pageName) async {
    final l10n = AppLocalizations.of(context)!;

    if (pageName == 'Edit Profile') {
      final profileCubit = context.read<ProfileCubit>();
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: profileCubit,
            child: EditProfileScreen(profileData: profileData),
          ),
        ),
      );

      if (result != null && result is ProfileData) {
        profileCubit.updateProfile(result);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.profileUpdatedSuccess),
            backgroundColor: Color(0xFF68E36C),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else if (pageName == 'Settings') {
      final profileCubit = context.read<ProfileCubit>();
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: profileCubit,
            child: SettingsScreen(profileData: profileData),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${l10n.navigationTo(pageName)} - ${l10n.comingSoon}'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black,
        surfaceTintColor: Colors.transparent,
        title: Text(
          l10n.myProfile,
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _navigateToPage(context, 'Settings');
            },
            icon: Icon(Icons.settings_outlined),
            color: Colors.black,
          ),
        ],
        centerTitle: true,
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          final profileData = state.profileData;

          return SingleChildScrollView(
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
                        l10n.verifiedHomeowner,
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
                            _navigateToPage(context, 'Edit Profile');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[200],
                            foregroundColor: const Color.fromARGB(
                              255,
                              34,
                              204,
                              85,
                            ),
                            elevation: 0,
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            l10n.editProfile,
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
                        text: l10n.paymentMethods,
                        iconColor: Color(0xFF68E36C),
                        onTap: () {
                          _navigateToPage(context, l10n.paymentMethods);
                        },
                      ),
                      Divider(height: 1, thickness: 1, color: Colors.grey[200]),
                      _buildMenuTile(
                        icon: Icons.help_outline,
                        text: l10n.helpSupport,
                        iconColor: Color(0xFF68E36C),
                        onTap: () {
                          _navigateToPage(context, l10n.helpSupport);
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24),
              ],
            ),
          );
        },
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
    final profileData = context.read<ProfileCubit>().state.profileData;
    _nameController = TextEditingController(text: profileData.name);
    _emailController = TextEditingController(text: profileData.email);
    _phoneController = TextEditingController(text: profileData.phone);
    _addressController = TextEditingController(text: profileData.address);
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
    final l10n = AppLocalizations.of(context)!;

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
          l10n.editProfile,
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
              _buildInputField(
                label: l10n.fullName,
                controller: _nameController,
              ),
              SizedBox(height: 24),
              _buildInputField(
                label: l10n.email,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 24),
              _buildInputField(
                label: l10n.phoneNumber,
                controller: _phoneController,
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 24),
              _buildInputField(
                label: l10n.homeAddress,
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
                    l10n.saveChanges,
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
                    l10n.cancel,
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
