import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ra7a/l10n/app_localizations.dart';
import '../../../../logic/cubits/splash/splash_cubit.dart';
import '../../../../logic/cubits/splash/splash_state.dart';
import './onboarding.dart';

class SplashScreen extends StatelessWidget {
  final Function(Locale)? onLocaleChanged;

  const SplashScreen({super.key, this.onLocaleChanged});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit(),
      child: _SplashScreenContent(onLocaleChanged: onLocaleChanged),
    );
  }
}

class _SplashScreenContent extends StatefulWidget {
  final Function(Locale)? onLocaleChanged;

  const _SplashScreenContent({this.onLocaleChanged});

  @override
  State<_SplashScreenContent> createState() => _SplashScreenContentState();
}

class _SplashScreenContentState extends State<_SplashScreenContent> {
  Locale? _selectedLocale;

  @override
  void initState() {
    super.initState();
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
  void didChangeDependencies() {
    super.didChangeDependencies();
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

  List<Map<String, dynamic>> _getLanguages(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return [
      {'code': 'en', 'name': localizations.languageEnglish, 'flag': '🇬🇧'},
      {'code': 'fr', 'name': localizations.languageFrench, 'flag': '🇫🇷'},
      {'code': 'ar', 'name': localizations.languageArabic, 'flag': '🇩🇿'},
    ];
  }

  void _selectLanguage(BuildContext context, Locale locale) {
    setState(() {
      _selectedLocale = locale;
    });

    if (widget.onLocaleChanged != null) {
      widget.onLocaleChanged!(locale);
    }

    // Use Cubit to handle navigation state
    // We add a small delay to let the UI update the selection before navigating
    Future.delayed(const Duration(milliseconds: 300), () {
      if (context.mounted) {
        context.read<SplashCubit>().completeSplash();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF33AD04);
    const textDark = Color(0xFF101C0D);

    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is SplashNavigateToOnboarding) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const OnboardingScreen()),
          );
        }
      },
      child: Scaffold(
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
                    final localizations = AppLocalizations.of(context)!;
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
                                context,
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
