import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  // 🔥 نفس ألوان اللوجن بالضبط 🟢
  static const Color primaryGreenDark = Color(0xFF022C22);
  static const Color primaryGreen = Color(0xFF014230);
  static const Color primaryGreenLight = Color(0xFF059669);
  static const Color emeraldLight = Color(0xFF04533D);
  static const Color white = Color(0xFFFFFFFF);
  static const Color emeraldDark = Color(0xFF065F46);
  static const Color primaryGreenExtraDark = Color(0xFF013A2E);

  // 🔥 ألوان المشرف (مُحسَّنة لتتناسب مع الـ Splash)
  static const Color adminYellowDark = Color(0xFFF59D26);
  static const Color adminOrange = Color(0xFFEA7D1A);

  // ألوان إضافية مُحسَّنة للخدمات
  static const Color cardWhite = Color(0xFFF8FAFC);
  static const Color textDark = Color(0xFF1A202C);
  static const Color textMedium = Color(0xFF4A5568);
  static const Color textLight = Color(0xFFA0AEC0);
  static const Color borderLight = Color(0xFFE2E8F0);

  final List<Map<String, dynamic>> categories = [
    {'name': 'الكل', 'icon': Icons.grid_view_rounded},
    {'name': 'الجوازات', 'icon': Icons.card_travel},
    {'name': 'الأحوال المدنية', 'icon': Icons.people_alt},
    {'name': 'المرور', 'icon': Icons.directions_car_filled},
    {'name': 'الصحة', 'icon': Icons.local_hospital},
    {'name': 'التعليم', 'icon': Icons.school},
    {'name': 'التجارة', 'icon': Icons.business_center},
  ];

  // ===== قائمة الخدمات بدون حقل image (سيتم إنشاؤه تلقائياً) =====
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // 🔥 نفس الـ Gradient من اللوجن بالضبط
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              primaryGreenExtraDark,
              primaryGreenDark,
              primaryGreenDark,
              emeraldDark,
              primaryGreen,
            ],
          ),
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.72,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (context, index) => _buildServiceCard(filteredServices[index], index),
                    childCount: filteredServices.length,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
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
                    colors: [white.withOpacity(0.2), white.withOpacity(0.1)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: white.withOpacity(0.6), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: primaryGreenDark.withOpacity(0.7),
                      blurRadius: 60,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Icon(Icons.notifications_outlined, color: emeraldLight, size: 24),
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
                    style: GoogleFonts.cairo(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: white,
                      height: 1.2,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'سعيد بعودتك مرة أخرى',
                    style: GoogleFonts.cairo(
                      color: white.withOpacity(0.9),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
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
                colors: [white.withOpacity(0.25), white.withOpacity(0.15)],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: white.withOpacity(0.6), width: 2),
              boxShadow: [
                BoxShadow(
                  color: primaryGreenDark.withOpacity(0.7),
                  blurRadius: 60,
                  spreadRadius: 0,
                ),
              ],
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
                        gradient: LinearGradient(colors: [emeraldLight.withOpacity(0.3), emeraldLight.withOpacity(0.1)]),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: emeraldLight.withOpacity(0.5), width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'جديد',
                            style: GoogleFonts.cairo(
                              color: white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(Icons.circle, color: white, size: 8),
                        ],
                      ),
                    ),
                    Text(
                      'إحصائيات طلباتك',
                      style: GoogleFonts.cairo(
                        color: white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: _statItem('طلباتي', '3', Icons.folder_open_outlined)),
                    Container(width: 1, height: 50, color: white.withOpacity(0.3)),
                    Expanded(child: _statItem('مكتملة', '1', Icons.check_circle_outline)),
                    Container(width: 1, height: 50, color: white.withOpacity(0.3)),
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
            gradient: LinearGradient(colors: [emeraldLight.withOpacity(0.3), primaryGreenLight.withOpacity(0.2)]),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: white, size: 22),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.cairo(
            color: white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.cairo(
            color: white.withOpacity(0.9),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
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
            colors: [white.withOpacity(0.25), white.withOpacity(0.15)],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: white.withOpacity(0.6), width: 2),
          boxShadow: [
            BoxShadow(
              color: primaryGreenDark.withOpacity(0.7),
              blurRadius: 60,
              spreadRadius: 0,
            ),
          ],
        ),
        child: TextField(
          textAlign: TextAlign.right,
          style: GoogleFonts.cairo(color: white, fontSize: 16),
          onChanged: (value) => setState(() => _searchQuery = value),
          decoration: InputDecoration(
            hintText: 'ابحث عن خدمة حكومية...',
            hintStyle: GoogleFonts.cairo(
              color: white.withOpacity(0.7),
              fontSize: 14,
            ),
            prefixIcon: Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.search, color: white.withOpacity(0.9), size: 20),
            ),
            suffixIcon: Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [emeraldLight.withOpacity(0.4), primaryGreenLight.withOpacity(0.2)]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.tune, color: white, size: 20),
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
                    ? LinearGradient(colors: [emeraldLight.withOpacity(0.4), primaryGreenLight.withOpacity(0.2)])
                    : LinearGradient(colors: [white.withOpacity(0.2), white.withOpacity(0.1)]),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? emeraldLight : white.withOpacity(0.4),
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: primaryGreenDark.withOpacity(isSelected ? 0.5 : 0.3),
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
                    color: isSelected ? white : white.withOpacity(0.9),
                    size: 26,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    category['name'],
                    style: GoogleFonts.cairo(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                      color: isSelected ? white : white.withOpacity(0.9),
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
              gradient: LinearGradient(colors: [emeraldLight.withOpacity(0.4), primaryGreenLight.withOpacity(0.2)]),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: emeraldLight.withOpacity(0.6)),
            ),
            child: Text(
              '${filteredServices.length} خدمة',
              style: GoogleFonts.cairo(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: white,
              ),
              textDirection: TextDirection.rtl,
            ),
          ),
          Text(
            'الخدمات المتاحة',
            style: GoogleFonts.cairo(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: white,
              height: 1.2,
            ),
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }

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
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [white.withOpacity(0.25), white.withOpacity(0.15)],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: white.withOpacity(0.6), width: 2),
            boxShadow: [
              BoxShadow(
                color: primaryGreenDark.withOpacity(0.7),
                blurRadius: 40,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 110,
                decoration: BoxDecoration(
                  color: white.withOpacity(0.2),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(24),
                    topLeft: Radius.circular(24),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(24),
                    topLeft: Radius.circular(24),
                  ),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: white.withOpacity(0.2),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image_not_supported,
                                color: white.withOpacity(0.6), size: 36),
                            const SizedBox(height: 6),
                            Text(
                              'صورة $imageIndex',
                              style: GoogleFonts.cairo(
                                color: white.withOpacity(0.8),
                                fontSize: 11,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        service['title'],
                        textAlign: TextAlign.right,
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        service['description'],
                        textAlign: TextAlign.right,
                        style: GoogleFonts.cairo(
                          fontSize: 11,
                          color: white.withOpacity(0.9),
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [emeraldLight.withOpacity(0.3), primaryGreenLight.withOpacity(0.2)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: emeraldLight.withOpacity(0.5)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              service['currency'],
                              style: GoogleFonts.cairo(
                                fontSize: 11,
                                color: white.withOpacity(0.9),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              service['price'],
                              style: GoogleFonts.cairo(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(width: 1, height: 14, color: white.withOpacity(0.5)),
                            const SizedBox(width: 8),
                            Icon(Icons.access_time, size: 12, color: white.withOpacity(0.9)),
                            const SizedBox(width: 4),
                            Text(
                              service['time'],
                              style: GoogleFonts.cairo(
                                fontSize: 11,
                                color: white.withOpacity(0.9),
                                fontWeight: FontWeight.w600,
                              ),
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
        gradient: LinearGradient(
          colors: [white.withOpacity(0.25), white.withOpacity(0.15)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: emeraldLight.withOpacity(0.6), width: 2),
        boxShadow: [
          BoxShadow(
            color: primaryGreenDark.withOpacity(0.7),
            blurRadius: 40,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          backgroundColor: Colors.transparent,
          selectedItemColor: emeraldLight,
          unselectedItemColor: white.withOpacity(0.7),
          selectedLabelStyle: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.bold),
          unselectedLabelStyle: GoogleFonts.cairo(fontSize: 11),
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: 24),
              activeIcon: Icon(Icons.home_rounded, size: 24),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.description_outlined, size: 24),
              activeIcon: Icon(Icons.description_rounded, size: 24),
              label: 'طلباتي',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_outlined, size: 24),
              activeIcon: Icon(Icons.notifications_rounded, size: 24),
              label: 'الإشعارات',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline, size: 24),
              activeIcon: Icon(Icons.person_rounded, size: 24),
              label: 'حسابي',
            ),
          ],
        ),
      ),
    );
  }
}