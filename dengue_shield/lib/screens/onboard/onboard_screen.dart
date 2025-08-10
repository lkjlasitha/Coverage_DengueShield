import 'package:flutter/material.dart';
import 'package:dengue_shield/widgets/bottom_navigation_bar/bottom_navigation_bar.dart';

const _bgPurple = Color(0xFF4F46E5);
const _screenBg = Color(0xFFF5F7FA);

class OnboardWaveClipper extends CustomClipper<Path> {
  final int pageIndex;
  OnboardWaveClipper(this.pageIndex);

  @override
  Path getClip(Size size) {
    final p = Path();
    p.moveTo(0, 0);

    if (pageIndex == 0) {
      p.lineTo(0, 0);
      p.quadraticBezierTo(size.width * 0.38, 2, size.width * 0.6, 30);
      p.quadraticBezierTo(size.width * 0.75, 64, size.width, 18);
    } else if (pageIndex == 1) {
      p.lineTo(0, 44);
      p.quadraticBezierTo(size.width * 0.28, 6, size.width * 0.70, 64);
      p.quadraticBezierTo(size.width * 0.90, 86, size.width, 34);
    } else {
      p.lineTo(0, 36);
      p.quadraticBezierTo(size.width * 0.28, 48, size.width * 0.50, 24);
      p.quadraticBezierTo(size.width * 0.78, 2, size.width, 38);
    }

    p.lineTo(size.width, size.height);
    p.lineTo(0, size.height);
    p.close();
    return p;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardPage> _pages = const [
    _OnboardPage(
      image: 'assets/onboard_screens/screen_1.png',
      title: 'Stay Ahead of Dengue',
      subtitle: 'Get real-time alerts and predictions to protect your family and community.',
    ),
    _OnboardPage(
      image: 'assets/onboard_screens/screen_2.png',
      title: 'Join the Fight,\nBe a Hero',
      subtitle: 'Report mosquito breeding sites and join clean-up drives with just a few taps.',
    ),
    _OnboardPage(
      image: 'assets/onboard_screens/screen_3.png',
      title: 'Smarter Health.\nSafer Future.',
      subtitle: 'DengueShield uses AI to predict outbreaks so you can act early and stay safe.',
    ),
  ];

  void _goNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 380), curve: Curves.easeInOut);
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => CustomBottomNav()));
    }
  }

  void _skip() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => CustomBottomNav()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _screenBg,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned.fill(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (context, i) {
                  return Image.asset(
                    _pages[i].image,
                    fit: BoxFit.contain,
                    width: double.infinity,
                    alignment: Alignment.topCenter,
                  );
                },
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 380),
                child: ClipPath(
                  key: ValueKey(_currentPage),
                  clipper: OnboardWaveClipper(_currentPage),
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.45,
                    color: _bgPurple,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(28, 50, 28, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: Text(
                              _pages[_currentPage].title,
                              key: ValueKey(_currentPage.toString() + 'title'),
                              style: const TextStyle(
                                fontSize: 28,
                                height: 1.22,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: Text(
                              _pages[_currentPage].subtitle,
                              key: ValueKey(_currentPage.toString() + 'subtitle'),
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.45,
                                color: Colors.white.withOpacity(0.95),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          const Spacer(),
                          const SizedBox(height: 22),
                          Row(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(_pages.length, (i) {
                                  final bool active = i == _currentPage;
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 220),
                                    margin: const EdgeInsets.symmetric(horizontal: 5),
                                    height: 8,
                                    width: active ? 22 : 8,
                                    decoration: BoxDecoration(
                                      color: active ? Colors.white : Colors.white.withOpacity(0.36),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  );
                                }),
                              ),
                              const Spacer(),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 220),
                                switchInCurve: Curves.easeOut,
                                switchOutCurve: Curves.easeIn,
                                child: (_currentPage == _pages.length - 1)
                                    ? SizedBox(
                                        key: const ValueKey('start'),
                                        height: 54,
                                        child: ElevatedButton(
                                          onPressed: _goNext,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            foregroundColor: _bgPurple,
                                            elevation: 0,
                                            padding: const EdgeInsets.symmetric(horizontal: 22),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(14),
                                            ),
                                          ),
                                          child: const Text(
                                            'START',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16,
                                              letterSpacing: 0.6,
                                            ),
                                          ),
                                        ),
                                      )
                                    : GestureDetector(
                                        key: const ValueKey('arrow'),
                                        onTap: _goNext,
                                        child: Container(
                                          width: 58,
                                          height: 58,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.05),
                                                blurRadius: 8,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: const Icon(Icons.arrow_forward_rounded, color: _bgPurple, size: 28),
                                        ),
                                      ),
                              ),
                            ],
                          ),
                          SizedBox(height: MediaQuery.of(context).padding.bottom + 6),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // FOREGROUND: Skip button (always on top)
            Positioned(
              top: 12,
              right: 12,
              child: GestureDetector(
                onTap: _skip,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE6E6EA)),
                  ),
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2C2C2C),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardPage {
  final String image;
  final String title;
  final String subtitle;
  const _OnboardPage({
    required this.image,
    required this.title,
    required this.subtitle,
  });
}