import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

void main() {
  runApp(ShabwaApp());
}

class ShabwaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'بوابة شبوة',
      debugShowCheckedModeBanner: false,
      theme: ShabwaTheme.lightTheme,
      darkTheme: ShabwaTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: HomeScreen(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// 1. نظام الألوان والثيم
// ═══════════════════════════════════════════════════════════════
class ShabwaTheme {
  static ThemeData get lightTheme => ThemeData(
    primaryColor: _primaryGreen,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _primaryGreen,
      brightness: Brightness.light,
    ),
    textTheme: GoogleFonts.cairoTextTheme(),
    useMaterial3: true,
    scaffoldBackgroundColor: _backgroundLight,
  );

  static ThemeData get darkTheme => ThemeData(
    primaryColor: _primaryGreenDark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _primaryGreenDark,
      brightness: Brightness.dark,
    ),
    textTheme: GoogleFonts.cairoTextTheme().apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ),
    useMaterial3: true,
    scaffoldBackgroundColor: _backgroundDark,
  );

  static const Color _primaryGreen = Color(0xFF2E7D32);
  static const Color _primaryGreenLight = Color(0xFF4CAF50);
  static const Color _primaryGreenDark = Color(0xFF1B5E20);
  static const Color _secondaryBlue = Color(0xFF1976D2);
  static const Color _backgroundLight = Color(0xFFFAFAFA);
  static const Color _backgroundDark = Color(0xFF121212);
}

