import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;
  bool _isExpanded = false;

  final List<Map<String, dynamic>> _menuItems = [
    {'icon': Icons.dashboard_outlined, 'title': 'الرئيسية', 'badge': null},
    {'icon': Icons.settings_outlined, 'title': 'الخدمات', 'badge': null},
    {'icon': Icons.assignment_outlined, 'title': 'الطلبات', 'badge': '24'},
    {'icon': Icons.people_outline, 'title': 'المواطنين', 'badge': null},
    {'icon': Icons.bar_chart_outlined, 'title': 'التقارير', 'badge': null},
  ];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isDesktop = screenSize.width > 900;
    final isTablet = screenSize.width > 600 && screenSize.width <= 900;

    return Scaffold(
      backgroundColor: AppColors.night,
      appBar: !isDesktop
          ? AppBar(
        backgroundColor: AppColors.deepOcean,
        elevation: 0,
        title: const Text(
          'بوابة شبوة',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, size: 22),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      )
          : null,
      endDrawer: !isDesktop
          ? Drawer(
        width: screenSize.width * 0.75,
        backgroundColor: Colors.transparent,
        child: _buildSidebar(true, screenSize),
      )
          : null,
      body: Row(
        children: [
          if (isDesktop) _buildSidebar(false, screenSize),
          Expanded(
            child: _buildContent(screenSize, isDesktop, isTablet),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(bool isDrawer, Size screenSize) {
    final sidebarWidth = isDrawer
        ? screenSize.width * 0.75
        : (_isExpanded ? 220.0 : 70.0);

    return Container(
      width: sidebarWidth,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.deepOcean, AppColors.ocean],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(height: isDrawer ? 50 : 20),

          if (!isDrawer)
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(
                  _isExpanded ? Icons.chevron_left : Icons.chevron_right,
                  color: Colors.white70,
                  size: 20,
                ),
                onPressed: () => setState(() => _isExpanded = !_isExpanded),
              ),
            ),

          Container(
            width: _isExpanded || isDrawer ? 70 : 40,
            height: _isExpanded || isDrawer ? 70 : 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: AppColors.gold, width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.gold.withOpacity(0.2),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Icon(
              Icons.admin_panel_settings,
              color: AppColors.ocean,
              size: _isExpanded || isDrawer ? 30 : 20,
            ),
          ),

          const SizedBox(height: 12),

          if (_isExpanded || isDrawer) ...[
            const Text(
              'المشرف العام',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.gold.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.gold.withOpacity(0.2)),
              ),
              child: const Text(
                'مدير النظام',
                style: TextStyle(
                  color: AppColors.gold,
                  fontSize: 10,
                ),
              ),
            ),
          ],

          const SizedBox(height: 24),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8),
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
                    margin: const EdgeInsets.symmetric(vertical: 3),
                    padding: EdgeInsets.symmetric(
                      horizontal: _isExpanded || isDrawer ? 14 : 0,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      gradient: isSelected ? AppColors.goldGradient : null,
                      borderRadius: BorderRadius.circular(12),
                      color: isSelected ? null : Colors.transparent,
                    ),
                    child: Row(
                      mainAxisAlignment: _isExpanded || isDrawer
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.center,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Icon(
                              item['icon'],
                              color: isSelected
                                  ? AppColors.deepOcean
                                  : Colors.white70,
                              size: 20,
                            ),
                            if (item['badge'] != null && !isSelected)
                              Positioned(
                                right: -8,
                                top: -8,
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: const BoxDecoration(
                                    color: AppColors.error,
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 16,
                                    minHeight: 16,
                                  ),
                                  child: Text(
                                    item['badge'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        if (_isExpanded || isDrawer) ...[
                          const SizedBox(width: 12),
                          Text(
                            item['title'],
                            style: TextStyle(
                              color: isSelected
                                  ? AppColors.deepOcean
                                  : Colors.white,
                              fontSize: 13,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          const Spacer(),
                          if (isSelected)
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: AppColors.deepOcean,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(10),
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.error.withOpacity(0.2)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.logout,
                        color: AppColors.error, size: 18),
                    if (_isExpanded || isDrawer) ...[
                      const SizedBox(width: 6),
                      const Text(
                        'خروج',
                        style: TextStyle(
                          color: AppColors.error,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildContent(Size screenSize, bool isDesktop, bool isTablet) {
    final screens = [
      _buildHomeScreen(screenSize, isDesktop, isTablet),
      _buildServicesScreen(),
      _buildRequestsScreen(),
      _buildUsersScreen(),
      _buildReportsScreen(),
    ];

    return Container(
      color: AppColors.night,
      child: screens[_selectedIndex],
    );
  }

  Widget _buildHomeScreen(Size screenSize, bool isDesktop, bool isTablet) {
    int crossCount = 2;
    if (isDesktop) crossCount = 4;
    else if (isTablet) crossCount = 3;
    if (screenSize.width < 400) crossCount = 1;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'لوحة التحكم',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.gold.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.calendar_today,
                        color: AppColors.gold, size: 14),
                    SizedBox(width: 6),
                    Text(
                      '2026',
                      style: TextStyle(
                        color: AppColors.gold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossCount,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: screenSize.width < 400 ? 2.5 : 1.4,
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              final stats = [
                {
                  'title': 'جديدة',
                  'value': '24',
                  'icon': Icons.inbox,
                  'color': Colors.orange,
                  'trend': '+12%'
                },
                {
                  'title': 'قيد المعالجة',
                  'value': '18',
                  'icon': Icons.pending,
                  'color': Colors.blue,
                  'trend': '+5%'
                },
                {
                  'title': 'مكتملة',
                  'value': '156',
                  'icon': Icons.check_circle,
                  'color': Colors.green,
                  'trend': '+23%'
                },
                {
                  'title': 'مستخدمين',
                  'value': '1.2K',
                  'icon': Icons.people,
                  'color': Colors.purple,
                  'trend': '+8%'
                },
              ];
              return _buildCompactStatCard(stats[index]);
            },
          ),
          const SizedBox(height: 20),
          if (screenSize.width > 500) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'آخر الطلبات',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'عرض الكل',
                    style: TextStyle(
                      color: AppColors.ocean,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildRecentRequestsList(),
          ],
        ],
      ),
    );
  }

  Widget _buildCompactStatCard(Map<String, dynamic> stat) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            (stat['color'] as Color).withOpacity(0.15),
            (stat['color'] as Color).withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: (stat['color'] as Color).withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (stat['color'] as Color).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  stat['icon'],
                  color: stat['color'],
                  size: 18,
                ),
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  stat['trend'],
                  style: const TextStyle(
                    color: AppColors.success,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                stat['value'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                stat['title'],
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentRequestsList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        separatorBuilder: (_, __) => Divider(
          color: Colors.white.withOpacity(0.1),
          height: 1,
        ),
        itemBuilder: (context, index) {
          final requests = [
            {
              'name': 'أحمد محمد',
              'service': 'بطاقة شخصية',
              'status': 'جديد',
              'date': 'اليوم'
            },
            {
              'name': 'خالد سعيد',
              'service': 'شهادة ميلاد',
              'status': 'قيد المعالجة',
              'date': 'أمس'
            },
            {
              'name': 'فاطمة علي',
              'service': 'ترخيص تجاري',
              'status': 'مكتمل',
              'date': '2026/04/24'
            },
          ];
          final req = requests[index];

          Color statusColor;
          switch (req['status']) {
            case 'جديد':
              statusColor = Colors.orange;
              break;
            case 'قيد المعالجة':
              statusColor = Colors.blue;
              break;
            case 'مكتمل':
              statusColor = Colors.green;
              break;
            default:
              statusColor = Colors.grey;
          }

          return ListTile(
            dense: true,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            leading: CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.ocean.withOpacity(0.3),
              child: Text(
                (req['name'] as String)[0],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              req['name']!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              req['service']!,
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 11,
              ),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    req['status']!,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  req['date']!,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildServicesScreen() => const Center(
    child: Text('الخدمات',
        style: TextStyle(color: Colors.white70, fontSize: 14)),
  );

  Widget _buildRequestsScreen() => const Center(
    child: Text('الطلبات',
        style: TextStyle(color: Colors.white70, fontSize: 14)),
  );

  Widget _buildUsersScreen() => const Center(
    child: Text('المواطنين',
        style: TextStyle(color: Colors.white70, fontSize: 14)),
  );

  Widget _buildReportsScreen() => const Center(
    child: Text('التقارير',
        style: TextStyle(color: Colors.white70, fontSize: 14)),
  );
}