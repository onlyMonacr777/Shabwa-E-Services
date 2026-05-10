import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:shabwa_e_services/screens/services/services_list_screen.dart';

import '/core/theme/app_theme.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {

  bool _isLoading = false;
  bool _obscurePass = true;
  bool _obscureConfirm = true;

  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  late AnimationController _animCtrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _animCtrl = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _animCtrl,
        curve: const Interval(
          0.0,
          0.6,
          curve: Curves.easeOut,
        ),
      ),
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animCtrl,
        curve: const Interval(
          0.1,
          0.7,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    _scale = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animCtrl,
        curve: const Interval(
          0.0,
          0.5,
          curve: Curves.easeOutBack,
        ),
      ),
    );

    _animCtrl.forward();
  }

  Future<void> _register() async {

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {

      final userCred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(

        email: _emailCtrl.text.trim(),
        password: _passCtrl.text.trim(),
      );

      final user = userCred.user;

      if (user == null) return;

      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .set({

        "uid": user.uid,
        "name": _nameCtrl.text.trim(),
        "phone": _phoneCtrl.text.trim(),
        "email": _emailCtrl.text.trim(),
        "role": "user",
        "createdAt": FieldValue.serverTimestamp(),

      });

      if (!mounted) return;

      Navigator.pushReplacement(

        context,

        MaterialPageRoute(

          builder: (_) => const ServicesListScreen(),
        ),
      );

    } on FirebaseAuthException catch (e) {

      _showError(_getErrorMessage(e.code));

    } catch (e) {

      _showError("حدث خطأ في التسجيل");

    } finally {

      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _getErrorMessage(String code) {

    switch (code) {

      case 'email-already-in-use':
        return 'هذا الإيميل مستخدم مسبقاً';

      case 'invalid-email':
        return 'صيغة الإيميل غير صحيحة';

      case 'weak-password':
        return 'كلمة المرور ضعيفة جداً';

      default:
        return 'حدث خطأ في التسجيل';
    }
  }

  void _showError(String msg) {

    ScaffoldMessenger.of(context).showSnackBar(

      SnackBar(

        content: Row(

          children: [

            const Icon(
              Icons.error_outline_rounded,
              color: Colors.white,
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Text(msg),
            ),
          ],
        ),

        backgroundColor: const Color(0xFFEF4444),

        behavior: SnackBarBehavior.floating,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),

        margin: const EdgeInsets.all(16),

        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Directionality(

      textDirection: TextDirection.rtl,

      child: Scaffold(

        body: Container(

          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
          ),

          child: SafeArea(

            child: SingleChildScrollView(

              physics: const BouncingScrollPhysics(),

              child: Padding(

                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                ),

                child: FadeTransition(

                  opacity: _fade,

                  child: SlideTransition(

                    position: _slide,

                    child: Form(

                      key: _formKey,

                      child: Column(

                        children: [

                          const SizedBox(height: 60),

                          ScaleTransition(
                            scale: _scale,
                            child: _buildLogo(),
                          ),

                          const SizedBox(height: 32),

                          _buildTitle(),

                          const SizedBox(height: 8),

                          _buildSubtitle(),

                          const SizedBox(height: 40),

                          _buildField(
                            controller: _nameCtrl,
                            label: 'الاسم الكامل',
                            icon: Icons.person_outline_rounded,
                            validator: (v) =>
                            v!.isEmpty ? 'أدخل الاسم' : null,
                          ),

                          const SizedBox(height: 20),

                          _buildField(
                            controller: _phoneCtrl,
                            label: 'رقم الهاتف',
                            icon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                            validator: (v) {

                              if (v!.isEmpty) {
                                return 'أدخل رقم الهاتف';
                              }

                              if (v.length < 9) {
                                return 'رقم غير صحيح';
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          _buildField(
                            controller: _emailCtrl,
                            label: 'البريد الإلكتروني',
                            icon: Icons.email_outlined,
                            keyboardType:
                            TextInputType.emailAddress,
                            validator: (v) {

                              if (v!.isEmpty) {
                                return 'أدخل البريد الإلكتروني';
                              }

                              if (!v.contains('@')) {
                                return 'صيغة غير صحيحة';
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          _buildField(
                            controller: _passCtrl,
                            label: 'كلمة المرور',
                            icon: Icons.lock_outline_rounded,
                            obscureText: _obscurePass,
                            validator: (v) {

                              if (v!.length < 6) {
                                return '6 أحرف على الأقل';
                              }

                              return null;
                            },

                            suffixIcon: IconButton(

                              icon: Icon(

                                _obscurePass
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,

                                color:
                                Colors.white.withOpacity(0.6),

                                size: 22,
                              ),

                              onPressed: () {

                                setState(() {
                                  _obscurePass = !_obscurePass;
                                });
                              },
                            ),
                          ),

                          const SizedBox(height: 20),

                          _buildField(
                            controller: _confirmCtrl,
                            label: 'تأكيد كلمة المرور',
                            icon: Icons.lock_person_outlined,
                            obscureText: _obscureConfirm,
                            validator: (v) {

                              if (v != _passCtrl.text) {
                                return 'كلمة المرور غير متطابقة';
                              }

                              return null;
                            },

                            suffixIcon: IconButton(

                              icon: Icon(

                                _obscureConfirm
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,

                                color:
                                Colors.white.withOpacity(0.6),

                                size: 22,
                              ),

                              onPressed: () {

                                setState(() {
                                  _obscureConfirm =
                                  !_obscureConfirm;
                                });
                              },
                            ),
                          ),

                          const SizedBox(height: 40),

                          _buildRegisterButton(),

                          const SizedBox(height: 32),

                          _buildDivider(),

                          const SizedBox(height: 24),

                          _buildLoginLink(),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {

    return Container(

      width: 100,
      height: 100,

      decoration: BoxDecoration(

        gradient: LinearGradient(

          colors: [

            Colors.white.withOpacity(0.2),

            Colors.white.withOpacity(0.05),
          ],
        ),

        borderRadius: BorderRadius.circular(28),

        border: Border.all(

          color: Colors.white.withOpacity(0.2),

          width: 1.5,
        ),

        boxShadow: [

          BoxShadow(

            color: Colors.black.withOpacity(0.2),

            blurRadius: 30,

            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: const Icon(

        Icons.person_add_rounded,

        size: 48,

        color: Colors.white,
      ),
    );
  }

  Widget _buildTitle() {

    return Text(

      'إنشاء حساب جديد',

      style: TextStyle(

        fontSize: 28,

        fontWeight: FontWeight.w800,

        color: Colors.white,

        letterSpacing: -0.5,

        shadows: [

          Shadow(

            color: Colors.black.withOpacity(0.3),

            blurRadius: 10,

            offset: const Offset(0, 4),
          ),
        ],
      ),
    );
  }

  Widget _buildSubtitle() {

    return Text(

      'انضم إلينا واستمتع بخدماتنا',

      style: TextStyle(

        fontSize: 15,

        color: Colors.white.withOpacity(0.7),

        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildField({

    required TextEditingController controller,
    required String label,
    required IconData icon,

    TextInputType? keyboardType,

    bool obscureText = false,

    String? Function(String?)? validator,

    Widget? suffixIcon,

  }) {

    return Column(

      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        Text(

          label,

          style: TextStyle(

            color: Colors.white.withOpacity(0.9),

            fontSize: 14,

            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 8),

        Container(

          decoration: BoxDecoration(

            color: Colors.white.withOpacity(0.08),

            borderRadius: BorderRadius.circular(16),

            border: Border.all(

              color: Colors.white.withOpacity(0.15),

              width: 1,
            ),
          ),

          child: TextFormField(

            controller: controller,

            obscureText: obscureText,

            keyboardType: keyboardType,

            validator: validator,

            style: const TextStyle(

              color: Colors.white,

              fontSize: 16,

              fontWeight: FontWeight.w500,
            ),

            decoration: InputDecoration(

              hintText: label,

              hintStyle: TextStyle(

                color: Colors.white.withOpacity(0.3),

                fontSize: 15,
              ),

              prefixIcon: Icon(

                icon,

                color: Colors.white.withOpacity(0.5),

                size: 22,
              ),

              suffixIcon: suffixIcon,

              border: InputBorder.none,

              contentPadding:
              const EdgeInsets.symmetric(

                horizontal: 20,

                vertical: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {

    return GestureDetector(

      onTapDown: (_) => _animCtrl.reverse(from: 0.95),

      onTapUp: (_) => _animCtrl.forward(from: 0.95),

      onTapCancel: () => _animCtrl.forward(),

      child: Container(

        width: double.infinity,

        height: 56,

        decoration: BoxDecoration(

          gradient: const LinearGradient(

            colors: [
              Colors.white,
              Colors.white70,
            ],
          ),

          borderRadius: BorderRadius.circular(16),

          boxShadow: [

            BoxShadow(

              color: Colors.black.withOpacity(0.2),

              blurRadius: 20,

              offset: const Offset(0, 8),
            ),
          ],
        ),

        child: Material(

          color: Colors.transparent,

          child: InkWell(

            onTap: _isLoading ? null : _register,

            borderRadius: BorderRadius.circular(16),

            splashColor: Colors.black.withOpacity(0.1),

            child: Center(

              child: _isLoading

                  ? const SizedBox(

                width: 24,

                height: 24,

                child: CircularProgressIndicator(

                  strokeWidth: 2.5,

                  valueColor:
                  AlwaysStoppedAnimation<Color>(

                    Color(0xFF1E3A5F),
                  ),
                ),
              )

                  : const Row(

                mainAxisAlignment:
                MainAxisAlignment.center,

                children: [

                  Text(

                    'إنشاء الحساب',

                    style: TextStyle(

                      color: Color(0xFF1E3A5F),

                      fontSize: 17,

                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  SizedBox(width: 10),

                  Icon(

                    Icons.arrow_back_rounded,

                    color: Color(0xFF1E3A5F),

                    size: 22,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {

    return Row(

      children: [

        Expanded(

          child: Container(

            height: 1,

            decoration: BoxDecoration(

              gradient: LinearGradient(

                colors: [

                  Colors.transparent,

                  Colors.white.withOpacity(0.3),
                ],
              ),
            ),
          ),
        ),

        Padding(

          padding:
          const EdgeInsets.symmetric(horizontal: 16),

          child: Text(

            'أو',

            style: TextStyle(

              color: Colors.white.withOpacity(0.5),

              fontSize: 14,
            ),
          ),
        ),

        Expanded(

          child: Container(

            height: 1,

            decoration: BoxDecoration(

              gradient: LinearGradient(

                colors: [

                  Colors.white.withOpacity(0.3),

                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginLink() {

    return Row(

      mainAxisAlignment: MainAxisAlignment.center,

      children: [

        Text(

          'لديك حساب بالفعل؟',

          style: TextStyle(

            color: Colors.white.withOpacity(0.7),

            fontSize: 15,
          ),
        ),

        const SizedBox(width: 6),

        GestureDetector(

          onTap: () {

            Navigator.pushReplacement(

              context,

              MaterialPageRoute(
                builder: (_) =>
                const LoginScreen(),
              ),
            );
          },

          child: Container(

            padding: const EdgeInsets.symmetric(

              horizontal: 12,

              vertical: 6,
            ),

            decoration: BoxDecoration(

              color: Colors.white.withOpacity(0.1),

              borderRadius: BorderRadius.circular(8),

              border: Border.all(

                color: Colors.white.withOpacity(0.2),
              ),
            ),

            child: const Text(

              'تسجيل الدخول',

              style: TextStyle(

                color: Colors.white,

                fontSize: 15,

                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {

    _animCtrl.dispose();

    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();

    super.dispose();
  }
}