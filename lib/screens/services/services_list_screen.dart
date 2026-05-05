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
      'icon': Icons.card_travel,
      'gradient': [const Color(0xFF1B5E20), const Color(0xFF2E7D32)],
      'price': '15,000',
      'currency': 'ر.ي',
      'time': '3 أيام',
      'requiredDocs': ['صورة الهوية', 'صورة شخصية', 'شهادة ميلاد'],
    },
    {
      'title': 'تجديد جواز سفر',
      'category': 'الجوازات',
      'description': 'تجديد جواز السفر منتهي الصلاحية',
      'icon': Icons.update,
      'gradient': [const Color(0xFF2E7D32), const Color(0xFF388E3C)],
      'price': '12,000',
      'currency': 'ر.ي',
      'time': '2 أيام',
      'requiredDocs': ['جواز السفر القديم', 'صورة شخصية'],
    },
    {
      'title': 'استخراج بطاقة شخصية',
      'category': 'الأحوال المدنية',
      'description': 'طلب استخراج بطاقة هوية وطنية جديدة',
      'icon': Icons.badge,
      'gradient': [const Color(0xFF1565C0), const Color(0xFF1976D2)],
      'price': '5,000',
      'currency': 'ر.ي',
      'time': '5 أيام',
      'requiredDocs': ['صورة شخصية', 'شهادة ميلاد', 'إثبات محل سكن'],
    },
    {
      'title': 'ترخيص تجاري',
      'category': 'التجارة',
      'description': 'استخراج ترخيص مزاولة النشاط التجاري',
      'icon': Icons.store,
      'gradient': [const Color(0xFF6A1B9A), const Color(0xFF8E24AA)],
      'price': '25,000',
      'currency': 'ر.ي',
      'time': '7 أيام',
      'requiredDocs': ['عقد الإيجار', 'البطاقة الضريبية', 'الهوية'],
    },
    {
      'title': 'تسجيل مركبة',
      'category': 'المرور',
      'description': 'تسجيل مركبة جديدة أو نقل ملكية',
      'icon': Icons.directions_car,
      'gradient': [const Color(0xFFD84315), const Color(0xFFEF5350)],
      'price': '20,000',
      'currency': 'ر.ي',
      'time': '4 أيام',
      'requiredDocs': ['فاتورة الشراء', 'شهادة جمركية', 'الهوية'],
    },
    {
      'title': 'شهادة صحية',
      'category': 'الصحة',
      'description': 'استخراج شهادة صحية للعمل أو السفر',
      'icon': Icons.health_and_safety,
      'gradient': [const Color(0xFF00897B), const Color(0xFF26A69A)],
      'price': '3,000',
      'currency': 'ر.ي',
      'time': '1 يوم',
      'requiredDocs': ['صورة شخصية', 'تحليل مخبري'],
    },
    {
      'title': 'شهادة ميلاد',
      'category': 'الأحوال المدنية',
      'description': 'استخراج شهادة ميلاد أو توثيقها',
      'icon': Icons.child_care,
      'gradient': [const Color(0xFF0277BD), const Color(0xFF29B6F6)],
      'price': '2,000',
      'currency': 'ر.ي',
      'time': '2 أيام',
      'requiredDocs': ['إثبات ولادة', 'هوية الأب', 'هوية الأم'],
    },
    {
      'title': 'تصديق شهادة دراسية',
      'category': 'التعليم',
      'description': 'تصديق الشهادات الدراسية من الجامعات',
      'icon': Icons.school,
      'gradient': [const Color(0xFF4527A0), const Color(0xFF7E57C2)],
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
      duration: const Duration(milliseconds: 800),
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
      backgroundColor: const Color(0xFF0A1F12),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverToBoxAdapter(child: _buildSearchBar()),
            SliverToBoxAdapter(child: _buildCategories()),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4AF37).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.3)),
                      ),
                      child: Text(
                        '${filteredServices.length} خدمة',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD4AF37),
                        ),
                      ),
                    ),
                    const Text(
                      'الخدمات المتاحة',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.78,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
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

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFD4AF37).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.2)),
                ),
                child: Stack(
                  children: [
                    const Icon(Icons.notifications_outlined, color: Color(0xFFD4AF37), size: 24),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.red,
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
                  const Text(
                    'بوابة شبوة',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'للخدمات الحكومية الرقمية',
                    style: TextStyle(
                      color: const Color(0xFF5C8D6E),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF1B5E20).withOpacity(0.6),
                  const Color(0xFF0A1F12).withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: const Color(0xFFD4AF37).withOpacity(0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1B5E20).withOpacity(0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
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
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4AF37).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'جديد',
                            style: TextStyle(
                              color: Color(0xFFD4AF37),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(Icons.circle, color: Color(0xFFD4AF37), size: 8),
                        ],
                      ),
                    ),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'مرحباً بك',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'تصفح الخدمات وتقدم بطلبك بسهولة',
                          style: TextStyle(
                            color: Color(0xFF8FBC8F),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A1F12).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFD4AF37).withOpacity(0.15),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(child: _statItem('طلباتي', '3', Icons.folder_open_outlined)),
                      Container(width: 1, height: 40, color: const Color(0xFF5C8D6E).withOpacity(0.3)),
                      Expanded(child: _statItem('مكتملة', '1', Icons.check_circle_outline)),
                      Container(width: 1, height: 40, color: const Color(0xFF5C8D6E).withOpacity(0.3)),
                      Expanded(child: _statItem('قيد المراجعة', '2', Icons.access_time)),
                    ],
                  ),
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
        Icon(icon, color: const Color(0xFF8FBC8F), size: 20),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFFD4AF37),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: const Color(0xFF5C8D6E),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF122B1A),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF5C8D6E).withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: TextField(
          textAlign: TextAlign.right,
          style: const TextStyle(color: Colors.white),
          onChanged: (value) => setState(() => _searchQuery = value),
          decoration: InputDecoration(
            hintText: 'ابحث عن خدمة حكومية...',
            hintStyle: TextStyle(
              color: const Color(0xFF5C8D6E).withOpacity(0.6),
              fontSize: 14,
            ),
            prefixIcon: Container(
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1B5E20).withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.search, color: Color(0xFF8FBC8F), size: 20),
            ),
            suffixIcon: Container(
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFD4AF37).withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.tune, color: Color(0xFFD4AF37), size: 20),
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          ),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return Container(
      height: 100,
      margin: const EdgeInsets.only(top: 24),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        reverse: true,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategory == category['name'];
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = category['name']),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(left: 12),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? const LinearGradient(
                        colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      )
                          : null,
                      color: isSelected ? null : const Color(0xFF122B1A),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFFD4AF37).withOpacity(0.5)
                            : const Color(0xFF5C8D6E).withOpacity(0.2),
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                        BoxShadow(
                          color: const Color(0xFF1B5E20).withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ]
                          : null,
                    ),
                    child: Icon(
                      category['icon'],
                      color: isSelected ? Colors.white : const Color(0xFF5C8D6E),
                      size: 26,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category['name'],
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? const Color(0xFFD4AF37) : const Color(0xFF5C8D6E),
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
          final delay = index * 0.1;
          final animationValue = (_animationController.value - delay).clamp(0.0, 1.0);
          return Transform.translate(
            offset: Offset(0, 30 * (1 - animationValue)),
            child: Opacity(
              opacity: animationValue,
              child: child,
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF122B1A),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0xFF5C8D6E).withOpacity(0.15),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 90,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: service['gradient'],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(24),
                    topLeft: Radius.circular(24),
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: -20,
                      right: -20,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Icon(service['icon'], color: Colors.white, size: 32),
                      ),
                    ),
                  ],
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
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        service['description'],
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 11,
                          color: const Color(0xFF5C8D6E),
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0A1F12),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFD4AF37).withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              service['currency'],
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFF5C8D6E),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              service['price'],
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFD4AF37),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 1,
                              height: 14,
                              color: const Color(0xFF5C8D6E).withOpacity(0.3),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.access_time,
                              size: 12,
                              color: const Color(0xFF5C8D6E),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              service['time'],
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFF5C8D6E),
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
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF122B1A),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: const Color(0xFF5C8D6E).withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          backgroundColor: Colors.transparent,
          selectedItemColor: const Color(0xFFD4AF37),
          unselectedItemColor: const Color(0xFF5C8D6E),
          selectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.description_outlined),
              activeIcon: Icon(Icons.description_rounded),
              label: 'طلباتي',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_outlined),
              activeIcon: Icon(Icons.notifications_rounded),
              label: 'الإشعارات',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person_rounded),
              label: 'حسابي',
            ),
          ],
        ),
      ),
    );
  }
}