// ═══════════════════════════════════════════════════════════════
// 2. شاشة الرئيسية الرئيسية
// ═══════════════════════════════════════════════════════════════
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _fabController;
  int _currentIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fabController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    Future.delayed(Duration(seconds: 2), () {
      setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() => _isLoading = true);
          await Future.delayed(Duration(seconds: 1));
          setState(() => _isLoading = false);
        },
        child: CustomScrollView(
          slivers: [
            _buildHeaderSliver(),
            _buildSearchSliver(),
            _buildQuickServicesSliver(),
            _buildMyServicesSliver(),
            _buildCarouselSliver(),
          ],
        ),
      ),
      // ✅ FAB فوق الشريط السفلي بدون تداخل
      floatingActionButton: _buildFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      // ✅ Bottom Navigation مُصحح
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // الهيدر
  Widget _buildHeaderSliver() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(0xFF1B5E20),
                Color(0xFF2E7D32),
              ],
            ),
          ),
          child: SafeArea(
            child: Row(
              children: [
                // شعار
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.account_balance,
                      color: Colors.white, size: 24),
                ),
                SizedBox(width: 16),
                // التحية
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'أهلاً بك',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Colors.white, Color(0xFFE8F5E8)],
                        ).createShader(bounds),
                        blendMode: BlendMode.srcIn,
                        child: Text(
                          'منى صالح',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                    ],
                  ),
                ),
                // الإشعارات
                Stack(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.notifications_outlined, color: Colors.white),
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text('3',
                            style: TextStyle(color: Colors.white, fontSize: 10)),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 8),
                // Avatar
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=3'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // شريط البحث
  Widget _buildSearchSliver() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // شريط البحث
            Container(
              height: 56,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                textDirection: TextDirection.rtl,
                decoration: InputDecoration(
                  hintTextDirection: TextDirection.rtl,
                  hintText: 'ابحث عن خدمة...',
                  prefixIcon: Icon(Icons.search,
                      color: ShabwaColors.textSecondary),
                  suffixIcon: Icon(Icons.tune,
                      color: ShabwaColors.primaryGreen),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                ),
              ),
            ),
            SizedBox(height: 16),
            // اقتراحات سريعة
            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildSuggestionChip('بطاقة شخصية'),
                  SizedBox(width: 12),
                  _buildSuggestionChip('جواز سفر'),
                  SizedBox(width: 12),
                  _buildSuggestionChip('شهادة ميلاد'),
                  SizedBox(width: 12),
                  _buildSuggestionChip('ترخيص تجاري'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionChip(String text) {
    return FilterChip(
      label: Text(text),
      selected: false,
      onSelected: (_) {},
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  // الخدمات السريعة
  Widget _buildQuickServicesSliver() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الخدمات السريعة',
              style: Theme.of(context).textTheme.headlineSmall!
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            if (_isLoading)
              _buildSkeletonGrid()
            else
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildQuickServiceCard(
                    icon: Icons.card_membership,
                    title: 'استخراج بطاقة',
                    count: 2,
                  ),
                  _buildQuickServiceCard(
                    icon: Icons.password,
                    title: 'تجديد جواز',
                    count: 1,
                  ),
                  _buildQuickServiceCard(
                    icon: Icons.child_care,
                    title: 'شهادة ميلاد',
                    count: 0,
                  ),
                  _buildQuickServiceCard(
                    icon: Icons.store,
                    title: 'ترخيص تجاري',
                    count: 3,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickServiceCard({
    required IconData icon,
    required String title,
    required int count,
  }) {
    return GestureDetector(
      onTap: () {},
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.surfaceVariant!,
              Theme.of(context).colorScheme.surfaceVariant!.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: ShabwaColors.primaryGreen.withOpacity(0.1),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ShabwaColors.primaryGreen.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon,
                        color: ShabwaColors.primaryGreen, size: 28),
                  ),
                  SizedBox(height: 12),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (count > 0) ...[
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: ShabwaColors.primaryGreen,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '($count نشط)',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // خدماتي
  Widget _buildMyServicesSliver() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'خدماتي',
              style: Theme.of(context).textTheme.headlineSmall!
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TabBar(
              controller: _tabController,
              labelColor: ShabwaColors.primaryGreen,
              unselectedLabelColor: ShabwaColors.textSecondary,
              indicatorColor: ShabwaColors.primaryGreen,
              tabs: [
                Tab(text: 'الطلبات النشطة'),
                Tab(text: 'الطلبات المكتملة'),
              ],
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: _isLoading
                  ? _buildSkeletonList()
                  : TabBarView(
                controller: _tabController,
                children: [
                  _buildActiveRequests(),
                  _buildCompletedRequests(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveRequests() {
    return ListView(
      children: [
        _buildRequestCard(
          id: '12345',
          title: 'استخراج بطاقة شخصية',
          progress: 0.75,
          status: RequestStatus.reviewing,
          date: '2024-01-15',
        ),
        _buildRequestCard(
          id: '12346',
          title: 'تجديد جواز سفر',
          progress: 0.3,
          status: RequestStatus.accepted,
          date: '2024-01-14',
        ),
      ],
    );
  }

  Widget _buildCompletedRequests() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline,
              size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'لا توجد طلبات مكتملة',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            'ستظهر طلباتك المكتملة هنا',
            style: Theme.of(context).textTheme.bodyMedium!
                ?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCard({
    required String id,
    required String title,
    required double progress,
    required RequestStatus status,
    required String date,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        title: Text('$id - $title'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                status == RequestStatus.reviewing
                    ? Colors.orange
                    : status == RequestStatus.accepted
                    ? Colors.green
                    : Colors.red,
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  status == RequestStatus.reviewing
                      ? 'قيد المراجعة'
                      : status == RequestStatus.accepted
                      ? 'مقبول'
                      : 'مرفوض',
                  style: TextStyle(
                    color: status == RequestStatus.reviewing
                        ? Colors.orange
                        : status == RequestStatus.accepted
                        ? Colors.green
                        : Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(date),
              ],
            ),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () {},
          child: Text('تفاصيل'),
        ),
      ),
    );
  }

  // Carousel الإعلانات
  Widget _buildCarouselSliver() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الإعلانات والأخبار',
              style: Theme.of(context).textTheme.titleLarge!
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 160,
              child: PageView(
                children: [
                  _buildCarouselItem(
                    title: 'خدمة جديدة: تسجيل مدني إلكتروني',
                    image: 'https://picsum.photos/400/160?random=1',
                  ),
                  _buildCarouselItem(
                    title: 'تحديث نظام الدفع الإلكتروني',
                    image: 'https://picsum.photos/400/160?random=2',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarouselItem({
    required String title,
    required String image,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: NetworkImage(image),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.7),
              Colors.transparent,
            ],
          ),
        ),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium!
                  ?.copyWith(color: Colors.white),
              textAlign: TextAlign.right,
            ),
          ),
        ),
      ),
    );
  }

  // Skeleton Loading
  Widget _buildSkeletonGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: List.generate(4, (index) => _buildSkeletonCard()),
    );
  }
  Widget _buildSkeletonList() {
    return ListView.separated(
      itemCount: 3,
      separatorBuilder: (_, __) => SizedBox(height: 12),
      itemBuilder: (_, index) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Card(
          child: ListTile(
            contentPadding: EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: Colors.grey[300],
              radius: 20,
            ),
            title: Container(
              height: 16,
              width: double.infinity,
              color: Colors.grey[300],
            ),
            subtitle: Container(
              height: 12,
              width: 120,
              margin: EdgeInsets.only(top: 8),
              color: Colors.grey[300],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSkeletonCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(height: 12),
            Container(
              height: 16,
              width: 80,
              color: Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }

  // ✅ FAB مُصحح - فوق الشريط السفلي تماماً
  Widget _buildFab() {
    return ScaleTransition(
      scale: Tween(begin: 1.0, end: 1.1).animate(
        CurvedAnimation(parent: _fabController, curve: Curves.easeInOut),
      ),
      child: FloatingActionButton.extended(
        onPressed: () {
          HapticFeedback.heavyImpact();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('🟢 طلب جديد'),
              backgroundColor: ShabwaColors.primaryGreen,
              duration: Duration(seconds: 1),
            ),
          );
        },
        backgroundColor: ShabwaColors.primaryGreen,
        foregroundColor: Colors.white,
        icon: Icon(Icons.add),
        label: Text(
          'طلب جديد',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 8,
        highlightElevation: 12, // ✅ تأثير الضغط
        hoverElevation: 10,
        focusElevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        heroTag: 'new_request',
      ),
    );
  }

  // ✅ Bottom Navigation مُصحح تماماً - شكل مقوس للفاب
  Widget _buildBottomNav() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(child: SizedBox()), // مسافة يسار
          _buildNavItem(Icons.home, 'الرئيسية', 0, _currentIndex),
          _buildNavItem(Icons.apps, 'الخدمات', 1, _currentIndex),
          // ✅ FAB في الوسط مع شكل مقوس
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
          ),
          _buildNavItem(Icons.notifications, 'الإشعارات', 3, _currentIndex),
          _buildNavItem(Icons.person, 'حسابي', 4, _currentIndex),
          Expanded(child: SizedBox()), // مسافة يمين
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index, int currentIndex) {
    final bool isActive = index == currentIndex;
    return GestureDetector(
      onTap: () {
        setState(() => _currentIndex = index);
        HapticFeedback.lightImpact();
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isActive ? ShabwaColors.primaryGreen.withOpacity(0.1) : null,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? ShabwaColors.primaryGreen : Colors.grey,
              size: 24,
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? ShabwaColors.primaryGreen : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _fabController.dispose();
    super.dispose();
  }
}

// ═══════════════════════════════════════════════════════════════
// 3. Enums و Constants
// ═══════════════════════════════════════════════════════════════
enum RequestStatus { reviewing, accepted, rejected }

class ShabwaColors {
  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color primaryGreenLight = Color(0xFF4CAF50);
  static const Color secondaryBlue = Color(0xFF1976D2);
  static const Color textSecondary = Color(0xFF757575);
}

// ═══════════════════════════════════════════════════════════════
// 4. شاشات أخرى (للتنقل)
// ═══════════════════════════════════════════════════════════════
class ServicesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الخدمات'),
        backgroundColor: ShabwaColors.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text(
          'شاشة الخدمات',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الإشعارات'),
        backgroundColor: ShabwaColors.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text(
          'شاشة الإشعارات',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('حسابي'),
        backgroundColor: ShabwaColors.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text(
          'شاشة الحساب',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}