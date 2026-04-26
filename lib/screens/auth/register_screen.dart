import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/common/glass_container.dart';
import '../../widgets/common/animated_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 2));
      setState(() => _isLoading = false);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            // ✅ استبدال الألوان غير الموجودة
            colors: [
              AppColors.deepOcean,  // بدل primaryDark
              AppColors.ocean,      // بدل primary
              AppColors.shallow,    // بدل primaryLight
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // أيقونة المستخدم
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.2),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: const Icon(
                    Icons.person_add,
                    color: Colors.white,
                    size: 50,
                  ),
                ),

                const SizedBox(height: 30),

                GlassContainer(
                  padding: const EdgeInsets.all(28),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'إنشاء حساب جديد',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            // ✅ تغيير اللون للتناسب مع الخلفية الداكنة
                            color: AppColors.night,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'أكمل بياناتك للمتابعة',
                          style: TextStyle(
                            fontSize: 14,
                            // ✅ تغيير اللون
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 30),

                        _buildTextField(
                          controller: _nameController,
                          label: 'الاسم الكامل',
                          icon: Icons.person,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _phoneController,
                          label: 'رقم الهاتف',
                          icon: Icons.phone,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _idController,
                          label: 'رقم الهوية',
                          icon: Icons.badge,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _passwordController,
                          label: 'كلمة المرور',
                          icon: Icons.lock,
                          obscureText: true,
                        ),

                        const SizedBox(height: 30),

                        AnimatedButton(
                          text: 'إنشاء الحساب',
                          onPressed: _register,
                          isLoading: _isLoading,
                          icon: Icons.person_add,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    TextEditingController? controller,
    TextInputType? keyboardType,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        // ✅ استبدال اللون غير الموجود
        prefixIcon: Icon(icon, color: AppColors.ocean),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          // ✅ استبدال اللون غير الموجود
          borderSide: const BorderSide(color: AppColors.ocean, width: 2),
        ),
      ),
      validator: (value) {
        if (value?.isEmpty ?? true) return 'هذا الحقل مطلوب';
        return null;
      },
    );
  }
}



