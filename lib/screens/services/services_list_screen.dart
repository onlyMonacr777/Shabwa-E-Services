import 'package:flutter/material.dart';
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

  final List<Map<String, dynamic>> services = [
    {
      'title': 'استخراج جواز سفر',
      'category': 'الجوازات',
      'description': 'تقديم طلب استخراج جواز سفر جديد أو تجديد',
      'price': '15,000',
      'currency': 'ر.ي',
      'time': '3 أيام',
      'requiredDocs': ['صورة الهوية', 'صورة شخصية', 'شهادة ميلاد'],
    },
    {
      'title': 'تجديد جواز سفر',
      'category': 'الجوازات',
      'description': 'تجديد جواز السفر منتهي الصلاحية',
      'price': '12,000',
      'currency': 'ر.ي',
      'time': '2 أيام',
      'requiredDocs': ['جواز السفر القديم', 'صورة شخصية'],
    },
    {
      'title': 'استخراج بطاقة شخصية',
      'category': 'الأحوال المدنية',
      'description': 'طلب استخراج بطاقة هوية وطنية جديدة',
      'price': '5,000',
      'currency': 'ر.ي',
      'time': '5 أيام',
      'requiredDocs': ['صورة شخصية', 'شهادة ميلاد', 'إثبات محل سكن'],
    },
    {
      'title': 'ترخيص تجاري',
      'category': 'التجارة',
      'description': 'استخراج ترخيص مزاولة النشاط التجاري',
      'price': '25,000',
      'currency': 'ر.ي',
      'time': '7 أيام',
      'requiredDocs': ['عقد الإيجار', 'البطاقة الضريبية', 'الهوية'],
    },
    {
      'title': 'تسجيل مركبة',
      'category': 'المرور',
      'description': 'تسجيل مركبة جديدة أو نقل ملكية',
      'price': '20,000',
      'currency': 'ر.ي',
      'time': '4 أيام',
      'requiredDocs': ['فاتورة الشراء', 'شهادة جمركية', 'الهوية'],
    },
    {
      'title': 'شهادة صحية',
      'category': 'الصحة',
      'description': 'استخراج شهادة صحية للعمل أو السفر',
      'price': '3,000',
      'currency': 'ر.ي',
      'time': '1 يوم',
      'requiredDocs': ['صورة شخصية', 'تحليل مخبري'],
    },
    {
      'title': 'شهادة ميلاد',
      'category': 'الأحوال المدنية',
      'description': 'استخراج شهادة ميلاد أو توثيقها',
      'price': '2,000',
      'currency': 'ر.ي',
      'time': '2 أيام',
      'requiredDocs': ['إثبات ولادة', 'هوية الأب', 'هوية الأم'],
    },
    {
      'title': 'تصديق شهادة دراسية',
      'category': 'التعليم',
      'description': 'تصديق الشهادات الدراسية من الجامعات',
      'price': '8,000',
      'currency': 'ر.ي',
      'time': '3 أيام',
      'requiredDocs': ['الشهادة الأصلية', 'صورة شخصية'],
    },
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

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 600) return 2;
    if (width > 360) return 2;
    return 2;
  }

  double _getChildAspectRatio(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 600) return 0.75;
    return 0.68;
  }

  // ⬇️⬇️⬇️ زودت الارتفاع عشان ما يصير overflow ⬇️⬇️⬇️
  double _getMainAxisExtent(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 600) return 260;
    return 240;
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom + 100;

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
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _getCrossAxisCount(context),
                    childAspectRatio: _getChildAspectRatio(context),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    mainAxisExtent: _getMainAxisExtent(context),
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (context, index) => _buildServiceCard(filteredServices[index], index),
                    childCount: filteredServices.length,
                    addAutomaticKeepAlives: false,
                    addRepaintBoundaries: false,
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: bottomPadding)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service, int index) {
    final List<String> serviceImages = [
      'assets/images/10.png',
      'assets/images/20.png',
      'assets/images/40.png',
      'assets/images/30.png',
      'assets/images/60.png',
      'assets/images/50.png',
      'assets/images/80.png',
      'assets/images/70.png',
    ];

    final imagePath = serviceImages[index];

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
          height: _getMainAxisExtent(context),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.white.withOpacity(0.25), AppTheme.white.withOpacity(0.15)],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.white.withOpacity(0.6), width: 1.5),
            boxShadow: [AppTheme.primaryShadow],
          ),
          child: Stack(
            children: [
              // الصورة
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 115,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 115,
                    alignment: Alignment.center,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 115,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppTheme.emeraldLight.withOpacity(0.6), AppTheme.primaryGreenLight.withOpacity(0.4)],
                          ),
                        ),
                        child: Icon(
                          Icons.image,
                          color: Colors.white,
                          size: 50,
                        ),
                      );
                    },
                  ),
                ),
              ),
              // النص - ⬇️⬇️⬇️ صغّرت المسافة عشان ما يصير overflow ⬇️⬇️⬇️
              Positioned(
                top: 120,
                left: 12,
                right: 12,
                bottom: 50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      service['title'],
                      textAlign: TextAlign.right,
                      style: AppTheme.bodyMedium.copyWith(
                        fontSize: 13,        // ⬅️ صغّر شوي
                        fontWeight: FontWeight.bold,
                        color: AppTheme.white,
                        shadows: [
                          Shadow(offset: const Offset(1, 1), blurRadius: 3, color: Colors.black.withOpacity(0.5)),
                        ],
                      ),
                      maxLines: 1,           // ⬅️ سطر واحد بس
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),  // ⬅️ صغّر المسافة
                    Text(
                      service['description'],
                      textAlign: TextAlign.right,
                      style: AppTheme.caption.copyWith(
                        fontSize: 10,        // ⬅️ صغّر شوي
                        height: 1.2,
                        color: AppTheme.white.withOpacity(0.95),
                        shadows: [
                          Shadow(offset: const Offset(1, 1), blurRadius: 2, color: Colors.black.withOpacity(0.4)),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // السعر - ⬇️⬇️⬇️ صغّرت padding عشان توفير مساحة ⬇️⬇️⬇️
              Positioned(
                bottom: 8,
                left: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),  // ⬅️ صغّر padding
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppTheme.emeraldLight.withOpacity(0.9), AppTheme.primaryGreenLight.withOpacity(0.8)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.emeraldLight.withOpacity(0.8), width: 1),
                    boxShadow: [
                      BoxShadow(color: AppTheme.primaryGreenDark.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 2)),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        service['currency'],
                        style: AppTheme.caption.copyWith(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12),  // ⬅️ صغّر
                      ),
                      const SizedBox(width: 4),
                      Text(
                        service['price'],
                        style: AppTheme.bodyMedium.copyWith(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),  // ⬅️ صغّر
                      ),
                      const SizedBox(width: 8),
                      Container(width: 1, height: 14, color: Colors.white.withOpacity(0.7)),  // ⬅️ صغّر
                      const SizedBox(width: 8),
                      Icon(Icons.access_time, size: 12, color: Colors.white),  // ⬅️ صغّر
                      const SizedBox(width: 4),
                      Text(
                        service['time'],
                        style: AppTheme.caption.copyWith(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12),  // ⬅️ صغّر
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