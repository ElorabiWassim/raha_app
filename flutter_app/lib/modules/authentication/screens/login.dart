import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get_it/get_it.dart';
import 'package:ra7a/l10n/app_localizations.dart';
import 'package:ra7a/presentation/screens/bottomNavbar.dart';
import 'role_selection_screen.dart';
import 'package:ra7a/presentation/screens/dashboard.dart';
import 'package:ra7a/presentation/screens/homesp.dart';
import 'package:ra7a/modules/authentication/screens/splash.dart';
import 'package:ra7a/cubits/dashboard_cubit.dart';
import 'package:ra7a/services/api_service.dart'; // ADD THIS IMPORT

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isLoading = false; // ADD THIS
  bool _isGoogleLoading = false;
  final TextEditingController _emailController =
      TextEditingController(); // CHANGED FROM username
  final TextEditingController _passwordController = TextEditingController();
  final ApiService _apiService = ApiService(); // ADD THIS

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // REPLACE _handleLogin with this:
  Future<void> _handleLogin() async {
    final localizations = AppLocalizations.of(context);

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    setState(() {
      _isLoading = true;
    });

    try {
      // Call backend login API
      final response = await _apiService.login(
        email: email,
        password: password,
      );

      // Get user role from response
      final user = response['user'] as Map<String, dynamic>?;
      final role = user?['role'] as String? ?? 'homeowner';
      final fullName =
          user?['full_name'] as String? ?? user?['email'] as String? ?? email;

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${localizations.loginWelcomeBack}, $fullName!',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: const Color(0xFF33AD04),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );

        // Navigate based on role
        if (role == 'homeowner') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeBottomNav()),
          );
        } else if (role == 'service_provider') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MainNavigationScreen(),
            ),
          );
        } else if (role == 'admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) =>
                    GetIt.instance<DashboardCubit>()..refreshStats(),
                child: const DashboardPage(),
              ),
            ),
          );
        } else {
          throw Exception('Unknown role');
        }
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString().replaceAll('Exception: ', ''),
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleGoogleLogin() async {
    final localizations = AppLocalizations.of(context);

    setState(() {
      _isGoogleLoading = true;
    });

    try {
      final serverClientId = const String.fromEnvironment(
        'GOOGLE_SERVER_CLIENT_ID',
        defaultValue: '',
      );

      if (serverClientId.isEmpty) {
        throw Exception(
          'Missing GOOGLE_SERVER_CLIENT_ID. Run: flutter run --dart-define=GOOGLE_SERVER_CLIENT_ID=YOUR_WEB_CLIENT_ID',
        );
      }

      final googleSignIn = GoogleSignIn(
        serverClientId: serverClientId,
        scopes: const ['email', 'profile'],
      );

      final account = await googleSignIn.signIn();
      if (account == null) return; // cancelled

      final auth = await account.authentication;
      final idToken = auth.idToken;
      if (idToken == null || idToken.isEmpty) {
        throw Exception(
          'Google idToken is null. Check that GOOGLE_SERVER_CLIENT_ID is the Web client ID.',
        );
      }

      final response = await _apiService.googleAuth(idToken: idToken);

      final user = response['user'] as Map<String, dynamic>?;
      final role = user?['role'] as String?;
      final fullName =
          user?['full_name'] as String? ?? user?['email'] as String? ?? '';

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${localizations.loginWelcomeBack}, $fullName!',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: const Color(0xFF33AD04),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

      if (role == 'homeowner') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeBottomNav()),
        );
      } else if (role == 'service_provider') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
        );
      } else if (role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) =>
                  GetIt.instance<DashboardCubit>()..refreshStats(),
              child: const DashboardPage(),
            ),
          ),
        );
      } else {
        // If the backend says the user doesn't exist yet, send them to role selection.
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RoleSelectionScreen()),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceAll('Exception: ', ''),
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isGoogleLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
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
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              final materialApp = context
                                  .findAncestorWidgetOfExactType<MaterialApp>();
                              if (materialApp?.home != null) {
                                return materialApp!.home!;
                              }
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

                    // Email Field (CHANGED FROM USERNAME)
                    TextFormField(
                      controller: _emailController, // CHANGED
                      cursorColor: primaryColor,
                      keyboardType: TextInputType.emailAddress, // ADD THIS
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        final v = (value ?? '').trim();
                        if (v.isEmpty) return 'Email is required';
                        final emailRegex = RegExp(
                          r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                        );
                        if (!emailRegex.hasMatch(v))
                          return 'Email must be valid';
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Email', // CHANGED
                        labelStyle: GoogleFonts.poppins(color: textDark),
                        floatingLabelStyle: GoogleFonts.poppins(
                          color: primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        hintText: 'Enter your email', // CHANGED
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
                    TextFormField(
                      controller: _passwordController,
                      cursorColor: primaryColor,
                      obscureText: !_isPasswordVisible,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        final v = (value ?? '').trim();
                        if (v.isEmpty) return 'Password is required';
                        if (v.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) {
                        if (!_isLoading) _handleLogin();
                      },
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

                    // Login Button (WITH LOADING STATE)
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin, // CHANGED
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          disabledBackgroundColor: primaryColor.withValues(
                            alpha: .6,
                          ), // ADD THIS
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                          shadowColor: primaryColor.withValues(alpha: .3),
                        ),
                        child:
                            _isLoading // ADD THIS
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Text(
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
                        onPressed: _isGoogleLoading ? null : _handleGoogleLogin,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: primaryColor.withValues(alpha: .7),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          backgroundColor: Colors.white,
                        ),
                        child: _isGoogleLoading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Row(
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
      ),
    );
  }
}
