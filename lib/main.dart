import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:ra7a/pages/splash.dart';
// import 'package:ra7a/constants/app_text_style.dart'; // your file with AppTextStyles & AppColors

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ra7a',

      // theme: ThemeData(
      //   fontFamily: GoogleFonts.poppins().fontFamily,
      //   scaffoldBackgroundColor: AppColors.backgroundWhite,
      //   colorScheme: ColorScheme.fromSeed(
      //     seedColor: AppColors.primary,
      //     primary: AppColors.primary,
      //     secondary: AppColors.primaryLight,
      //   ),

      //   textTheme: TextTheme(
      //     displayLarge: AppTextStyles.heading1,
      //     displayMedium: AppTextStyles.heading2,
      //     displaySmall: AppTextStyles.heading3,
      //     headlineMedium: AppTextStyles.heading4,
      //     headlineSmall: AppTextStyles.heading5,
      //     bodyLarge: AppTextStyles.bodyLarge,
      //     bodyMedium: AppTextStyles.bodyMedium,
      //     bodySmall: AppTextStyles.bodySmall,
      //     labelLarge: AppTextStyles.buttonMedium,
      //   ),

      //   elevatedButtonTheme: ElevatedButtonThemeData(
      //     style: ElevatedButton.styleFrom(
      //       backgroundColor: AppColors.primary,
      //       textStyle: AppTextStyles.buttonMedium.copyWith(color: Colors.white),
      //       shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.circular(8),
      //       ),
      //     ),
      //   ),
      // ),
      home: const SplashScreen(),
    );
  }
}
