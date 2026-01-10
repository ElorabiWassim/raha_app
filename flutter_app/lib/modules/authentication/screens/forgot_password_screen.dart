import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ra7a/core/config/backend_config.dart';
import 'package:ra7a/data/remote/auth_api.dart';

import 'reset_password_screen.dart';

const primaryColor = Color(0xFF33AD04);
const textDark = Color(0xFF101C0D);

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key, this.prefilledEmail});

  final String? prefilledEmail;

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final initialEmail = (widget.prefilledEmail ?? '').trim();
    if (initialEmail.isNotEmpty) {
      _emailController.text = initialEmail;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _loading = true);

    try {
      final api = AuthApi(baseUrl: BackendConfig.baseUrl);
      final resp = await api.requestPasswordReset(
        email: _emailController.text.trim(),
      );

      final token = resp['token'] as String?;

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            resp['message']?.toString() ??
                'If an account exists, a reset token has been sent.',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: primaryColor,
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResetPasswordScreen(prefilledToken: token),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString(), style: GoogleFonts.poppins()),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    InputDecoration inputDecoration({
      required String label,
      required String hint,
    }) {
      return InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: textDark),
        floatingLabelStyle: GoogleFonts.poppins(
          color: primaryColor,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primaryColor.withValues(alpha: .5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
      );
    }

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
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text('Forgot Password', style: GoogleFonts.poppins()),
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
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
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 40,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Enter your email to receive a reset token.',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: textDark,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        cursorColor: primaryColor,
                        keyboardType: TextInputType.emailAddress,
                        decoration: inputDecoration(
                          label: 'Email',
                          hint: 'Enter your email',
                        ),
                        validator: (v) {
                          final value = (v ?? '').trim();
                          if (value.isEmpty) return 'Email is required';
                          final emailRegex = RegExp(
                            r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                          );
                          if (!emailRegex.hasMatch(value)) {
                            return 'Email must be valid';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            disabledBackgroundColor: primaryColor.withValues(
                              alpha: .6,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                            shadowColor: primaryColor.withValues(alpha: .3),
                          ),
                          child: _loading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Text(
                                  'Send reset token',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
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
      ),
    );
  }
}
