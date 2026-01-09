import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/serviceprovider_data.dart';
import '../../modules/authentication/screens/login.dart';
import 'package:ra7a/l10n/app_localizations.dart';
import '../../cubits/language_cubit.dart';
import '../../services/api_service.dart';

class SettingsScreen extends StatefulWidget {
  final ServiceProvider provider;
  final Function(String)? onProfileUpdated;

  const SettingsScreen({
    super.key,
    required this.provider,
    this.onProfileUpdated,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileSection(),
            SizedBox(height: 16),
            _buildAccountSection(),
            SizedBox(height: 16),
            _buildNotificationsSection(),
            SizedBox(height: 16),
            _buildPreferencesSection(),
            SizedBox(height: 16),
            _buildSupportSection(),
            SizedBox(height: 16),
            _buildDangerZone(),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
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
            // 1. Load the image if the URL exists and is not empty
            backgroundImage:
                (widget.provider.profileImageUrl != null &&
                    widget.provider.profileImageUrl!.isNotEmpty)
                ? NetworkImage(widget.provider.profileImageUrl!)
                : null,
            // 2. Show the Icon ONLY if the image is missing (fallback)
            child:
                (widget.provider.profileImageUrl == null ||
                    widget.provider.profileImageUrl!.isEmpty)
                ? Icon(Icons.person, size: 40, color: Color(0xFF68E36C))
                : null,
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.provider.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  widget.provider.profession,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  widget.provider.location,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.edit, color: Colors.white, size: 20),
        ],
      ),
    );
  }

  Widget _buildAccountSection() {
    final l10n = AppLocalizations.of(context);

    return _buildSection(
      title: l10n.account,
      children: [
        _buildDivider(),
        _buildSettingsTile(
          icon: Icons.lock_outline,
          title: l10n.changePassword,
          subtitle: l10n.updatePassword,
          onTap: _showChangePasswordDialog,
        ),
        _buildDivider(),
        _buildSettingsTile(
          icon: Icons.verified_user_outlined,
          title: l10n.verification,
          subtitle: l10n.verifyAccount,
          trailing: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Color(0xFF68E36C).withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              l10n.verified,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF68E36C),
              ),
            ),
          ),
          onTap: () => _showComingSoon(l10n.verification),
        ),
      ],
    );
  }

  Widget _buildNotificationsSection() {
    final l10n = AppLocalizations.of(context);

    return _buildSection(
      title: l10n.notifications,
      children: [
        _buildSwitchTile(
          icon: Icons.notifications_outlined,
          title: l10n.pushNotifications,
          subtitle: l10n.receivePushNotifications,
          value: _notificationsEnabled,
          onChanged: (value) {
            setState(() {
              _notificationsEnabled = value;
            });
          },
        ),
        _buildDivider(),
        _buildSwitchTile(
          icon: Icons.email_outlined,
          title: l10n.emailNotifications,
          subtitle: l10n.receiveEmailNotifications,
          value: _emailNotifications,
          onChanged: (value) {
            setState(() {
              _emailNotifications = value;
            });
          },
        ),
        _buildDivider(),
        _buildSwitchTile(
          icon: Icons.sms_outlined,
          title: l10n.smsNotifications,
          subtitle: l10n.receiveSmsNotifications,
          value: _smsNotifications,
          onChanged: (value) {
            setState(() {
              _smsNotifications = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildPreferencesSection() {
    final l10n = AppLocalizations.of(context);

    return _buildSection(
      title: l10n.preferences,
      children: [
        _buildSwitchTile(
          icon: Icons.dark_mode_outlined,
          title: l10n.darkMode,
          subtitle: l10n.enableDarkTheme,
          value: _darkMode,
          onChanged: (value) {
            setState(() {
              _darkMode = value;
            });
          },
        ),
        _buildDivider(),
        BlocBuilder<LanguageCubit, LanguageState>(
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

            return _buildSettingsTile(
              icon: Icons.language_outlined,
              title: l10n.language,
              subtitle: currentLanguage,
              onTap: () => _showLanguageDialog(),
            );
          },
        ),
        _buildDivider(),
        _buildSettingsTile(
          icon: Icons.location_on_outlined,
          title: l10n.serviceArea,
          subtitle: widget.provider.location,
          onTap: () => _showComingSoon(l10n.serviceArea),
        ),
      ],
    );
  }

  Widget _buildSupportSection() {
    final l10n = AppLocalizations.of(context);

    return _buildSection(
      title: l10n.supportAbout,
      children: [
        _buildSettingsTile(
          icon: Icons.help_outline,
          title: l10n.helpCenter,
          subtitle: l10n.getHelpSupport,
          onTap: () => _showComingSoon(l10n.helpCenter),
        ),
        _buildDivider(),
        _buildSettingsTile(
          icon: Icons.privacy_tip_outlined,
          title: l10n.privacyPolicy,
          subtitle: l10n.readPrivacyPolicy,
          onTap: () => _showComingSoon(l10n.privacyPolicy),
        ),
        _buildDivider(),
        _buildSettingsTile(
          icon: Icons.description_outlined,
          title: l10n.termsOfService,
          subtitle: l10n.readTermsOfService,
          onTap: () => _showComingSoon(l10n.termsOfService),
        ),
        _buildDivider(),
        _buildSettingsTile(
          icon: Icons.info_outline,
          title: l10n.about,
          subtitle: l10n.version,
          onTap: () => _showComingSoon(l10n.about),
        ),
      ],
    );
  }

  Widget _buildDangerZone() {
    final l10n = AppLocalizations.of(context);

    return _buildSection(
      title: l10n.dangerZone,
      children: [
        _buildSettingsTile(
          icon: Icons.logout,
          title: l10n.logout,
          subtitle: l10n.signOutAccount,
          textColor: Colors.orange,
          onTap: () => _showLogoutDialog(),
        ),
        _buildDivider(),
        _buildSettingsTile(
          icon: Icons.delete_outline,
          title: l10n.deleteAccount,
          subtitle: l10n.permanentlyDeleteAccount,
          textColor: Colors.red,
          onTap: () => _showDeleteDialog(),
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
              letterSpacing: 0.5,
            ),
          ),
        ),
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
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (textColor ?? Color(0xFF68E36C)).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: textColor ?? Color(0xFF68E36C),
                size: 22,
              ),
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
                      fontWeight: FontWeight.w600,
                      color: textColor ?? Colors.black87,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            trailing ?? Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0xFF68E36C).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
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
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Color(0xFF68E36C),
            activeTrackColor: Color(0xFF68E36C).withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(height: 1, color: Colors.grey[200]),
    );
  }

  void _showLanguageDialog() {
    final l10n = AppLocalizations.of(context);
    final parentContext = context;

    showDialog(
      context: context,
      builder: (dialogContext) => BlocBuilder<LanguageCubit, LanguageState>(
        bloc: parentContext.read<LanguageCubit>(),
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildLanguageOption(
                  context: parentContext,
                  dialogContext: dialogContext,
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
    final l10n = AppLocalizations.of(context);

    return InkWell(
      onTap: () {
        context.read<LanguageCubit>().changeLanguage(languageCode);
        Navigator.pop(dialogContext);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.languageChangedTo} $languageName'),
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
            Text(icon, style: TextStyle(fontSize: 24)),
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
              Icon(Icons.check_circle, color: Color(0xFF68E36C), size: 24),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(String feature) {
    final l10n = AppLocalizations.of(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature - ${l10n.comingSoon}'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _showLogoutDialog() {
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
              ApiService().logout();
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

  void _showDeleteDialog() {
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l10n.deleteAccount),
        content: Text(l10n.deleteAccountConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteAccount();
            },
            child: Text(l10n.delete, style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l10n.changePassword),
        content: TextField(
          controller: controller,
          obscureText: true,
          decoration: InputDecoration(hintText: l10n.changePassword),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _changePassword(controller.text);
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    ).then((_) => controller.dispose());
  }

  Future<void> _changePassword(String newPassword) async {
    final l10n = AppLocalizations.of(context);
    final trimmed = newPassword.trim();
    if (trimmed.isEmpty) return;

    try {
      await ApiService().changePassword(newPassword: trimmed);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.passwordUpdatedSuccess)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
      );
    }
  }

  Future<void> _deleteAccount() async {
    try {
      await ApiService().deleteAccount();
      await ApiService().logout();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
