import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ra7a/l10n/app_localizations.dart';
import 'package:ra7a/presentation/screens/bottomNavbar.dart';
import 'role_selection_screen.dart';
import 'package:ra7a/presentation/screens/dashboard.dart';
import 'package:ra7a/presentation/screens/homesp.dart';
import 'package:ra7a/modules/authentication/screens/splash.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final localizations = AppLocalizations.of(context)!;
    String username = _usernameController.text.trim().toLowerCase();

    // Route based on username
    Widget destinationPage;

    if (username == 'homeowner') {
      destinationPage = const HomeBottomNav();
    } else if (username == 'serviceprovider') {
      destinationPage = const MainNavigationScreen();
    } else if (username == 'admin') {
      destinationPage = const DashboardPage();
    } else {
      // Show error for invalid username
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            localizations.loginInvalidUsername,
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => destinationPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    const primaryColor = Color(0xFF33AD04);
    const textDark = Color(0xFF101C0D);

    return Theme(
      data: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: primaryColor,
          selectionColor: primaryColor.withValues(alpha: .3),
          selectionHandleColor: primaryColor,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE6F6E0), Color(0xFFFFFFFF)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  GestureDetector(
                    onTap: () {
                      // Navigate back to splash screen (home widget) which has the locale callback
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            // Get the MaterialApp's home widget
                            final materialApp = context.findAncestorWidgetOfExactType<MaterialApp>();
                            if (materialApp?.home != null) {
                              return materialApp!.home!;
                            }
                            // Fallback: create splash without callback (shouldn't happen)
                            return const SplashScreen();
                          },
                        ),
                        (route) => false,
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

                  const SizedBox(height: 18),

                  // Welcome Text
                  Text(
                    localizations.loginWelcomeBack,
                    style: GoogleFonts.poppins(
                      color: textDark,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Username Field (changed from Email)
                  TextField(
                    controller: _usernameController,
                    cursorColor: primaryColor,
                    decoration: InputDecoration(
                      labelText: localizations.loginUsername,
                      labelStyle: GoogleFonts.poppins(color: textDark),
                      floatingLabelStyle: GoogleFonts.poppins(
                        color: primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      hintText: localizations.loginUsernameHint,
                      hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: primaryColor.withValues(alpha: .5),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: primaryColor,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Password Field
                  TextField(
                    controller: _passwordController,
                    cursorColor: primaryColor,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: localizations.loginPassword,
                      labelStyle: GoogleFonts.poppins(color: textDark),
                      floatingLabelStyle: GoogleFonts.poppins(
                        color: primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      hintText: localizations.loginPasswordHint,
                      hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: primaryColor.withValues(alpha: .5),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: primaryColor,
                          width: 2,
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: primaryColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        localizations.loginForgotPassword,
                        style: GoogleFonts.poppins(
                          color: primaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        shadowColor: primaryColor.withValues(alpha: .3),
                      ),
                      child: Text(
                        localizations.loginButton,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Divider
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(
                          color: Colors.black26,
                          thickness: 1,
                          endIndent: 10,
                        ),
                      ),
                      Text(
                        localizations.loginOr,
                        style: GoogleFonts.poppins(
                          color: Colors.grey[700],
                          fontSize: 15,
                        ),
                      ),
                      const Expanded(
                        child: Divider(
                          color: Colors.black26,
                          thickness: 1,
                          indent: 10,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Google Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: primaryColor.withValues(alpha: .7),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        backgroundColor: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/google.svg',
                            height: 22,
                            width: 22,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            localizations.loginContinueWithGoogle,
                            style: GoogleFonts.poppins(
                              color: textDark,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Sign Up Link
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RoleSelectionScreen(),
                        ),
                      );
                    },
                    child: Text.rich(
                      TextSpan(
                        text: localizations.loginNoAccount,
                        style: GoogleFonts.poppins(
                          color: textDark,
                          fontSize: 15,
                        ),
                        children: [
                          TextSpan(
                            text: localizations.loginSignUp,
                            style: GoogleFonts.poppins(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
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
