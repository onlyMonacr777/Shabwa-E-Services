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