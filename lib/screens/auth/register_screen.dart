import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/core/theme/app_theme.dart'; //ربطت بالثيم الجديد
import '../home/home_screen.dart';
import '../admin/admin_dashboard.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  bool _isAdmin = false;
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

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

  Future<void> _register() async {
    if (_fullNameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      _showSnackBar('يرجى إدخال جميع البيانات');
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      _showSnackBar('كلمة المرور غير متطابقة');
      return;
    }

    if (_passwordController.text.length < 6) {
      _showSnackBar('كلمة المرور يجب أن تكون 6 أحرف على الأقل');
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => _isLoading = false);
      _showSnackBar(_isAdmin ? 'تم إنشاء حساب المشرف بنجاح' : 'تم إنشاء الحساب بنجاح');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTheme.bodyMedium, // 🔥 من الثيم
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
          gradient: AppTheme.primaryGradient, // 🔥 من الثيم
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    _buildHeader(),
                    const SizedBox(height: 16),
                    _buildUserTypeSelector(),
                    const SizedBox(height: 24),
                    _buildRegisterForm(),
                    const SizedBox(height: 20),
                    _buildLoginLink(),
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
            boxShadow: [AppTheme.primaryShadow], // 🔥 من الثيم
          ),
          child: Icon(
            Icons.person_add,
            color: AppTheme.white,
            size: 45,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'إنشاء حساب جديد',
          style: AppTheme.titleLarge.copyWith( // 🔥 من الثيم
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
        const SizedBox(height: 8),
        Text(
          'الخدمات الحكومية',
          style: AppTheme.bodyMedium.copyWith(fontSize: 16), // 🔥 من الثيم
          textDirection: TextDirection.rtl,
        ),
      ],
    );
  }

  Widget _buildUserTypeSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.white.withOpacity(0.2), AppTheme.white.withOpacity(0.1)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.white.withOpacity(0.6), width: 1.5),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(colors: [color.withOpacity(0.3), color.withOpacity(0.1)])
              : null,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.white.withOpacity(0.6) : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppTheme.white, size: 22),
            const SizedBox(height: 6),
            Text(
              title,
              style: AppTheme.bodyMedium.copyWith( // 🔥 من الثيم
                fontSize: 14,
                color: AppTheme.white.withOpacity(isSelected ? 1.0 : 0.85),
              ),
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Column(
      children: [
        _buildTextField(
          controller: _fullNameController,
          label: 'الاسم الكامل',
          icon: Icons.person_outline,
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: _phoneController,
          label: 'رقم الهاتف',
          icon: Icons.phone,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: _emailController,
          label: 'البريد الإلكتروني',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 12),
        _buildPasswordField(
          controller: _passwordController,
          label: 'كلمة المرور',
          icon: Icons.lock_outline,
          isVisible: _isPasswordVisible,
          onVisibilityChanged: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
        ),
        const SizedBox(height: 12),
        _buildPasswordField(
          controller: _confirmPasswordController,
          label: 'تأكيد كلمة المرور',
          icon: Icons.lock_outline,
          isVisible: _isConfirmPasswordVisible,
          onVisibilityChanged: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
        ),
        const SizedBox(height: 24),
        _buildRegisterButton(),
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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.white.withOpacity(0.6), width: 1.5),
        boxShadow: [AppTheme.primaryShadow], // 🔥 من الثيم
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textDirection: TextDirection.rtl,
        style: AppTheme.bodyMedium.copyWith(fontSize: 16), // 🔥 من الثيم
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppTheme.caption.copyWith(fontSize: 14), // 🔥 من الثيم
          prefixIcon: Icon(icon, color: AppTheme.white.withOpacity(0.8), size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          filled: true,
          fillColor: Colors.transparent,
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isVisible,
    required VoidCallback onVisibilityChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.white.withOpacity(0.2), AppTheme.white.withOpacity(0.1)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.white.withOpacity(0.6), width: 1.5),
        boxShadow: [AppTheme.primaryShadow], // 🔥 من الثيم
      ),
      child: TextField(
        controller: controller,
        obscureText: !isVisible,
        textDirection: TextDirection.rtl,
        style: AppTheme.bodyMedium.copyWith(fontSize: 16), // 🔥 من الثيم
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppTheme.caption.copyWith(fontSize: 14), // 🔥 من الثيم
          prefixIcon: Icon(icon, color: AppTheme.white.withOpacity(0.8), size: 20),
          suffixIcon: IconButton(
            icon: Icon(
              isVisible ? Icons.visibility : Icons.visibility_off,
              color: AppTheme.white.withOpacity(0.8),
            ),
            onPressed: onVisibilityChanged,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          filled: true,
          fillColor: Colors.transparent,
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: _isAdmin
            ? AppTheme.adminGradient // 🔥 من الثيم
            : AppTheme.loginButtonGradient, // 🔥 من الثيم
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
          onTap: _isLoading ? null : _register,
          splashColor: Colors.white.withOpacity(0.3),
          child: Center(
            child: _isLoading
                ? const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                color: AppTheme.white,
                strokeWidth: 2.5,
              ),
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _isAdmin ? Icons.admin_panel_settings : Icons.person_add,
                  color: AppTheme.white,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'إنشاء الحساب',
                  style: AppTheme.bodyLarge.copyWith( // 🔥 من الثيم
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

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          },
          child: Text(
            'لديك حساب بالفعل؟',
            style: AppTheme.bodyMedium.copyWith(color: AppTheme.emeraldLight), // 🔥 من الثيم
          ),
        ),
        Text(
          ' تسجيل الدخول ',
          style: AppTheme.caption.copyWith(fontSize: 16), // 🔥 من الثيم
          textDirection: TextDirection.rtl,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}