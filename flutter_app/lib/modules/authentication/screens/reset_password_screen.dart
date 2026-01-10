import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ra7a/core/config/backend_config.dart';
import 'package:ra7a/data/remote/auth_api.dart';

const primaryColor = Color(0xFF33AD04);
const textDark = Color(0xFF101C0D);

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key, this.prefilledToken});

  final String? prefilledToken;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _tokenController;
  final _passwordController = TextEditingController();
  bool _loading = false;
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _tokenController = TextEditingController(text: widget.prefilledToken ?? '');
  }

  @override
  void dispose() {
    _tokenController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _loading = true);

    try {
      final api = AuthApi(baseUrl: BackendConfig.baseUrl);
      final resp = await api.resetPassword(
        token: _tokenController.text.trim(),
        newPassword: _passwordController.text,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            resp['message']?.toString() ?? 'Password has been reset.',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: primaryColor,
        ),
      );

      Navigator.pop(context);
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
      Widget? suffixIcon,
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
        suffixIcon: suffixIcon,
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
          title: Text('Reset Password', style: GoogleFonts.poppins()),
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
                        'Paste the reset token you received by email, then choose a new password.',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: textDark,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _tokenController,
                        cursorColor: primaryColor,
                        decoration: inputDecoration(
                          label: 'Reset token',
                          hint: 'Paste your reset token',
                        ),
                        validator: (v) {
                          final value = (v ?? '').trim();
                          if (value.isEmpty) return 'Token is required';
                          if (value.length < 20) return 'Token looks too short';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        cursorColor: primaryColor,
                        obscureText: _obscure,
                        decoration: inputDecoration(
                          label: 'New password',
                          hint: 'Enter your new password',
                          suffixIcon: IconButton(
                            onPressed: () =>
                                setState(() => _obscure = !_obscure),
                            icon: Icon(
                              _obscure
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: primaryColor,
                            ),
                          ),
                        ),
                        validator: (v) {
                          final value = (v ?? '');
                          if (value.trim().isEmpty) {
                            return 'New password is required';
                          }
                          if (value.length < 8) return 'Minimum 8 characters';
                          final strong = RegExp(
                            r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)',
                          );
                          if (!strong.hasMatch(value)) {
                            return 'Must include uppercase, lowercase, and a number';
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
                                  'Reset password',
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
