import 'package:flutter/material.dart';
import '/core/theme/app_theme.dart';
import '../../data/mock/service_data.dart';
import '../../models/service_model.dart';
import 'package:shabwa_e_services/widgets/services/services_header.dart';
import 'package:shabwa_e_services/widgets/services/services_search_bar.dart';
import 'package:shabwa_e_services/widgets/services/services_categories.dart';
import 'package:shabwa_e_services/widgets/services/services_section_title.dart';
import 'package:shabwa_e_services/widgets/services/services_grid.dart';
import 'package:shabwa_e_services/widgets/services/services_bottom_nav.dart';
import 'service_details_screen.dart';

class ServicesListScreen extends StatefulWidget {
  const ServicesListScreen({super.key});

  @override
  State<ServicesListScreen> createState() => _ServicesListScreenState();
}

class _ServicesListScreenState extends State<ServicesListScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  String _searchQuery = '';
  String _selectedCategory = 'الكل';
  late AnimationController _animationController;

  late final List<ServiceModel> services =
  servicesData.map((e) => ServiceModel.fromMap(e)).toList();

  List<ServiceModel> get filteredServices {
    return services.where((service) {
      final matchesCategory = _selectedCategory == 'الكل' ||
          service.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          service.title.contains(_searchQuery) ||
          service.description.contains(_searchQuery);
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
    final bottomPadding = MediaQuery
        .of(context)
        .viewPadding
        .bottom + 100;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradient,
        ),
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              const SliverToBoxAdapter(child: ServicesHeader()),
              SliverToBoxAdapter(
                child: ServicesSearchBar(
                  onSearchChanged: (value) =>
                      setState(() => _searchQuery = value),
                ),
              ),
              SliverToBoxAdapter(
                child: ServicesCategories(
                  categories: const [
                    {'name': 'الكل', 'icon': Icons.grid_view_rounded},
                    {'name': 'الجوازات', 'icon': Icons.card_travel},
                    {'name': 'الأحوال المدنية', 'icon': Icons.people_alt},
                    {'name': 'المرور', 'icon': Icons.directions_car_filled},
                    {'name': 'الصحة', 'icon': Icons.local_hospital},
                    {'name': 'التعليم', 'icon': Icons.school},
                    {'name': 'التجارة', 'icon': Icons.business_center},
                  ],
                  selectedCategory: _selectedCategory,
                  onCategorySelected: (category) =>
                      setState(() => _selectedCategory = category),
                ),
              ),
              SliverToBoxAdapter(
                child: ServicesSectionTitle(
                    servicesCount: filteredServices.length),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                sliver: ServicesGrid(
                  services: filteredServices,
                  animationController: _animationController,
                  onServiceTap: (service, imagePath) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ServiceDetailsScreen(
                              service: {
                                ...service.toMap(),
                                'image': imagePath,
                              },
                            ),
                      ),
                    );
                  },
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: bottomPadding)),
            ],
          ),
        ),
      ),


      bottomNavigationBar: ServicesBottomNav(
        selectedIndex: _selectedIndex,
        onIndexChanged: (index) {
          setState(() => _selectedIndex = index);

          // الرئيسية
          if (index == 0) {
            return;
          }

          // طلباتي
          if (index == 1) {
            Navigator.pushNamed(context, '/my-orders');
          }

          // الحساب
          if (index == 2) {
            Navigator.pushNamed(context, '/profile');
          }
        },


      ),
    );
  }
}