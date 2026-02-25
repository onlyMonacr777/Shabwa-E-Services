import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;
  bool _isExpanded = true;

  final List<Map<String, dynamic>> _menuItems = [
    {'icon': Icons.dashboard, 'title': 'الرئيسية', 'badge': null},
    {'icon': Icons.settings, 'title': 'الخدمات', 'badge': null},
    {'icon': Icons.assignment, 'title': 'الطلبات', 'badge': '24'},
    {'icon': Icons.people, 'title': 'المواطنين', 'badge': null},
    {'icon': Icons.bar_chart, 'title': 'التقارير', 'badge': null},
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;

    return Scaffold(
      backgroundColor: AppColors.night,
      appBar: !isDesktop ? AppBar(
        backgroundColor: AppColors.deepOcean,
        title: const Text('بوابة شبوة - المشرف'),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // فتح Drawer
            },
          ),
        ],
      ) : null,
      drawer: !isDesktop ? _buildSidebar(true) : null,
      body: Row(
        children: [
          if (isDesktop) _buildSidebar(false),
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(bool isDrawer) {
    return Container(
      width: isDrawer ? 280 : (_isExpanded ? 260 : 80),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.deepOcean, AppColors.ocean],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 40),

          // زر الطي
          if (!isDrawer)
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(
                  _isExpanded ? Icons.chevron_left : Icons.chevron_right,
                  color: Colors.white,
                ),
                onPressed: () => setState(() => _isExpanded = !_isExpanded),
              ),
            ),

          const SizedBox(height: 20),

          // صورة المشرف
          Container(
            width: _isExpanded || isDrawer ? 90 : 50,
            height: _isExpanded || isDrawer ? 90 : 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: AppColors.gold, width: 3),
              boxShadow: [
                BoxShadow(
                  color: AppColors.gold.withOpacity(0.3),
                  blurRadius: 20,
                ),
              ],
            ),
            child: const Icon(
              Icons.admin_panel_settings,
              color: AppColors.ocean,
              size: 40,
            ),
          ),

          const SizedBox(height: 16),

          if (_isExpanded || isDrawer) ...[
            const Text(
              'المشرف العام',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.gold.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.gold.withOpacity(0.3)),
              ),
              child: const Text(
                'مدير النظام',
                style: TextStyle(
                  color: AppColors.gold,
                  fontSize: 12,
                ),
              ),
            ),
          ],

          const SizedBox(height: 40),

          // القائمة
          Expanded(
            child: ListView.builder(
              itemCount: _menuItems.length,
              itemBuilder: (context, index) {
                final item = _menuItems[index];
                final isSelected = _selectedIndex == index;

                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedIndex = index);
                    if (isDrawer) Navigator.pop(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      gradient: isSelected ? AppColors.goldGradient : null,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            Icon(
                              item['icon'],
                              color: isSelected ? AppColors.deepOcean : Colors.white70,
                              size: 24,
                            ),
                            if (item['badge'] != null && !isSelected)
                              Positioned(
                                right: -4,
                                top: -4,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: AppColors.error,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    item['badge'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 8,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        if (_isExpanded || isDrawer) ...[
                          const SizedBox(width: 16),
                          Text(
                            item['title'],
                            style: TextStyle(
                              color: isSelected ? AppColors.deepOcean : Colors.white,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          const Spacer(),
                          if (isSelected)
                            const Icon(
                              Icons.circle,
                              color: AppColors.deepOcean,
                              size: 8,
                            ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // تسجيل الخروج
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.error.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.logout, color: AppColors.error, size: 20),
                if (_isExpanded || isDrawer) ...[
                  const SizedBox(width: 8),
                  const Text(
                    'تسجيل الخروج',
                    style: TextStyle(
                      color: AppColors.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final screens = [
      _buildHomeScreen(),
      _buildServicesScreen(),
      _buildRequestsScreen(),
      _buildUsersScreen(),
      _buildReportsScreen(),
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      child: screens[_selectedIndex],
    );
  }

  Widget _buildHomeScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'لوحة التحكم',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            children: [
              _buildStatCard('طلبات جديدة', '24', Icons.inbox, Colors.orange, '+12%'),
              _buildStatCard('قيد المعالجة', '18', Icons.pending, Colors.blue, '+5%'),
              _buildStatCard('تم الانتهاء', '156', Icons.check_circle, Colors.green, '+23%'),
              _buildStatCard('المستخدمين', '1,240', Icons.people, Colors.purple, '+8%'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, String trend) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.2), color.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  trend,
                  style: const TextStyle(
                    color: AppColors.success,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  // Placeholders
  Widget _buildServicesScreen() => const Center(child: Text('الخدمات', style: TextStyle(color: Colors.white)));
  Widget _buildRequestsScreen() => const Center(child: Text('الطلبات', style: TextStyle(color: Colors.white)));
  Widget _buildUsersScreen() => const Center(child: Text('المواطنين', style: TextStyle(color: Colors.white)));
  Widget _buildReportsScreen() => const Center(child: Text('التقارير', style: TextStyle(color: Colors.white)));
}