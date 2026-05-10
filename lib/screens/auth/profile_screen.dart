import 'package:flutter/material.dart';
import '/core/theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradient,
        ),

        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),

            child: Column(
              children: [
                // ===== Header =====
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },

                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                      ),
                    ),

                    const Expanded(
                      child: Center(
                        child: Text(
                          'الحساب الشخصي',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 48),
                  ],
                ),

                const SizedBox(height: 30),

                // ===== Avatar =====
                Container(
                  width: 120,
                  height: 120,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.12),

                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 2,
                    ),
                  ),

                  child: const Icon(
                    Icons.person,
                    size: 70,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 20),

                // ===== Name =====
                const Text(
                  'مستخدم بوابة شبوة',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                // ===== Email =====
                Text(
                  'user@shabwa.gov',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 40),

                // ===== Cards =====
                _buildCard(
                  icon: Icons.person_outline,
                  title: 'البيانات الشخصية',
                  subtitle: 'عرض وتعديل معلومات الحساب',
                ),

                _buildCard(
                  icon: Icons.lock_outline,
                  title: 'الأمان والخصوصية',
                  subtitle: 'إدارة كلمة المرور والحماية',
                ),

                _buildCard(
                  icon: Icons.notifications_none,
                  title: 'الإشعارات',
                  subtitle: 'التحكم في تنبيهات التطبيق',
                ),

                _buildCard(
                  icon: Icons.settings_outlined,
                  title: 'الإعدادات',
                  subtitle: 'إعدادات التطبيق العامة',
                ),

                const SizedBox(height: 30),

                // ===== Logout Button =====
                SizedBox(
                  width: double.infinity,
                  height: 55,

                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },

                    icon: const Icon(Icons.logout),

                    label: const Text(
                      'تسجيل الخروج',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.redAccent,

                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(18),
                      ),
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

  // ===== Profile Card =====
  Widget _buildCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),

        borderRadius: BorderRadius.circular(20),

        border: Border.all(
          color: Colors.white.withOpacity(0.15),
        ),
      ),

      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,

            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),

            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  style: TextStyle(
                    color:
                    Colors.white.withOpacity(0.7),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.arrow_forward_ios,
            color: Colors.white70,
            size: 18,
          ),
        ],
      ),
    );
  }
}