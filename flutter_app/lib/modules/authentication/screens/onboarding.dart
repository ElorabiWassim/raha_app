import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ra7a/l10n/app_localizations.dart';
import '../../../../logic/cubits/onboarding/onboarding_cubit.dart';
import '../../../../logic/cubits/onboarding/onboarding_state.dart';
import 'login.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingCubit(),
      child: const _OnboardingScreenContent(),
    );
  }
}

class _OnboardingScreenContent extends StatefulWidget {
  const _OnboardingScreenContent();

  @override
  State<_OnboardingScreenContent> createState() =>
      _OnboardingScreenContentState();
}

class _OnboardingScreenContentState extends State<_OnboardingScreenContent> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  List<Map<String, String>> _slides(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return [
      {
        "title": t.onboardingTitle1,
        "subtitle": t.onboardingSubtitle1,
        "lottie": "assets/animations/Plumbers.json",
      },
      {
        "title": t.onboardingTitle2,
        "subtitle": t.onboardingSubtitle2,
        "lottie": "assets/animations/Painter.json",
      },
      {
        "title": t.onboardingTitle3,
        "subtitle": t.onboardingSubtitle3,
        "lottie": "assets/animations/Gardener.json",
      },
    ];
  }

  void _nextPage(BuildContext context) {
    final total = _slides(context).length;
    if (_currentIndex < total - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    } else {
      context.read<OnboardingCubit>().completeOnboarding();
    }
  }

  void _skip(BuildContext context) {
    context.read<OnboardingCubit>().completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final slides = _slides(context);

    return BlocListener<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingCompleted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0x1A33AD04), Color(0xFFFFFFFF)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      // PageView
                      PageView.builder(
                        controller: _pageController,
                        itemCount: slides.length,
                        onPageChanged: (index) {
                          setState(() => _currentIndex = index);
                          context.read<OnboardingCubit>().pageChanged(index);
                        },
                        itemBuilder: (context, index) {
                          final slide = slides[index];
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(child: Lottie.asset(slide["lottie"]!)),
                              const SizedBox(height: 16),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                child: Text(
                                  slide["title"]!,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black87,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                child: Text(
                                  slide["subtitle"]!,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black54,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 80), // Space for dots
                            ],
                          );
                        },
                      ),

                      // Fixed position dots
                      Positioned(
                        bottom: 24,
                        left: 0,
                        right: 0,
                        child: BlocBuilder<OnboardingCubit, OnboardingState>(
                          builder: (context, state) {
                            int activeIndex = _currentIndex;
                            if (state is OnboardingPageChanged) {
                              activeIndex = state.index;
                            }
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                slides.length,
                                (i) => AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  width: i == activeIndex ? 20 : 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: i == activeIndex
                                        ? const Color(0xFF33AD04)
                                        : const Color(0x5533AD04),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => _skip(context),
                        child: Text(
                          t.onboardingSkip,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _nextPage(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF33AD04),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                          shadowColor: const Color(0x5533AD04),
                        ),
                        child: Text(
                          t.onboardingNext,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
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
    );
  }
}
