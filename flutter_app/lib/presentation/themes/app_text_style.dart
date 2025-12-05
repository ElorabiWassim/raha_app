import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  // Base text style - change font here to apply everywhere
  static TextStyle _baseStyle({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  // Heading styles
  static TextStyle get heading1 =>
      _baseStyle(fontSize: 28, fontWeight: FontWeight.w600, letterSpacing: 0.5);

  static TextStyle get heading2 =>
      _baseStyle(fontSize: 24, fontWeight: FontWeight.w600);

  static TextStyle get heading3 =>
      _baseStyle(fontSize: 20, fontWeight: FontWeight.w700);

  static TextStyle get heading4 => _baseStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.015,
  );

  static TextStyle get heading5 =>
      _baseStyle(fontSize: 16, fontWeight: FontWeight.bold);

  // Body text styles
  static TextStyle get bodyLarge =>
      _baseStyle(fontSize: 16, fontWeight: FontWeight.normal);

  static TextStyle get bodyMedium =>
      _baseStyle(fontSize: 14, fontWeight: FontWeight.normal);

  static TextStyle get bodySmall =>
      _baseStyle(fontSize: 13, fontWeight: FontWeight.normal);

  static TextStyle get bodyTiny =>
      _baseStyle(fontSize: 12, fontWeight: FontWeight.normal);

  // Button text styles
  static TextStyle get buttonLarge =>
      _baseStyle(fontSize: 15, fontWeight: FontWeight.w700);

  static TextStyle get buttonMedium =>
      _baseStyle(fontSize: 14, fontWeight: FontWeight.w600);

  static TextStyle get buttonSmall =>
      _baseStyle(fontSize: 13, fontWeight: FontWeight.w600);

  // Caption/Label styles
  static TextStyle get caption =>
      _baseStyle(fontSize: 12, fontWeight: FontWeight.w500);

  static TextStyle get label =>
      _baseStyle(fontSize: 14, fontWeight: FontWeight.w500);

  // Custom text style with color
  static TextStyle custom({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    return _baseStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }
}

// App Colors - for consistency
class AppColors {
  static const Color primary = Color(0xFF35AE04);
  static const Color primaryLight = Color(0xFF33AD04);
  static const Color primaryDark = Color(0xFF1D6302);

  static const Color textDark = Color(0xFF333333);
  static const Color textMedium = Color(0xFF52525B);
  static const Color textLight = Color(0xFF71717A);
  static const Color textHint = Color(0xFF9CA3AF);

  static const Color backgroundLight = Color(0xFFF4F4F5);
  static const Color backgroundWhite = Color(0xFFFFFFFF);

  static const Color border = Color(0xFFE4E4E7);
  static const Color borderLight = Color(0xFFE5E7EB);

  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Status colors
  static const Color statusPending = Color(0xFF1E40AF);
  static const Color statusPendingBg = Color(0xFFDBEAFE);

  static const Color statusInProgress = Color(0xFF9A3412);
  static const Color statusInProgressBg = Color(0xFFFFEDD5);

  static const Color statusCompleted = Color(0xFF065F46);
  static const Color statusCompletedBg = Color(0xFFD1FAE5);

  static const Color statusCancelled = Color(0xFF52525B);
  static const Color statusCancelledBg = Color(0xFFF4F4F5);

  static const Color statusUpcoming = Color(0xFF92400E);
  static const Color statusUpcomingBg = Color(0xFFFEF3C7);
}
