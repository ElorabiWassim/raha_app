import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ra7a/l10n/app_localizations.dart';
import '../../data/models/profile_data.dart';
import './profilehome.dart';
import '../../modules/authentication/screens/login.dart';
import '../../logic/cubits/auth/auth_cubit.dart';
import '../../logic/cubits/localization/localization_cubit.dart';
import '../../data/local/local_cache_repository.dart';

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
  late String _languageCode;

  @override
  void initState() {
    super.initState();
    currentProfileData = widget.profileData;
    _languageCode = context.read<LocalizationCubit>().state.locale.languageCode;
  }

  String _languageName(String code, AppLocalizations l10n) {
    switch (code) {
      case 'fr':
        return l10n.languageFrench;
      case 'ar':
        return l10n.languageArabic;
      default:
        return l10n.languageEnglish;
    }
  }

  Future<void> _changeLanguage(String code) async {
    if (_languageCode == code) return;
    setState(() => _languageCode = code);
    context.read<LocalizationCubit>().changeLanguage(code);

    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      await context.read<LocalCacheRepository>().saveUserLanguage(
        authState.userId,
        code,
      );
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.profileLanguageChanged),
        ),
      );
    }
  }

  void _showLanguageSheet() {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.language_outlined),
                title: Text(l10n.languageEnglish),
                trailing: _languageCode == 'en'
                    ? const Icon(Icons.check)
                    : null,
                onTap: () {
                  Navigator.pop(context);
                  _changeLanguage('en');
                },
              ),
              ListTile(
                leading: const Icon(Icons.language_outlined),
                title: Text(l10n.languageFrench),
                trailing: _languageCode == 'fr'
                    ? const Icon(Icons.check)
                    : null,
                onTap: () {
                  Navigator.pop(context);
                  _changeLanguage('fr');
                },
              ),
              ListTile(
                leading: const Icon(Icons.language_outlined),
                title: Text(l10n.languageArabic),
                trailing: _languageCode == 'ar'
                    ? const Icon(Icons.check)
                    : null,
                onTap: () {
                  Navigator.pop(context);
                  _changeLanguage('ar');
                },
              ),
            ],
          ),
        );
      },
    );
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
          content: Text(AppLocalizations.of(context)!.profileLanguageChanged),
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
          l10n.profileSettings,
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
            _buildSectionHeader(l10n.profileTitle),
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
                    title: l10n.settingsEditProfile,
                    onTap: _navigateToEditProfile,
                  ),
                  Divider(height: 1, thickness: 1, color: Colors.grey[200]),
                  _buildMenuItem(
                    icon: Icons.language_outlined,
                    title: l10n.profileLanguage,
                    subtitle: _languageName(_languageCode, l10n),
                    onTap: _showLanguageSheet,
                  ),
                  Divider(height: 1, thickness: 1, color: Colors.grey[200]),
                  _buildMenuItem(
                    icon: Icons.credit_card_outlined,
                    title: l10n.settingsPaymentMethods,
                    onTap: () {
                      //  Navigate to payment methods
                    },
                  ),
                  Divider(height: 1, thickness: 1, color: Colors.grey[200]),
                  _buildMenuItem(
                    icon: Icons.location_on_outlined,
                    title: l10n.settingsMyAddresses,
                    onTap: () {
                      // Navigate to addresses
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),
            _buildSectionHeader(l10n.settingsNotifications),
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
                    title: l10n.settingsPushNotifications,
                    value: pushNotifications,
                    onChanged: (val) {
                      setState(() => pushNotifications = val);
                    },
                  ),
                  Divider(height: 1, thickness: 1, color: Colors.grey[200]),
                  _buildSwitchItem(
                    icon: Icons.email_outlined,
                    title: l10n.settingsEmailNotifications,
                    value: emailNotifications,
                    onChanged: (val) {
                      setState(() => emailNotifications = val);
                    },
                  ),
                  Divider(height: 1, thickness: 1, color: Colors.grey[200]),
                  _buildSwitchItem(
                    icon: Icons.sms_outlined,
                    title: l10n.settingsSMSNotifications,
                    value: smsNotifications,
                    onChanged: (val) {
                      setState(() => smsNotifications = val);
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            _buildSectionHeader(l10n.settingsSecurity),
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
                    title: l10n.settingsChangePassword,
                    onTap: () {},
                  ),
                  Divider(height: 1, thickness: 1, color: Colors.grey[200]),
                  _buildMenuItem(
                    icon: Icons.security_outlined,
                    title: l10n.settingsTwoFactor,
                    onTap: () {},
                  ),
                  Divider(height: 1, thickness: 1, color: Colors.grey[200]),
                  _buildMenuItem(
                    icon: Icons.privacy_tip_outlined,
                    title: l10n.settingsPrivacyPolicy,
                    onTap: () {},
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            _buildSectionHeader(l10n.settingsSupport),
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
                    title: l10n.settingsHelpCenter,
                    onTap: () {},
                  ),
                  Divider(height: 1, thickness: 1, color: Colors.grey[200]),
                  _buildMenuItem(
                    icon: Icons.headset_mic_outlined,
                    title: l10n.settingsContactSupport,
                    onTap: () {},
                  ),
                  Divider(height: 1, thickness: 1, color: Colors.grey[200]),
                  _buildMenuItem(
                    icon: Icons.description_outlined,
                    title: l10n.settingsTermsOfService,
                    onTap: () {},
                  ),
                ],
              ),
            ),

            SizedBox(height: 32),

            // Delete Account Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _showDeleteAccountDialog,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.red.shade700, width: 2),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    l10n.settingsDeleteAccount,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.red.shade700,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 16),

            // Logout Button
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
                    l10n.settingsLogout,
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
    String? subtitle,
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
            if (subtitle != null)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  subtitle,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
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
        title: Text(AppLocalizations.of(context)!.settingsLogout),
        content: Text(AppLocalizations.of(context)!.settingsLogoutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.settingsCancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog

              // Call AuthCubit logout
              context.read<AuthCubit>().logout();

              // Navigate to login and clear all routes
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false,
              );
            },
            child: Text(
              AppLocalizations.of(context)!.settingsLogout,
              style: TextStyle(color: Colors.orange),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.settingsDeleteAccount),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.settingsDeleteAccountConfirm),
            SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.settingsDeleteAccountWarning,
              style: TextStyle(
                fontSize: 13,
                color: Colors.red.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.settingsCancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog

              // TODO: Call backend delete account API when ready
              // For now, just logout
              context.read<AuthCubit>().logout();

              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppLocalizations.of(context)!.settingsAccountDeleted,
                  ),
                  backgroundColor: Colors.red.shade700,
                ),
              );

              // Navigate to login
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false,
              );
            },
            child: Text(
              AppLocalizations.of(context)!.settingsDeleteAccount,
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
