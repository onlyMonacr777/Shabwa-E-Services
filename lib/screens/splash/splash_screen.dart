import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:shabwa_e_services/screens/auth/login_screen.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _progressAnimation;
  int _splashCounter = 0;

  // 🔥 الألوان الحكومية 🟢
  static const Color primaryGreenDark = Color(0xFF022C22);
  static const Color primaryGreen = Color(0xFF047857);
  static const Color primaryGreenLight = Color(0xFF059669);
  static const Color emeraldLight = Color(0xFF10B981);
  static const Color white = Color(0xFFFFFFFF);

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<double>(begin: 50, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _progressAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeInOut),
      ),
    );

    _controller.forward();

    // 🔥 الانتقال للـ Home أو Login بعد 3.5 ثانية
    Future.delayed(const Duration(seconds: 3, milliseconds: 500), () {
      if (mounted) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              primaryGreenDark,
              primaryGreenDark,
              const Color(0xFF065F46),
              primaryGreen,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🔥 اللوجو
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      padding: const EdgeInsets.all(36),
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [white.withOpacity(0.2), white.withOpacity(0.1)],
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(color: white.withOpacity(0.6), width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: primaryGreenDark.withOpacity(0.7),
                            blurRadius: 60,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.account_balance,
                        size: 110,
                        color: white,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 60),

              // 🔥 العنوان
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.translate(
                      offset: Offset(0, _slideAnimation.value * 0.5),
                      child: Column(
                        children: [
                          Text(
                            'بوابة شبوة',
                            textDirection: TextDirection.rtl,
                            style: GoogleFonts.cairo(
                              fontSize: 44,
                              fontWeight: FontWeight.w900,
                              color: white,
                              height: 1.2,
                              shadows: [
                                Shadow(
                                  color: primaryGreenDark,
                                  offset: const Offset(0, 8),
                                  blurRadius: 24,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'الخدمات الحكومية الإلكترونية',
                            textDirection: TextDirection.rtl,
                            style: GoogleFonts.cairo(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: white.withOpacity(0.95),
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 80),

              // 🔥 Progress Bar
              AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _progressAnimation.value,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 60),
                      child: Column(
                        children: [
                          LinearProgressIndicator(
                            value: _progressAnimation.value,
                            backgroundColor: white.withOpacity(0.3),
                            valueColor: AlwaysStoppedAnimation<Color>(emeraldLight),
                            borderRadius: BorderRadius.circular(12),
                            minHeight: 12,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'جاري التحميل...',
                            style: GoogleFonts.cairo(
                              color: white.withOpacity(0.9),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }
}