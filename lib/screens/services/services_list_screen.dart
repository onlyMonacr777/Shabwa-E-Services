import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/core/theme/app_theme.dart';
import 'service_details_screen.dart';

class ServicesListScreen extends StatefulWidget {
  const ServicesListScreen({super.key});

  @override
  State<ServicesListScreen> createState() => _ServicesListScreenState();
}

class _ServicesListScreenState extends State<ServicesListScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  String _searchQuery = '';
  String _selectedCategory = 'الكل';
  late AnimationController _animationController;

  final List<Map<String, dynamic>> categories = [
    {'name': 'الكل', 'icon': Icons.grid_view_rounded},
    {'name': 'الجوازات', 'icon': Icons.card_travel},
    {'name': 'الأحوال المدنية', 'icon': Icons.people_alt},
    {'name': 'المرور', 'icon': Icons.directions_car_filled},
    {'name': 'الصحة', 'icon': Icons.local_hospital},
    {'name': 'التعليم', 'icon': Icons.school},
    {'name': 'التجارة', 'icon': Icons.business_center},
  ];



  List<Map<String, dynamic>> get filteredServices {
    return services.where((service) {
      final matchesCategory = _selectedCategory == 'الكل' || service['category'] == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          service['title'].contains(_searchQuery) ||
          service['description'].contains(_searchQuery);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // 🔥 🔥 🔥 الدوال الـ Responsive الجديدة 🔥 🔥 🔥
  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 600) return 3; // Tablet
    if (width > 400) return 2; // Landscape phone
    return 2; // Portrait phone
  }

  double _getChildAspectRatio(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 600) return 0.75;
    if (width > 400) return 0.72;
    return 0.72;
  }

  double _getMainAxisExtent(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 600) return 220;
    return 200;
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom + 120;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradient,
        ),
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: _buildHeader()),
              SliverToBoxAdapter(child: _buildSearchBar()),
              SliverToBoxAdapter(child: _buildCategories()),
              SliverToBoxAdapter(child: _buildSectionTitle()),
              // 🔥 🔥 الـ Grid الـ Responsive 🔥 🔥
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _getCrossAxisCount(context),
                    childAspectRatio: _getChildAspectRatio(context),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    mainAxisExtent: _getMainAxisExtent(context), // 🔥 الارتفاع الثابت
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (context, index) => _buildServiceCard(filteredServices[index], index),
                    childCount: filteredServices.length,
                    addAutomaticKeepAlives: false,
                    addRepaintBoundaries: false,
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: bottomPadding)), // 🔥 Responsive padding
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.white.withOpacity(0.2), AppTheme.white.withOpacity(0.1)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.white.withOpacity(0.6), width: 2),
                  boxShadow: [AppTheme.primaryShadow],
                ),
                child: Stack(
                  children: [
                    Icon(Icons.notifications_outlined, color: AppTheme.emeraldLight, size: 24),
                    Positioned(
                      right: 4,
                      top: 4,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'مرحباً، أحمد',
                    style: AppTheme.titleMedium.copyWith(height: 1.2),
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'سعيد بعودتك مرة أخرى',
                    style: AppTheme.bodyMedium.copyWith(fontSize: 14),
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.white.withOpacity(0.25), AppTheme.white.withOpacity(0.15)],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppTheme.white.withOpacity(0.6), width: 2),
              boxShadow: [AppTheme.primaryShadow],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppTheme.emeraldLight.withOpacity(0.3), AppTheme.emeraldLight.withOpacity(0.1)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.emeraldLight.withOpacity(0.5), width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'جديد',
                            style: AppTheme.caption.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 6),
                          Icon(Icons.circle, color: AppTheme.white, size: 8),
                        ],
                      ),
                    ),
                    Text(
                      'إحصائيات طلباتك',
                      style: AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: _statItem('طلباتي', '3', Icons.folder_open_outlined)),
                    Container(width: 1, height: 50, color: AppTheme.white.withOpacity(0.3)),
                    Expanded(child: _statItem('مكتملة', '1', Icons.check_circle_outline)),
                    Container(width: 1, height: 50, color: AppTheme.white.withOpacity(0.3)),
                    Expanded(child: _statItem('قيد المراجعة', '2', Icons.access_time)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.emeraldLight.withOpacity(0.3), AppTheme.primaryGreenLight.withOpacity(0.2)],
            ),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppTheme.white, size: 22),
        ),
        const SizedBox(height: 8),
        Text(value, style: AppTheme.bodyLarge.copyWith(fontSize: 20)),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppTheme.bodyMedium.copyWith(fontSize: 11),
          textDirection: TextDirection.rtl,
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.white.withOpacity(0.25), AppTheme.white.withOpacity(0.15)],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.white.withOpacity(0.6), width: 2),
          boxShadow: [AppTheme.primaryShadow],
        ),
        child: TextField(
          textAlign: TextAlign.right,
          style: AppTheme.bodyMedium.copyWith(fontSize: 16),
          onChanged: (value) => setState(() => _searchQuery = value),
          decoration: InputDecoration(
            hintText: 'ابحث عن خدمة حكومية...',
            hintStyle: AppTheme.caption.copyWith(fontSize: 14),
            prefixIcon: Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.search, color: AppTheme.white.withOpacity(0.9), size: 20),
            ),
            suffixIcon: Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.emeraldLight.withOpacity(0.4), AppTheme.primaryGreenLight.withOpacity(0.2)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.tune, color: AppTheme.white, size: 20),
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return Container(
      height: 100,
      margin: const EdgeInsets.only(top: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        reverse: true,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategory == category['name'];
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = category['name']),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(left: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(colors: [AppTheme.emeraldLight.withOpacity(0.4), AppTheme.primaryGreenLight.withOpacity(0.2)])
                    : LinearGradient(colors: [AppTheme.white.withOpacity(0.2), AppTheme.white.withOpacity(0.1)]),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppTheme.emeraldLight : AppTheme.white.withOpacity(0.4),
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryGreenDark.withOpacity(isSelected ? 0.5 : 0.3),
                    blurRadius: 20,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    category['icon'],
                    color: isSelected ? AppTheme.white : AppTheme.white.withOpacity(0.9),
                    size: 26,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    category['name'],
                    style: AppTheme.caption.copyWith(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                      color: isSelected ? AppTheme.white : AppTheme.white.withOpacity(0.9),
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.emeraldLight.withOpacity(0.4), AppTheme.primaryGreenLight.withOpacity(0.2)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.emeraldLight.withOpacity(0.6)),
            ),
            child: Text(
              '${filteredServices.length} خدمة',
              style: AppTheme.caption.copyWith(fontSize: 14, fontWeight: FontWeight.bold),
              textDirection: TextDirection.rtl,
            ),
          ),
          Text(
            'الخدمات المتاحة',
            style: AppTheme.titleMedium.copyWith(height: 1.2),
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }

  // 🔥 🔥 بطاقة الخدمة المُحسّنة والـ Responsive 🔥 🔥
  Widget _buildServiceCard(Map<String, dynamic> service, int index) {
    final imageIndex = 10 + (index * 10);
    final imagePath = 'assets/images/$imageIndex.jpg';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServiceDetailsScreen(
              service: {
                ...service,
                'image': imagePath,
              },
            ),
          ),
        );
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          final delay = index * 0.08;
          final animationValue = (_animationController.value - delay).clamp(0.0, 1.0);
          return Transform.translate(
            offset: Offset(0, 20 * (1 - animationValue)),
            child: Opacity(
              opacity: animationValue,
              child: child,
            ),
          );
        },
        child: Container(
          height: _getMainAxisExtent(context), // 🔥 ارتفاع ثابت responsive
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.white.withOpacity(0.25), AppTheme.white.withOpacity(0.15)],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.white.withOpacity(0.6), width: 1.5),
            boxShadow: [AppTheme.primaryShadow],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔥 صورة محسنة
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.white.withOpacity(0.2),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppTheme.white.withOpacity(0.2),
                        child: Icon(
                          Icons.image_not_supported,
                          color: AppTheme.white.withOpacity(0.6),
                          size: 40,
                        ),
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        service['title'],
                        textAlign: TextAlign.right,
                        style: AppTheme.bodyMedium.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        service['description'],
                        textAlign: TextAlign.right,
                        style: AppTheme.caption.copyWith(
                          fontSize: 10,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppTheme.emeraldLight.withOpacity(0.3), AppTheme.primaryGreenLight.withOpacity(0.2)],
                          ),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppTheme.emeraldLight.withOpacity(0.5)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              service['currency'],
                              style: AppTheme.caption.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              service['price'],
                              style: AppTheme.bodyMedium.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(width: 1, height: 12, color: AppTheme.white.withOpacity(0.5)),
                            const SizedBox(width: 6),
                            Icon(Icons.access_time, size: 12, color: AppTheme.white.withOpacity(0.9)),
                            const SizedBox(width: 3),
                            Text(
                              service['time'],
                              style: AppTheme.caption.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.emeraldLight.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryGreenDark.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          backgroundColor: Colors.transparent,
          selectedItemColor: AppTheme.primaryGreen,
          unselectedItemColor: AppTheme.textMedium,
          selectedLabelStyle: AppTheme.caption.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryGreen,
          ),
          unselectedLabelStyle: AppTheme.caption.copyWith(
            color: AppTheme.textMedium,
          ),
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: 24),
              activeIcon: Icon(Icons.home_rounded, size: 24, color: AppTheme.primaryGreen),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.description_outlined, size: 24),
              activeIcon: Icon(Icons.description_rounded, size: 24, color: AppTheme.primaryGreen),
              label: 'طلباتي',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_outlined, size: 24),
              activeIcon: Icon(Icons.notifications_rounded, size: 24, color: AppTheme.primaryGreen),
              label: 'الإشعارات',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline, size: 24),
              activeIcon: Icon(Icons.person_rounded, size: 24, color: AppTheme.primaryGreen),
              label: 'حسابي',
            ),
          ],
        ),
      ),
    );
  }
}