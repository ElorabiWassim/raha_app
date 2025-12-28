import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ra7a/data/remote/auth_api.dart';
import 'package:ra7a/l10n/app_localizations.dart';
import 'package:ra7a/presentation/screens/bottomNavbar.dart';
import 'package:ra7a/services/api_service.dart';
import '../../../../logic/cubits/signup/signup_cubit.dart';
import '../../../../logic/cubits/signup/signup_state.dart';
import 'login.dart';
import 'splash.dart';

const primaryColor = Color(0xFF33AD04);
const textDark = Color(0xFF333333);

class HomeownerSignUpScreen extends StatelessWidget {
  const HomeownerSignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupCubit(
        authApi: AuthApi(
          baseUrl: const String.fromEnvironment(
            'BACKEND_BASE_URL',
            defaultValue: 'http://10.0.2.2:5000',
          ),
        ),
      ),
      child: const _HomeownerSignUpScreenContent(),
    );
  }
}

class _HomeownerSignUpScreenContent extends StatefulWidget {
  const _HomeownerSignUpScreenContent();

  @override
  State<_HomeownerSignUpScreenContent> createState() =>
      _HomeownerSignUpScreenContentState();
}

class _HomeownerSignUpScreenContentState
    extends State<_HomeownerSignUpScreenContent> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _acceptTerms = false;

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _neighborhoodController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? _selectedPropertyType;
  DateTime? _selectedDate;

  Future<void> _handleGoogleSignup() async {
    final localizations = AppLocalizations.of(context);
    try {
      final serverClientId = const String.fromEnvironment(
        'GOOGLE_SERVER_CLIENT_ID',
        defaultValue: '',
      );

      if (serverClientId.isEmpty) {
        throw Exception(
          'Missing GOOGLE_SERVER_CLIENT_ID. Run with --dart-define=GOOGLE_SERVER_CLIENT_ID=YOUR_WEB_CLIENT_ID',
        );
      }

      final googleSignIn = GoogleSignIn(
        serverClientId: serverClientId,
        scopes: const ['email', 'profile'],
      );

      final account = await googleSignIn.signIn();
      if (account == null) return; // user cancelled

      final auth = await account.authentication;
      final idToken = auth.idToken;
      if (idToken == null || idToken.isEmpty) {
        throw Exception(
          'Google idToken is null. Ensure you used the Web client ID as serverClientId and configured Google Sign-In correctly.',
        );
      }

      final api = ApiService();
      await api.googleAuth(
        idToken: idToken,
        role: 'homeowner',
        phoneNumber: _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
        homeAddress:
            (_cityController.text.trim().isEmpty &&
                _neighborhoodController.text.trim().isEmpty)
            ? null
            : '${_cityController.text.trim()}, ${_neighborhoodController.text.trim()}'
                  .trim(),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            localizations.loginWelcomeBack,
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: primaryColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeBottomNav()),
      );
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
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _neighborhoodController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  List<String> _getPropertyTypes(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return [
      localizations.signupPropertyTypeApartment,
      localizations.signupPropertyTypeVilla,
      localizations.signupPropertyTypeStudio,
    ];
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1995),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _handleSignup(BuildContext context) {
    if (_formKey.currentState!.validate() && _acceptTerms) {
      if (_selectedPropertyType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a property type')),
        );
        return;
      }

      context.read<SignupCubit>().signupHomeowner(
        fullName: _fullNameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        phone: _phoneController.text,
        city: _cityController.text,
        neighborhood: _neighborhoodController.text,
        propertyType: _selectedPropertyType,
      );
    } else if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept terms and conditions')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Theme(
      data: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: primaryColor,
          selectionColor: primaryColor.withValues(alpha: .3),
          selectionHandleColor: primaryColor,
        ),
      ),
      child: BlocListener<SignupCubit, SignupState>(
        listener: (context, state) {
          if (state is SignupSuccess) {
            // Navigate to home or login
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          } else if (state is SignupFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        child: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF5FFF0), Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),

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
                      const SizedBox(height: 16),

                      // Title
                      Text(
                        localizations.signupCreateAccount,
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: textDark,
                          letterSpacing: -0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),

                      // Full Name
                      _buildTextField(
                        context,
                        localizations.signupFullName,
                        Icons.person_outline,
                        localizations.signupFullNameHint,
                        controller: _fullNameController,
                        validator: (value) {
                          final v = (value ?? '').trim();
                          if (v.isEmpty)
                            return 'Please enter ${localizations.signupFullName}';
                          if (v.length < 2)
                            return 'Full name must be at least 2 characters';
                          return null;
                        },
                      ),

                      // Email
                      _buildTextField(
                        context,
                        localizations.signupEmail,
                        Icons.email_outlined,
                        localizations.signupEmailHint,
                        inputType: TextInputType.emailAddress,
                        controller: _emailController,
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
                      ),

                      // Date of Birth
                      _buildLabel(context, localizations.signupDateOfBirth),
                      GestureDetector(
                        onTap: () => _pickDate(context),
                        child: AbsorbPointer(
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFAEE599),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: .03),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 16),
                                Icon(
                                  Icons.calendar_today_outlined,
                                  color: Colors.grey[600],
                                  size: 22,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  _selectedDate == null
                                      ? localizations.signupDateHint
                                      : '${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.year}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: _selectedDate == null
                                        ? Colors.grey[400]
                                        : textDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Phone Number
                      _buildTextField(
                        context,
                        localizations.signupPhoneNumber,
                        Icons.phone_outlined,
                        localizations.signupPhoneNumberHint,
                        inputType: TextInputType.phone,
                        controller: _phoneController,
                        validator: (value) {
                          final v = (value ?? '').trim();
                          if (v.isEmpty) {
                            return 'Please enter ${localizations.signupPhoneNumber}';
                          }
                          final cleaned = v.replaceAll(RegExp(r'\s+'), '');
                          final phoneRegex = RegExp(r'^\+?[0-9]{8,15}$');
                          if (!phoneRegex.hasMatch(cleaned)) {
                            return 'Phone number must be valid';
                          }
                          return null;
                        },
                      ),

                      // City
                      _buildTextField(
                        context,
                        localizations.signupCity,
                        Icons.location_city_outlined,
                        localizations.signupCityHint,
                        controller: _cityController,
                      ),

                      // Neighborhood / Street
                      _buildTextField(
                        context,
                        localizations.signupNeighborhood,
                        Icons.signpost_outlined,
                        localizations.signupNeighborhoodHint,
                        controller: _neighborhoodController,
                      ),

                      // Use Current Location Button
                      Container(
                        width: double.infinity,
                        height: 56,
                        margin: const EdgeInsets.only(bottom: 16),
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // Get current location
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: primaryColor.withValues(alpha: .1),
                            side: const BorderSide(color: primaryColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(
                            Icons.my_location,
                            color: primaryColor,
                          ),
                          label: Text(
                            localizations.signupUseCurrentLocation,
                            style: GoogleFonts.poppins(
                              color: primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      // Property Type Dropdown
                      _buildLabel(context, localizations.signupPropertyType),
                      Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFAEE599)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: .03),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 16),
                            Icon(
                              Icons.home_outlined,
                              color: Colors.grey[600],
                              size: 22,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedPropertyType,
                                  hint: Text(
                                    localizations.signupSelectPropertyType,
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                  isExpanded: true,
                                  icon: Icon(
                                    Icons.expand_more,
                                    color: Colors.grey[600],
                                  ),
                                  items: _getPropertyTypes(context)
                                      .map(
                                        (type) => DropdownMenuItem(
                                          value: type,
                                          child: Text(
                                            type,
                                            style: GoogleFonts.poppins(),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) => setState(
                                    () => _selectedPropertyType = value,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Password
                      _buildPasswordField(
                        context,
                        localizations.signupPassword,
                        localizations.signupPasswordHint,
                        _obscurePassword,
                        () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                        controller: _passwordController,
                        validator: (value) {
                          final v = (value ?? '').trim();
                          if (v.isEmpty) return 'Password is required';
                          if (v.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),

                      // Confirm Password
                      _buildPasswordField(
                        context,
                        localizations.signupConfirmPassword,
                        localizations.signupConfirmPasswordHint,
                        _obscureConfirm,
                        () =>
                            setState(() => _obscureConfirm = !_obscureConfirm),
                        controller: _confirmPasswordController,
                        validator: (value) {
                          final v = (value ?? '').trim();
                          if (v.isEmpty) return 'Please confirm your password';
                          if (v != _passwordController.text)
                            return 'Passwords do not match';
                          return null;
                        },
                      ),

                      // Terms Checkbox
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: _acceptTerms,
                            activeColor: primaryColor,
                            onChanged: (val) =>
                                setState(() => _acceptTerms = val ?? false),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text.rich(
                                TextSpan(
                                  text: localizations.signupAcceptTerms,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                  children: [
                                    TextSpan(
                                      text: localizations
                                          .signupTermsAndConditions,
                                      style: GoogleFonts.poppins(
                                        color: primaryColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Sign Up Button
                      BlocBuilder<SignupCubit, SignupState>(
                        builder: (context, state) {
                          return SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
                              ),
                              onPressed: state is SignupLoading
                                  ? null
                                  : () => _handleSignup(context),
                              child: state is SignupLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(
                                      localizations.signupButton,
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 20),

                      // OR Divider
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.grey[300],
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              localizations.signupOr,
                              style: GoogleFonts.poppins(
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.grey[300],
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Google Sign Up Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.grey[300]!),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _handleGoogleSignup,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/google.svg',
                                height: 24,
                                width: 24,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                localizations.signupWithGoogle,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Already have account
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            localizations.signupAlreadyHaveAccount,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginScreen(),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              localizations.loginButton,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textDark,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context,
    String label,
    IconData icon,
    String placeholder, {
    TextInputType inputType = TextInputType.text,
    required TextEditingController controller,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(context, label),
        Container(
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFAEE599)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .03),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            cursorColor: primaryColor,
            keyboardType: inputType,
            style: GoogleFonts.poppins(fontSize: 16, color: textDark),
            validator:
                validator ??
                (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter $label';
                  }
                  return null;
                },
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
              prefixIcon: Icon(icon, color: Colors.grey[600], size: 22),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: primaryColor, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPasswordField(
    BuildContext context,
    String label,
    String placeholder,
    bool obscure,
    VoidCallback toggleVisibility, {
    required TextEditingController controller,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(context, label),
        Container(
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFAEE599)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .03),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            cursorColor: primaryColor,
            obscureText: obscure,
            style: GoogleFonts.poppins(fontSize: 16, color: textDark),
            validator:
                validator ??
                (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter $label';
                  }
                  return null;
                },
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
              prefixIcon: Icon(
                Icons.lock_outline,
                color: Colors.grey[600],
                size: 22,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.grey[600],
                  size: 22,
                ),
                onPressed: toggleVisibility,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: primaryColor, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
