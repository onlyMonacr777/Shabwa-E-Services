import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../home/home_screen.dart';
import '../admin/admin_dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  bool _isAdmin = false;
  bool _isLoading = false;
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // 🔥 نفس ألوان الـ Splash بالضبط 🟢
  static const Color primaryGreenDark = Color(0xFF022C22);
  static const Color primaryGreen = Color(0xFF047857);
  static const Color primaryGreenLight = Color(0xFF059669);
  static const Color emeraldLight = Color(0xFF10B981);
  static const Color white = Color(0xFFFFFFFF);
  static const Color emeraldDark = Color(0xFF065F46);
  static const Color primaryGreenExtraDark = Color(0xFF013A2E);

  // 🔥 ألوان المشرف (مُحسَّنة لتتناسب مع الـ Splash)
  static const Color adminYellowDark = Color(0xFFF59D26);
  static const Color adminOrange = Color(0xFFEA7D1A);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _animationController.forward();
  }

  Future<void> _login() async {
    if (_phoneController.text.isEmpty || _passwordController.text.isEmpty) {
      _showSnackBar('يرجى إدخال جميع البيانات');
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => _isLoading = false);

      if (_isAdmin) {
        if (_phoneController.text == 'admin' && _passwordController.text == '123456') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const AdminDashboard()),
          );
        } else {
          _showSnackBar('بيانات المشرف غير صحيحة');
        }
      } else {
        if (_phoneController.text == '966501234567' && _passwordController.text == '123456') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        } else {
          _showSnackBar('رقم الهاتف أو كلمة المرور غير صحيحة');
        }
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.cairo(fontWeight: FontWeight.w600),
          textDirection: TextDirection.rtl,
        ),
        backgroundColor: _isAdmin ? adminYellowDark : primaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // 🔥 نفس الـ Gradient من الـ Splash بالضبط
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              primaryGreenExtraDark,
              primaryGreenDark,
              primaryGreenDark,
              const Color(0xFF065F46),
              primaryGreen,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    _buildHeader(),
                    const SizedBox(height: 40),
                    _buildUserTypeSelector(),
                    const SizedBox(height: 32),
                    _buildLoginForm(),
                    const SizedBox(height: 24),
                    _buildRegisterLink(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // 🔥 نفس اللوجو بس أصغر شوية
        Container(
          width: 90,
          height: 90,
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
            color: white,
            size: 45,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'الخدمات الحكومية',
          style: GoogleFonts.cairo(
            fontSize: 22,
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
          textDirection: TextDirection.rtl,
        ),
      ],
    );
  }

  Widget _buildUserTypeSelector() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [white.withOpacity(0.2), white.withOpacity(0.1)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: white.withOpacity(0.6), width: 2),
        boxShadow: [
          BoxShadow(
            color: primaryGreenDark.withOpacity(0.7),
            blurRadius: 60,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildUserTypeButton(
            title: 'مواطن',
            icon: Icons.person,
            color: primaryGreen,
            isSelected: !_isAdmin,
            onTap: () => setState(() => _isAdmin = false),
          ),
          _buildUserTypeButton(
            title: 'مشرف',
            icon: Icons.admin_panel_settings,
            color: adminYellowDark,
            isSelected: _isAdmin,
            onTap: () => setState(() => _isAdmin = true),
          ),
        ],
      ),
    );
  }

  Widget _buildUserTypeButton({
    required String title,
    required IconData icon,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(colors: [color.withOpacity(0.3), color.withOpacity(0.1)])
              : null,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? white.withOpacity(0.6) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: white, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.cairo(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: white.withOpacity(isSelected ? 1.0 : 0.85),
              ),
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      children: [
        _buildTextField(
          controller: _phoneController,
          label: 'رقم الهاتف',
          icon: Icons.phone,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 20),
        _buildTextField(
          controller: _passwordController,
          label: 'كلمة المرور',
          icon: Icons.lock_outline,
          obscureText: true,
        ),
        const SizedBox(height: 32),
        _buildLoginButton(),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [white.withOpacity(0.2), white.withOpacity(0.1)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: white.withOpacity(0.6), width: 2),
        boxShadow: [
          BoxShadow(
            color: primaryGreenDark.withOpacity(0.7),
            blurRadius: 60,
            spreadRadius: 0,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textDirection: TextDirection.rtl,
        style: GoogleFonts.cairo(color: white, fontSize: 18),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.cairo(
            color: white.withOpacity(0.7),
            fontSize: 16,
          ),
          prefixIcon: Icon(icon, color: white.withOpacity(0.8), size: 24),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          filled: true,
          fillColor: Colors.transparent,
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _isAdmin
              ? [adminOrange, adminYellowDark]
              : [primaryGreenDark, primaryGreen],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _isAdmin ? adminYellowDark.withOpacity(0.6) : emeraldLight.withOpacity(0.7),
            blurRadius: 25,
            offset: const Offset(0, 10),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: _isLoading ? null : _login,
          splashColor: Colors.white.withOpacity(0.3),
          child: Center(
            child: _isLoading
                ? const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(color: white, strokeWidth: 2.5),
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(_isAdmin ? Icons.admin_panel_settings : Icons.login,
                    color: white, size: 24),
                const SizedBox(width: 12),
                Text(
                  'تسجيل الدخول',
                  style: GoogleFonts.cairo(
                    color: white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'ليس لديك حساب؟ ',
          style: GoogleFonts.cairo(
            color: white.withOpacity(0.8),
            fontSize: 16,
          ),
          textDirection: TextDirection.rtl,
        ),
        GestureDetector(
          onTap: () {},
          child: Text(
            'إنشاء حساب جديد',
            style: GoogleFonts.cairo(
              color: emeraldLight,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}