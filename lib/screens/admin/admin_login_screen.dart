import 'package:flutter/material.dart';

import 'admin_home_screen.dart';

class AdminLoginScreen extends StatelessWidget {
  const AdminLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController =
    TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('تسجيل دخول المشرف'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              textAlign: TextAlign.right,

              decoration: const InputDecoration(
                labelText: 'البريد الإلكتروني',
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: passwordController,
              obscureText: true,
              textAlign: TextAlign.right,

              decoration: const InputDecoration(
                labelText: 'كلمة المرور',
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                      const AdminHomeScreen(),
                    ),
                  );
                },

                child: const Text(
                  'دخول',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}