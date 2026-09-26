import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/lumora_image.dart';
import '../main_layout.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingItem> _pages = [
    _OnboardingItem(
      title: 'Find Your\nSignature Style',
      subtitle: 'Curated accessories and bespoke fine jewellery crafted to resonate with your unique presence.',
      imageUrl: 'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?auto=format&fit=crop&w=1000&q=80',
      badge: 'EXCLUSIVE ATELIER',
    ),
    _OnboardingItem(
      title: 'Jewellery That\nSpeaks For You',
      subtitle: 'Liquid gold herringbone chains, natural freshwater pearls, and conflict-free gemstones.',
      imageUrl: 'https://images.unsplash.com/photo-1630019852942-f89202989a59?auto=format&fit=crop&w=1000&q=80',
      badge: 'HANDCRAFTED LUXURY',
    ),
    _OnboardingItem(
      title: 'Everyday Essentials.\nElevated.',
      subtitle: 'Minimalist automatic timepieces, Italian leather bags, and unisex modern silhouettes.',
      imageUrl: 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&w=1000&q=80',
      badge: 'TIMELESS AESTHETICS',
    ),
  ];

  void _finishOnboarding() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, _, _) => const MainLayout(),
        transitionsBuilder: (_, animation, _, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: Stack(
        children: [
          // Background PageView
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              final page = _pages[index];
              return Stack(
                fit: StackFit.expand,
                children: [
                  // Image
                  Positioned.fill(
                    child: LumoraImage(
                      imageUrl: page.imageUrl,
                      borderRadius: 0,
                    ),
                  ),

                  // Gradient Scrim
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0.0, 0.45, 0.75, 1.0],
                          colors: [
                            (isDark ? Colors.black : Colors.black).withValues(alpha: 0.35),
                            Colors.transparent,
                            (isDark ? const Color(0xFF121110) : const Color(0xFF1B1918)).withValues(alpha: 0.85),
                            isDark ? const Color(0xFF121110) : const Color(0xFF1B1918),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Bottom Content Card
                  Positioned(
                    bottom: 120,
                    left: 24,
                    right: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.champagneGold.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: AppColors.champagneGold,
                              width: 0.8,
                            ),
                          ),
                          child: Text(
                            page.badge,
                            style: const TextStyle(
                              color: AppColors.champagneGoldLight,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Title
                        Text(
                          page.title,
                          style: AppTextStyles.heroHeading(isDark: true, fontSize: 32).copyWith(
                            color: Colors.white,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Subtitle
                        Text(
                          page.subtitle,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),

          // Top Header (Logo & Skip)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'HEERA',
                    style: AppTextStyles.brandLogo(fontSize: 20).copyWith(
                      color: Colors.white,
                      letterSpacing: 4.0,
                    ),
                  ),
                  TextButton(
                    onPressed: _finishOnboarding,
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Controls (Page Indicators & Action Buttons)
          Positioned(
            bottom: 34,
            left: 24,
            right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Indicators
                Row(
                  children: List.generate(_pages.length, (index) {
                    final isSel = _currentPage == index;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(right: 6),
                      width: isSel ? 24 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isSel ? AppColors.champagneGold : Colors.white30,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    );
                  }),
                ),

                // Button
                if (_currentPage == _pages.length - 1)
                  CustomButton(
                    text: 'GET STARTED',
                    type: ButtonType.gold,
                    width: 150,
                    height: 48,
                    borderRadius: 24,
                    onPressed: _finishOnboarding,
                  )
                else
                  GestureDetector(
                    onTap: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        gradient: AppColors.luxuryGoldGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingItem {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String badge;

  _OnboardingItem({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.badge,
  });
}
