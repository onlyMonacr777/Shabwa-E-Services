import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:shabwa_e_services/screens/admin/admin_dashboard.dart';
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
  bool _isAdminSelected = false;

  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _confirm = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // 👑 UID حقك فقط (المسموح له يكون مشرف)
  final String allowedAdminUid = "uTpg7VxhbXNgwOq0GPdeN4Dz9a82";

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation =
        Tween<double>(begin: 0, end: 1).animate(_animationController);

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
            .animate(_animationController);

    _animationController.forward();
  }

  // ================= REGISTER =================
  Future<void> _register() async {
    if (_name.text.isEmpty ||
        _phone.text.isEmpty ||
        _email.text.isEmpty ||
        _pass.text.isEmpty ||
        _confirm.text.isEmpty) {
      _show("املأ كل الحقول");
      return;
    }

    if (_pass.text != _confirm.text) {
      _show("كلمة المرور غير متطابقة");
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1️⃣ إنشاء حساب
      final userCred =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email.text.trim(),
        password: _pass.text.trim(),
      );

      final user = userCred.user;
      if (user == null) return;

      String role = "user";

      // 🔥 إذا اختار "مشرف"
      if (_isAdminSelected) {
        if (user.uid != allowedAdminUid) {
          _show("❌ غير مسموح لك بإنشاء حساب مشرف");
          setState(() => _isLoading = false);
          return;
        }
        role = "admin";
      }

      // 2️⃣ حفظ في Firestore
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .set({
        "uid": user.uid,
        "name": _name.text.trim(),
        "phone": _phone.text.trim(),
        "email": _email.text.trim(),
        "role": role,
        "createdAt": FieldValue.serverTimestamp(),
      });

      _show("تم إنشاء الحساب بنجاح");

      // 3️⃣ التوجيه بعد التسجيل
      if (role == "admin") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminDashboard()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ServicesListScreen()),
        );
      }

    } catch (e) {
      _show("خطأ في التسجيل");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _show(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  // ================= UI (بدون تغيير تصميمك) =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.primaryGradient),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ChoiceChip(
                          label: const Text("مواطن"),
                          selected: !_isAdminSelected,
                          onSelected: (_) =>
                              setState(() => _isAdminSelected = false),
                        ),
                        ChoiceChip(
                          label: const Text("مشرف"),
                          selected: _isAdminSelected,
                          onSelected: (_) =>
                              setState(() => _isAdminSelected = true),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    TextField(controller: _name, decoration: const InputDecoration(labelText: "الاسم")),
                    TextField(controller: _phone, decoration: const InputDecoration(labelText: "الهاتف")),
                    TextField(controller: _email, decoration: const InputDecoration(labelText: "الإيميل")),
                    TextField(controller: _pass, obscureText: true, decoration: const InputDecoration(labelText: "كلمة المرور")),
                    TextField(controller: _confirm, obscureText: true, decoration: const InputDecoration(labelText: "تأكيد")),

                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: _isLoading ? null : _register,
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text("تسجيل"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    _pass.dispose();
    _confirm.dispose();
    super.dispose();
  }
}