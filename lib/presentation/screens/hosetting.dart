import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/profile_data.dart';
import 'package:ra7a/l10n/app_localizations.dart';
import './profilehome.dart';
import '../../modules/authentication/screens/login.dart';
import '../../cubits/language_cubit.dart';

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

      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.profileUpdatedSuccess),
          backgroundColor: Color(0xFF68E36C),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
          l10n.settings,
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
            _buildSectionHeader(l10n.account),
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
                    title: l10n.editProfile,
                    onTap: _navigateToEditProfile,
                  ),
                  Divider(height: 1, thickness: 1, color: Colors.grey[200]),
                  _buildMenuItem(
                    icon: Icons.credit_card_outlined,
                    title: l10n.paymentMethods,
                    onTap: () {
                      //  Navigate to payment methods
                    },
                  ),
                  Divider(height: 1, thickness: 1, color: Colors.grey[200]),
                  _buildMenuItem(
                    icon: Icons.location_on_outlined,
                    title: l10n.myaddress,
                    onTap: () {
                      // Navigate to addresses
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            // PREFERENCES Section (with Language)
            _buildSectionHeader(l10n.preferences),
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
              child: BlocBuilder<LanguageCubit, LanguageState>(
                builder: (context, state) {
                  String currentLanguage;
                  switch (state.locale.languageCode) {
                    case 'en':
                      currentLanguage = l10n.english;
                      break;
                    case 'fr':
                      currentLanguage = l10n.french;
                      break;
                    case 'ar':
                      currentLanguage = l10n.arabic;
                      break;
                    default:
                      currentLanguage = l10n.english;
                  }

                  return _buildMenuItemWithSubtitle(
                    icon: Icons.language_outlined,
                    title: l10n.language,
                    subtitle: currentLanguage,
                    onTap: () => _showLanguageDialog(),
                  );
                },
              ),
            ),

            SizedBox(height: 24),

            _buildSectionHeader(l10n.notifications),
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
                    title: l10n.pushNotifications,
                    value: pushNotifications,
                    onChanged: (val) {
                      setState(() => pushNotifications = val);
                    },
                  ),
                  Divider(height: 1, thickness: 1, color: Colors.grey[200]),
                  _buildSwitchItem(
                    icon: Icons.email_outlined,
                    title: l10n.emailNotifications,
                    value: emailNotifications,
                    onChanged: (val) {
                      setState(() => emailNotifications = val);
                    },
                  ),
                  Divider(height: 1, thickness: 1, color: Colors.grey[200]),
                  _buildSwitchItem(
                    icon: Icons.sms_outlined,
                    title: l10n.smsNotifications,
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
                    title: l10n.changePassword,
                    onTap: () {},
                  ),
                  Divider(height: 1, thickness: 1, color: Colors.grey[200]),
                  _buildMenuItem(
                    icon: Icons.security_outlined,
                    title: l10n.tfa,
                    onTap: () {},
                  ),
                  Divider(height: 1, thickness: 1, color: Colors.grey[200]),
                  _buildMenuItem(
                    icon: Icons.privacy_tip_outlined,
                    title: l10n.privacyPolicy,
                    onTap: () {},
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            _buildSectionHeader(l10n.supportAbout),
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
                    title: l10n.helpCenter,
                    onTap: () {},
                  ),
                  Divider(height: 1, thickness: 1, color: Colors.grey[200]),
                  _buildMenuItem(
                    icon: Icons.headset_mic_outlined,
                    title: l10n.contactSupport,
                    onTap: () {},
                  ),
                  Divider(height: 1, thickness: 1, color: Colors.grey[200]),
                  _buildMenuItem(
                    icon: Icons.description_outlined,
                    title: l10n.termsOfService,
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
                    l10n.logout,
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
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItemWithSubtitle({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
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
            activeColor: Color(0xFF68E36C),
            activeTrackColor: Color(0xFF68E36C).withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    final l10n = AppLocalizations.of(context)!;
    // Save the parent context reference
    final parentContext = context;

    showDialog(
      context: context,
      builder: (dialogContext) => BlocBuilder<LanguageCubit, LanguageState>(
        bloc: parentContext.read<LanguageCubit>(), // Use bloc parameter
        builder: (_, state) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.language, color: Color(0xFF68E36C)),
                SizedBox(width: 12),
                Text(
                  l10n.changeLanguage,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildLanguageOption(
                  context: parentContext, // Use parent context
                  dialogContext: dialogContext, // Pass dialog context for closing
                  icon: '🇬🇧',
                  languageName: l10n.english,
                  languageCode: 'en',
                  isSelected: state.locale.languageCode == 'en',
                ),
                SizedBox(height: 8),
                _buildLanguageOption(
                  context: parentContext,
                  dialogContext: dialogContext,
                  icon: '🇫🇷',
                  languageName: l10n.french,
                  languageCode: 'fr',
                  isSelected: state.locale.languageCode == 'fr',
                ),
                SizedBox(height: 8),
                _buildLanguageOption(
                  context: parentContext,
                  dialogContext: dialogContext,
                  icon: '🇩🇿',
                  languageName: l10n.arabic,
                  languageCode: 'ar',
                  isSelected: state.locale.languageCode == 'ar',
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(
                  l10n.cancel,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required BuildContext dialogContext,
    required String icon,
    required String languageName,
    required String languageCode,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () {
        context.read<LanguageCubit>().changeLanguage(languageCode);
        Navigator.pop(dialogContext);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Language changed to $languageName'),
            backgroundColor: Color(0xFF68E36C),
            duration: Duration(seconds: 2),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? Color(0xFF68E36C).withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Color(0xFF68E36C) : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(
              icon,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                languageName,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? Color(0xFF68E36C) : Colors.black87,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Color(0xFF68E36C),
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(l10n.logout),
        content: Text(l10n.logoutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
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
            child: Text(l10n.logout, style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }
}