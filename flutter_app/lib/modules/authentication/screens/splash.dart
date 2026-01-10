import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ra7a/cubits/language_cubit.dart';
import 'package:ra7a/l10n/app_localizations.dart';
import 'onboarding.dart'; // make sure this path is correct

class SplashScreen extends StatefulWidget {
  final Function(Locale)? onLocaleChanged;

  const SplashScreen({super.key, this.onLocaleChanged});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Locale? _selectedLocale;

  List<Map<String, dynamic>> _getLanguages(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return [
      {'code': 'en', 'name': localizations.languageEnglish, 'flag': '🇬🇧'},
      {'code': 'fr', 'name': localizations.languageFrench, 'flag': '🇫🇷'},
      {'code': 'ar', 'name': localizations.languageArabic, 'flag': '🇩🇿'},
    ];
  }

  void _selectLanguage(Locale locale) {
    setState(() {
      _selectedLocale = locale;
    });

    // Change the app language (source of truth is LanguageCubit)
    // Keep onLocaleChanged for backward-compat, but don't rely on it.
    try {
      context.read<LanguageCubit>().changeLanguage(locale.languageCode);
    } catch (_) {
      // If LanguageCubit isn't available for some reason, fallback to callback.
      if (widget.onLocaleChanged != null) {
        widget.onLocaleChanged!(locale);
      }
    }

    // Navigate to Onboarding after language selection
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OnboardingScreen()),
        );
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update selected locale when the app locale changes
    final currentLocale = Localizations.localeOf(context);
    if (_selectedLocale?.languageCode != currentLocale.languageCode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _selectedLocale = currentLocale;
          });
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialize with current locale if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final currentLocale = Localizations.localeOf(context);
        setState(() {
          _selectedLocale = currentLocale;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF33AD04);
    const textDark = Color(0xFF101C0D);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Logo
              Hero(
                tag: 'appLogo',
                child: ColorFiltered(
                  colorFilter: const ColorFilter.mode(
                    primaryColor,
                    BlendMode.srcIn,
                  ),
                  child: Image.asset(
                    'assets/logo/ra7a_logo.png',
                    width: 200,
                    height: 200,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Language Selection Title
              Builder(
                builder: (context) {
                  final localizations = AppLocalizations.of(context);
                  return Column(
                    children: [
                      Text(
                        localizations.chooseLanguage,
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: textDark,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 40),

              // Language Buttons
              Builder(
                builder: (context) {
                  final languages = _getLanguages(context);
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: languages.map((language) {
                        final isSelected =
                            _selectedLocale?.languageCode == language['code'];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _LanguageButton(
                            flag: language['flag'] as String,
                            name: language['name'] as String,
                            isSelected: isSelected,
                            onTap: () => _selectLanguage(
                              Locale(language['code'] as String),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),

              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageButton extends StatelessWidget {
  final String flag;
  final String name;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageButton({
    required this.flag,
    required this.name,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF33AD04);
    const textDark = Color(0xFF101C0D);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            decoration: BoxDecoration(
              color: isSelected
                  ? primaryColor
                  : Colors.white.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? primaryColor
                    : primaryColor.withValues(alpha: 0.3),
                width: isSelected ? 2 : 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? primaryColor.withValues(alpha: 0.3)
                      : Colors.black.withValues(alpha: 0.05),
                  blurRadius: isSelected ? 12 : 4,
                  offset: Offset(0, isSelected ? 4 : 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Flag Emoji
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withValues(alpha: 0.2)
                        : primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(flag, style: const TextStyle(fontSize: 28)),
                  ),
                ),

                const SizedBox(width: 16),

                // Language Name
                Expanded(
                  child: Text(
                    name,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: isSelected ? Colors.white : textDark,
                    ),
                  ),
                ),

                // Selection Indicator
                if (isSelected)
                  Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: primaryColor,
                      size: 16,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
