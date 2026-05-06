import 'package:flutter/material.dart';
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

  // ===== ألوان: أخضر أساسي + أبيض + ذهبي =====
  static const Color greenMain     = Color(0xFF1B5E3F);   // أخضر رئيسي — كل الشاشة
  static const Color greenDark     = Color(0xFF144D33);   // أخضر داكن
  static const Color greenDarker   = Color(0xFF0F3D28);   // أخضر أغمق
  static const Color greenLight    = Color(0xFF2E8B5E);   // أخضر فاتح
  static const Color greenSoft     = Color(0xFF3D9E6E);   // أخضر ناعم
  static const Color white         = Color(0xFFFFFFFF);   // أبيض
  static const Color whiteSoft     = Color(0xFFF5FAF7);   // أبيض-أخضر
  static const Color goldPrimary   = Color(0xFFD4AF37);   // ذهبي
  static const Color goldLight     = Color(0xFFF0D878);   // ذهبي فاتح
  static const Color goldBg        = Color(0xFFFFF8E1);   // خلفية ذهبية فاتحة
  static const Color textDark      = Color(0xFF1A1A1A);   // نصوص داكنة
  static const Color textMedium    = Color(0xFF4A4A4A);   // نصوص متوسطة
  static const Color textLight     = Color(0xFF8A9A8E);   // نصوص خفيفة
  static const Color borderGreen   = Color(0xFFD0E8D8);   // حدود خضراء خفيفة

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
      'image': 'assets/images/passport.jpg',
      'price': '15,000',
      'currency': 'ر.ي',
      'time': '3 أيام',
      'requiredDocs': ['صورة الهوية', 'صورة شخصية', 'شهادة ميلاد'],
    },
    {
      'title': 'تجديد جواز سفر',
      'category': 'الجوازات',
      'description': 'تجديد جواز السفر منتهي الصلاحية',
      'image': 'assets/images/renew_passport.jpg',
      'price': '12,000',
      'currency': 'ر.ي',
      'time': '2 أيام',
      'requiredDocs': ['جواز السفر القديم', 'صورة شخصية'],
    },
    {
      'title': 'استخراج بطاقة شخصية',
      'category': 'الأحوال المدنية',
      'description': 'طلب استخراج بطاقة هوية وطنية جديدة',
      'image': 'assets/images/id_card.jpg',
      'price': '5,000',
      'currency': 'ر.ي',
      'time': '5 أيام',
      'requiredDocs': ['صورة شخصية', 'شهادة ميلاد', 'إثبات محل سكن'],
    },
    {
      'title': 'ترخيص تجاري',
      'category': 'التجارة',
      'description': 'استخراج ترخيص مزاولة النشاط التجاري',
      'image': 'assets/images/license.jpg',
      'price': '25,000',
      'currency': 'ر.ي',
      'time': '7 أيام',
      'requiredDocs': ['عقد الإيجار', 'البطاقة الضريبية', 'الهوية'],
    },
    {
      'title': 'تسجيل مركبة',
      'category': 'المرور',
      'description': 'تسجيل مركبة جديدة أو نقل ملكية',
      'image': 'assets/images/car.jpg',
      'price': '20,000',
      'currency': 'ر.ي',
      'time': '4 أيام',
      'requiredDocs': ['فاتورة الشراء', 'شهادة جمركية', 'الهوية'],
    },
    {
      'title': 'شهادة صحية',
      'category': 'الصحة',
      'description': 'استخراج شهادة صحية للعمل أو السفر',
      'image': 'assets/images/health.jpg',
      'price': '3,000',
      'currency': 'ر.ي',
      'time': '1 يوم',
      'requiredDocs': ['صورة شخصية', 'تحليل مخبري'],
    },
    {
      'title': 'شهادة ميلاد',
      'category': 'الأحوال المدنية',
      'description': 'استخراج شهادة ميلاد أو توثيقها',
      'image': 'assets/images/birth.jpg',
      'price': '2,000',
      'currency': 'ر.ي',
      'time': '2 أيام',
      'requiredDocs': ['إثبات ولادة', 'هوية الأب', 'هوية الأم'],
    },
    {
      'title': 'تصديق شهادة دراسية',
      'category': 'التعليم',
      'description': 'تصديق الشهادات الدراسية من الجامعات',
      'image': 'assets/images/education.jpg',
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
      backgroundColor: greenMain,
      body: SafeArea(
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
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ===== الهيدر الجديد — أبيض مع منحنى =====
  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          // صف الترحيب
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // زر الإشعارات
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: goldPrimary.withOpacity(0.4)),
                ),
                child: Stack(
                  children: [
                    const Icon(Icons.notifications_outlined, color: goldPrimary, size: 22),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // مرحباً + اسم العميل
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'مرحباً، أحمد',
                    style: TextStyle(
                      color: white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'سعيد بعودتك مرة أخرى',
                    style: TextStyle(
                      color: white.withOpacity(0.8),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          // كرت الإحصائيات — أبيض
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: goldPrimary.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: goldBg,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: goldPrimary.withOpacity(0.3)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'جديد',
                            style: TextStyle(
                              color: goldPrimary,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.circle, color: goldPrimary, size: 6),
                        ],
                      ),
                    ),
                    const Text(
                      'إحصائيات طلباتك',
                      style: TextStyle(
                        color: textDark,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _statItem('طلباتي', '3', Icons.folder_open_outlined)),
                    Container(width: 1, height: 40, color: borderGreen),
                    Expanded(child: _statItem('مكتملة', '1', Icons.check_circle_outline)),
                    Container(width: 1, height: 40, color: borderGreen),
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
        Icon(icon, color: greenMain, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: textDark,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: textLight,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // ===== شريط البحث — أبيض =====
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderGreen),
        ),
        child: TextField(
          textAlign: TextAlign.right,
          style: const TextStyle(color: textDark, fontSize: 14),
          onChanged: (value) => setState(() => _searchQuery = value),
          decoration: InputDecoration(
            hintText: 'ابحث عن خدمة حكومية...',
            hintStyle: TextStyle(
              color: textLight.withOpacity(0.6),
              fontSize: 13,
            ),
            prefixIcon: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: whiteSoft,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: borderGreen),
              ),
              child: const Icon(Icons.search, color: greenMain, size: 18),
            ),
            suffixIcon: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: goldBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: goldPrimary.withOpacity(0.3)),
              ),
              child: const Icon(Icons.tune, color: goldPrimary, size: 18),
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ),
    );
  }

  // ===== التصنيفات =====
  Widget _buildCategories() {
    return Container(
      height: 90,
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
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.only(left: 10),
              child: Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: isSelected ? white : white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isSelected ? goldPrimary : white.withOpacity(0.3),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Icon(
                      category['icon'],
                      color: isSelected ? greenMain : white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    category['name'],
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected ? goldPrimary : white,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ===== عنوان القسم =====
  Widget _buildSectionTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: goldPrimary.withOpacity(0.3)),
            ),
            child: Text(
              '${filteredServices.length} خدمة',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: goldPrimary,
              ),
            ),
          ),
          const Text(
            'الخدمات المتاحة',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: white,
            ),
          ),
        ],
      ),
    );
  }

  // ===== كرت الخدمة — أبيض =====
  Widget _buildServiceCard(Map<String, dynamic> service, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServiceDetailsScreen(service: service),
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
            color: white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderGreen),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // صورة الخدمة
              Container(
                height: 100,
                decoration: const BoxDecoration(
                  color: whiteSoft,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                  child: Image.asset(
                    service['image'],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: whiteSoft,
                        child: const Center(
                          child: Icon(Icons.image_not_supported, color: textLight, size: 32),
                        ),
                      );
                    },
                  ),
                ),
              ),
              // محتوى الكرت
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        service['title'],
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: textDark,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        service['description'],
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 10,
                          color: textMedium,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      // السعر والوقت — ذهبي وأخضر
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: whiteSoft,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: borderGreen),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              service['currency'],
                              style: const TextStyle(
                                fontSize: 10,
                                color: textLight,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              service['price'],
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: goldPrimary,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              width: 1,
                              height: 12,
                              color: borderGreen,
                            ),
                            const SizedBox(width: 6),
                            const Icon(Icons.access_time, size: 10, color: greenMain),
                            const SizedBox(width: 2),
                            Text(
                              service['time'],
                              style: const TextStyle(
                                fontSize: 10,
                                color: textLight,
                                fontWeight: FontWeight.w500,
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

  // ===== البار السفلي — أبيض مع حواف خضراء =====
  Widget _buildBottomNav() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: greenLight, width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          backgroundColor: Colors.transparent,
          selectedItemColor: greenMain,
          unselectedItemColor: textLight,
          selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: 22),
              activeIcon: Icon(Icons.home_rounded, size: 22),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.description_outlined, size: 22),
              activeIcon: Icon(Icons.description_rounded, size: 22),
              label: 'طلباتي',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_outlined, size: 22),
              activeIcon: Icon(Icons.notifications_rounded, size: 22),
              label: 'الإشعارات',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline, size: 22),
              activeIcon: Icon(Icons.person_rounded, size: 22),
              label: 'حسابي',
            ),
          ],
        ),
      ),
    );
  }
}