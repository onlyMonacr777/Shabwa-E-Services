import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/common/glass_container.dart';
import '../../widgets/common/animated_button.dart';
import 'register_screen.dart';
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
  final _formKey = GlobalKey<FormState>();
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

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);

    if (mounted) {
      if (_isAdmin) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminDashboard()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // ✅ نفس خلفية شاشة التسجيل - تدرج المحيط
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.deepOcean,
              AppColors.ocean,
              AppColors.shallow,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
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

                    // ✅ أيقونة بنفس طابع شاشة التسجيل
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.2),
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: const Icon(
                        Icons.account_balance, // أو Icons.landscape للجبال
                        color: Colors.white,
                        size: 50,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // ✅ اختيار نوع المستخدم بتصميم محسّن
                    _buildUserTypeSelector(),

                    const SizedBox(height: 30),

                    // ✅ نموذج الدخول بـ GlassContainer
                    GlassContainer(
                      padding: const EdgeInsets.all(28),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isAdmin ? 'دخول المشرفين' : 'دخول المواطنين',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppColors.night,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'أدخل بياناتك للمتابعة',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textMuted,
                              ),
                            ),
                            const SizedBox(height: 30),

                            // ✅ حقول الإدخال بنفس طابع الريجستر
                            _buildTextField(
                              controller: _phoneController,
                              label: 'رقم الهاتف',
                              icon: Icons.phone,
                              keyboardType: TextInputType.phone,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: _passwordController,
                              label: 'كلمة المرور',
                              icon: Icons.lock,
                              obscureText: true,
                            ),
                            const SizedBox(height: 12),

                            // نسيت كلمة المرور
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                onPressed: () {},
                                child: const Text(
                                  'نسيت كلمة المرور؟',
                                  style: TextStyle(
                                    color: AppColors.ocean,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // ✅ زر الدخول بنفس طابع الريجستر
                            AnimatedButton(
                              text: 'تسجيل الدخول',
                              onPressed: _login,
                              isLoading: _isLoading,
                              icon: _isAdmin ? Icons.admin_panel_settings : Icons.login,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ✅ رابط التسجيل محسّن
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

  // ✅ اختيار نوع المستخدم - تصميم جديد متناسق
  Widget _buildUserTypeSelector() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          // خيار المواطن
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isAdmin = false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: !_isAdmin
                      ? const LinearGradient(
                    colors: [AppColors.ocean, AppColors.shallow],
                  )
                      : null,
                  color: _isAdmin ? Colors.transparent : null,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: !_isAdmin
                      ? [
                    BoxShadow(
                      color: AppColors.ocean.withOpacity(0.4),
                      blurRadius: 15,
                    ),
                  ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person,
                      color: !_isAdmin ? Colors.white : Colors.white70,
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'مواطن',
                      style: TextStyle(
                        color: !_isAdmin ? Colors.white : Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // خيار المشرف
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isAdmin = true),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: _isAdmin
                      ? const LinearGradient(
                    colors: [AppColors.deepOcean, AppColors.ocean],
                  )
                      : null,
                  color: !_isAdmin ? Colors.transparent : null,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: _isAdmin
                      ? [
                    BoxShadow(
                      color: AppColors.deepOcean.withOpacity(0.4),
                      blurRadius: 15,
                    ),
                  ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.admin_panel_settings,
                      color: _isAdmin ? Colors.white : Colors.white70,
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'مشرف',
                      style: TextStyle(
                        color: _isAdmin ? Colors.white : Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: (value) {
        if (value?.isEmpty ?? true) return 'هذا الحقل مطلوب';
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.ocean),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.ocean, width: 2),
        ),
      ),
    );
  }

  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'ليس لديك حساب؟',
          style: TextStyle(color: Colors.white70),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RegisterScreen()),
            );
          },
          child: const Text(
            'سجل الآن',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
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