import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shabwa_e_services/core/theme/app_theme.dart';
import 'package:shimmer/main.dart';
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
            MaterialPageRoute(builder: (_) => const MyHomePage(title: "l")),
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
          style: AppTheme.bodyMedium,
          textDirection: TextDirection.rtl,
        ),
        backgroundColor: _isAdmin ? AppTheme.adminYellowDark : AppTheme.primaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradient,
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
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.white.withOpacity(0.2), AppTheme.white.withOpacity(0.1)],
            ),
            shape: BoxShape.circle,
            border: Border.all(color: AppTheme.white.withOpacity(0.6), width: 3),
            boxShadow: [AppTheme.primaryShadow],
          ),
          child: Icon(
            Icons.account_balance,
            color: AppTheme.white,
            size: 45,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'الخدمات الحكومية',
          style: AppTheme.titleMedium.copyWith(
            shadows: [
              Shadow(
                color: AppTheme.primaryGreenDark,
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
          colors: [AppTheme.white.withOpacity(0.2), AppTheme.white.withOpacity(0.1)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.white.withOpacity(0.6), width: 2),
        boxShadow: [AppTheme.primaryShadow], // 🔥 من الثيم
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildUserTypeButton(
            title: 'مواطن',
            icon: Icons.person,
            color: AppTheme.primaryGreen,
            isSelected: !_isAdmin,
            onTap: () => setState(() => _isAdmin = false),
          ),
          _buildUserTypeButton(
            title: 'مشرف',
            icon: Icons.admin_panel_settings,
            color: AppTheme.adminYellowDark,
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
            color: isSelected ? AppTheme.white.withOpacity(0.6) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppTheme.white, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.white.withOpacity(isSelected ? 1.0 : 0.85),
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
          colors: [AppTheme.white.withOpacity(0.2), AppTheme.white.withOpacity(0.1)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.white.withOpacity(0.6), width: 2),
        boxShadow: [AppTheme.primaryShadow],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textDirection: TextDirection.rtl,
        style: AppTheme.bodyLarge.copyWith(fontSize: 18),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppTheme.caption.copyWith(fontSize: 16),
          prefixIcon: Icon(icon, color: AppTheme.white.withOpacity(0.8), size: 24),
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
        gradient: _isAdmin
            ? AppTheme.adminGradient
            : AppTheme.loginButtonGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _isAdmin
                ? AppTheme.adminYellowDark.withOpacity(0.6)
                : AppTheme.emeraldLight.withOpacity(0.7),
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
              child: CircularProgressIndicator(color: AppTheme.white, strokeWidth: 2.5),
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _isAdmin ? Icons.admin_panel_settings : Icons.login,
                  color: AppTheme.white,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'تسجيل الدخول',
                  style: AppTheme.bodyLarge.copyWith(
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
          style: AppTheme.caption.copyWith(fontSize: 16),
          textDirection: TextDirection.rtl,
        ),
        GestureDetector(
          onTap: () {},
          child: Text(
            'إنشاء حساب جديد',
            style: AppTheme.bodyMedium.copyWith(color: AppTheme.emeraldLight),
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