import 'package:flutter/material.dart';
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

  // ✅ ألوان حكومية خضراء موحدة
  static const Color primaryGreen = Color(0xFF00695C);      // أخضر رئيسي
  static const Color secondaryGreen = Color(0xFF00796B);    // أخضر ثانوي
  static const Color darkGreen = Color(0xFF004D40);        // أخضر غامق
  static const Color lightGreen = Color(0xFF4DB6AC);       // أخضر فاتح
  static const Color blueAccent = Color(0xFF1976D2);       // أزرق حكومي
  static const Color white = Color(0xFFFAFAFA);            // أبيض
  static const Color darkGrey = Color(0xFF263238);         // رمادي

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
            MaterialPageRoute(builder: (_) =>  LoginScreen()),
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
        content: Text(message),
        backgroundColor: primaryGreen,
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
          gradient: LinearGradient(
            colors: [
              lightGreen.withOpacity(0.9),
              secondaryGreen.withOpacity(0.7),
              primaryGreen.withOpacity(0.4),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.6, 1.0],
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
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [white, lightGreen.withOpacity(0.8)],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: primaryGreen.withOpacity(0.3),
                blurRadius: 25,
                spreadRadius: 5,
              ),
            ],
          ),
          child: const Icon(
            Icons.account_balance,
            color: primaryGreen,
            size: 45,
            shadows: [
              Shadow(
                color: Colors.black26,
                offset: Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'الخدمات الحكومية',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: white,
            shadows: [
              Shadow(
                color: primaryGreen.withOpacity(0.5),
                offset: Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserTypeSelector() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: primaryGreen.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: primaryGreen.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildUserTypeButton(
            isSelected: !_isAdmin,
            icon: Icons.person_outline,
            label: 'مواطن',
            gradient: const LinearGradient(
              colors: [primaryGreen, secondaryGreen],
            ),
            onTap: () => setState(() => _isAdmin = false),
          ),
          _buildUserTypeButton(
            isSelected: _isAdmin,
            icon: Icons.admin_panel_settings_outlined,
            label: 'مشرف',
            gradient: const LinearGradient(
              colors: [darkGreen, primaryGreen],
            ),
            onTap: () => setState(() => _isAdmin = true),
          ),
        ],
      ),
    );
  }

  Widget _buildUserTypeButton({
    required bool isSelected,
    required IconData icon,
    required String label,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
          decoration: BoxDecoration(
            gradient: isSelected ? gradient : null,
            color: isSelected ? null : white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: isSelected
                ? [
              BoxShadow(
                color: primaryGreen.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? white : primaryGreen,
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? white : primaryGreen,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: primaryGreen.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: primaryGreen.withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            _isAdmin ? 'دخول المشرفين' : 'دخول المواطنين',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: _isAdmin ? darkGreen : primaryGreen,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'أدخل بياناتك للمتابعة',
            style: TextStyle(
              color: darkGrey,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 32),
          _buildTextField(
            controller: _phoneController,
            hint: 'رقم الهاتف',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 20),
          _buildTextField(
            controller: _passwordController,
            hint: 'كلمة المرور',
            icon: Icons.lock_outlined,
            obscureText: true,
          ),
          const SizedBox(height: 16),
          _buildForgotPassword(),
          const SizedBox(height: 32),
          _buildLoginButton(), // ✅ زر واضح غير شفاف
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: (_isAdmin ? darkGreen : primaryGreen).withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: (_isAdmin ? darkGreen : primaryGreen).withOpacity(0.1),
            blurRadius: 10,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 15,
          ),
          prefixIcon: Icon(
            icon,
            color: _isAdmin ? darkGreen : primaryGreen,
            size: 22,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(padding: EdgeInsets.zero),
        child: Text(
          'نسيت كلمة المرور؟',
          style: TextStyle(
            color: _isAdmin ? darkGreen : primaryGreen,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ✅ زر تسجيل دخول واضح غير شفاف - لون أخضر حكومي قوي
  Widget _buildLoginButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _isAdmin
              ? [darkGreen, primaryGreen]      // مشرف: أخضر غامق → أخضر رئيسي
              : [primaryGreen, secondaryGreen], // مواطن: أخضر رئيسي → ثانوي
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryGreen.withOpacity(0.5),
            blurRadius: 20,
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
              child: CircularProgressIndicator(
                color: white,
                strokeWidth: 2.5,
              ),
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _isAdmin ? Icons.admin_panel_settings : Icons.login,
                  color: white,
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Text(
                  'تسجيل الدخول',
                  style: TextStyle(
                    color: white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
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
          style: TextStyle(
            color: darkGrey,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
          child: Text(
            'سجل الآن',
            style: TextStyle(
              color: primaryGreen,
              fontWeight: FontWeight.bold,
              fontSize: 15,
              decoration: TextDecoration.underline,
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