import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ra7a/l10n/app_localizations.dart';
import 'provider_signup_screen.dart';
import 'splash.dart';
import 'homeowner_signup_screen.dart'; // Import your homeowner sign-up screen

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    const primaryColor = Color(0xFF33AD04);
    const textDark = Color(0xFF101C0D);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE6F6E0), Color(0xFFFFFFFF), Color(0xFFF9FFF7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SplashScreen(),
                        ),
                      );
                    },
                    child: Hero(
                      tag: 'appLogo',
                      child: ColorFiltered(
                        colorFilter: const ColorFilter.mode(
                          primaryColor,
                          BlendMode.srcIn,
                        ),
                        child: Image.asset(
                          'assets/logo/ra7a_logo.png',
                          width: 130,
                          height: 130,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Title
                  Text(
                    localizations.roleSelectionTitle,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: textDark,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    localizations.roleSelectionSubtitle,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // --- Homeowner Button ---
                  AnimatedOpacity(
                    opacity: 1,
                    duration: const Duration(milliseconds: 600),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeownerSignUpScreen(),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(16),
                      splashColor: Colors.white24,
                      highlightColor: Colors.white10,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withValues(alpha: .3),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Image.asset(
                                'assets/icons/homeowner_icon.png',
                                fit: BoxFit.contain,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 18),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    localizations.roleHomeowner,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    localizations.roleHomeownerDescription,
                                    style: const TextStyle(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // --- Service Provider Button ---
                  AnimatedOpacity(
                    opacity: 1,
                    duration: const Duration(milliseconds: 800),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProviderSignUpScreen(),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(16),
                      splashColor: Colors.white24,
                      highlightColor: Colors.white10,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1D6302),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: .2),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Image.asset(
                                'assets/icons/provider_icon.png',
                                fit: BoxFit.contain,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 18),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    localizations.roleServiceProvider,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    localizations.roleServiceProviderDescription,
                                    style: const TextStyle(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 50),

                  // Back to Login
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 16,
                      color: primaryColor,
                    ),
                    label: Text(
                      localizations.roleSelectionBackToLogin,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: primaryColor,
                        letterSpacing: 0.3,
                      ),
                    ),
                    style: TextButton.styleFrom(foregroundColor: primaryColor),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
