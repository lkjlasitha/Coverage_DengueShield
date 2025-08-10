import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback? onFinish;
  const SplashScreen({Key? key, this.onFinish}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  static const totalDuration = Duration(milliseconds: 4000);

  late Animation<double> shieldOpacity;
  late Animation<double> shieldScale;
  
  late Animation<double> progressBarOpacity;
  
  late Animation<double> progressFill;
  
  late Animation<double> fullLogoOpacity;
  late Animation<double> fullLogoScale;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(vsync: this, duration: totalDuration);

    shieldOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl, 
        curve: const Interval(0.0, 0.15, curve: Curves.easeOut)
      ),
    );

    shieldScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl, 
        curve: const Interval(0.0, 0.25, curve: Curves.elasticOut)
      ),
    );

    progressBarOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl, 
        curve: const Interval(0.20, 0.30, curve: Curves.easeOut)
      ),
    );

    progressFill = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl, 
        curve: const Interval(0.30, 0.60, curve: Curves.easeInOut)
      ),
    );

    fullLogoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl, 
        curve: const Interval(0.60, 0.80, curve: Curves.easeOut)
      ),
    );

    fullLogoScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl, 
        curve: const Interval(0.60, 0.90, curve: Curves.easeOutBack)
      ),
    );

    _ctrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 500), () {
          widget.onFinish?.call();
        });
      }
    });

    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Color get bgColor => const Color(0xFF4F46E5); 
  Color get progressBgColor => const Color(0xFF7B68EE); 
  Color get progressFillColor => const Color(0xFFFFCF42); 

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (context, child) {
            return Stack(
              children: [
                if (fullLogoOpacity.value < 0.1) 
                  Positioned(
                    top: screenWidth*0.5,
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Column(
                      children: [
                        Opacity(
                          opacity: shieldOpacity.value,
                          child: Transform.scale(
                            scale: shieldScale.value,
                            child: Image.asset(
                              'assets/splash_screen/img_1.png', 
                              width: 361,
                              height: 361,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      Opacity(
                        opacity: progressBarOpacity.value,
                        child: Center(
                          child: Container(
                            width: screenWidth * 0.6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: progressBgColor,
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: Stack(
                              children: [
                                Container(
                                  width: (screenWidth * 0.6) * progressFill.value,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: progressFillColor,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      ],
                    ),
                  ),
                Positioned(
                  top: screenWidth * 0.32,
                  left: 0,
                  right: 0,
                  child: Opacity(
                    opacity: fullLogoOpacity.value,
                    child: Transform.scale(
                      scale: fullLogoScale.value,
                      child: Center(
                        child: Image.asset(
                          'assets/splash_screen/img_2.png',
                          width: 469,
                          height: 469,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}