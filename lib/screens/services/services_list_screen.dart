import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '/core/theme/app_theme.dart';
import '../../models/service_model.dart';
import '../../providers/services_provider.dart';
import '../../providers/requests_provider.dart';

import 'package:shabwa_e_services/widgets/services/services_header.dart';
import 'package:shabwa_e_services/widgets/services/services_search_bar.dart';
import 'package:shabwa_e_services/widgets/services/services_categories.dart';
import 'package:shabwa_e_services/widgets/services/services_section_title.dart';
import 'package:shabwa_e_services/widgets/services/services_grid.dart';
import 'package:shabwa_e_services/widgets/services/services_bottom_nav.dart';

import '../home/my_requests_screen.dart';
import '../auth/profile_screen.dart';
import 'service_details_screen.dart';

class ServicesListScreen extends StatefulWidget {
  const ServicesListScreen({super.key});

  @override
  State<ServicesListScreen> createState() =>
      _ServicesListScreenState();
}

class _ServicesListScreenState
    extends State<ServicesListScreen>
    with SingleTickerProviderStateMixin {

  int _selectedIndex = 0;

  String _searchQuery = '';

  String _selectedCategory = 'الكل';

  bool _showFavoritesOnly = false;

  late AnimationController _animationController;

  @override
  void initState() {

    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animationController.forward();

    Future.microtask(() {
      context.read<RequestsProvider>().fetchRequests();
    });
  }

  @override
  void dispose() {

    _animationController.dispose();

    super.dispose();
  }

  // =========================
  // Stream المفضلات
  // =========================

  Stream<QuerySnapshot> _favoritesStream() {

    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Stream.empty();
    }

    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .orderBy('likedAt', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {

    final servicesProvider =
    context.watch<ServicesProvider>();

    final requestsProvider =
    context.watch<RequestsProvider>();

    final services =
        servicesProvider.services;

    final currentUser =
        FirebaseAuth.instance.currentUser;

    final allRequests =
        requestsProvider.requests;

    // =========================
    // طلبات المستخدم فقط
    // =========================

    final userRequests =
    allRequests.where((request) {

      try {

        final dynamicRequest =
        request as dynamic;

        return dynamicRequest.userId ==
            currentUser?.uid;

      } catch (e) {

        return false;
      }

    }).toList();

    // =========================
    // الإحصائيات الحقيقية
    // =========================

    final totalRequests =
        userRequests.length;

    final completedRequests =
        userRequests.where((request) {

          try {

            final dynamicRequest =
            request as dynamic;

            return dynamicRequest.status ==
                'completed';

          } catch (e) {

            return false;
          }

        }).length;

    final pendingRequests =
        userRequests.where((request) {

          try {

            final dynamicRequest =
            request as dynamic;

            return dynamicRequest.status ==
                'pending' ||
                dynamicRequest.status ==
                    'review';

          } catch (e) {

            return false;
          }

        }).length;

    // =========================
    // فلترة الخدمات
    // =========================

    final List<ServiceModel>
    filteredServices =
    services.where((service) {

      final matchesCategory =
          _selectedCategory == 'الكل' ||
              service.category ==
                  _selectedCategory;

      final matchesSearch =
          _searchQuery.isEmpty ||
              service.title.contains(
                  _searchQuery) ||
              service.description.contains(
                  _searchQuery);

      return matchesCategory &&
          matchesSearch;

    }).toList();

    final bottomPadding =
        MediaQuery.of(context)
            .viewPadding
            .bottom +
            100;

    return Scaffold(

      body: Container(

        decoration: BoxDecoration(
          gradient:
          AppTheme.primaryGradient,
        ),

        child: SafeArea(

          child: CustomScrollView(

            physics:
            const BouncingScrollPhysics(),

            slivers: [

              // =========================
              // الهيدر
              // =========================

              const SliverToBoxAdapter(
                child: ServicesHeader(),
              ),

              // =========================
              // الإحصائيات
              // =========================

              SliverToBoxAdapter(

                child: Padding(

                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),

                  child: Row(

                    children: [

                      Expanded(

                        child: _buildStatCard(
                          title: 'طلباتي',
                          value:
                          totalRequests
                              .toString(),
                          icon:
                          Icons.assignment,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(

                        child: _buildStatCard(
                          title: 'مكتملة',
                          value:
                          completedRequests
                              .toString(),
                          icon: Icons
                              .check_circle,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(

                        child:
                        GestureDetector(

                          onTap: () {

                            setState(() {

                              _showFavoritesOnly =
                              !_showFavoritesOnly;
                            });
                          },

                          child:
                          StreamBuilder<
                              QuerySnapshot>(

                            stream:
                            _favoritesStream(),

                            builder:
                                (context,
                                snapshot) {

                              final favoritesCount =
                                  snapshot
                                      .data
                                      ?.docs
                                      .length ??
                                      0;

                              return _buildStatCard(
                                title:
                                'المفضلة',
                                value:
                                favoritesCount
                                    .toString(),
                                icon:
                                Icons.favorite,
                                isActive:
                                _showFavoritesOnly,
                                activeColor:
                                Colors.red,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // =========================
              // المفضلات الأفقية
              // =========================

              SliverToBoxAdapter(
                child: _buildFavoritesList(),
              ),

              // =========================
              // تبويب المفضلات
              // =========================

              if (_showFavoritesOnly)

                SliverToBoxAdapter(

                  child: Padding(

                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),

                    child: Container(

                      padding:
                      const EdgeInsets.all(12),

                      margin:
                      const EdgeInsets.only(
                        bottom: 10,
                      ),

                      decoration: BoxDecoration(

                        color: Colors.red
                            .withOpacity(0.1),

                        borderRadius:
                        BorderRadius.circular(
                            12),

                        border: Border.all(
                          color: Colors.red
                              .withOpacity(
                              0.3),
                        ),
                      ),

                      child: Row(

                        children: [

                          const Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 20,
                          ),

                          const SizedBox(
                              width: 8),

                          const Expanded(

                            child: Text(
                              'عرض الخدمات المفضلة فقط',
                              style: TextStyle(
                                color:
                                Colors.white,
                                fontWeight:
                                FontWeight
                                    .bold,
                              ),
                            ),
                          ),

                          TextButton(

                            onPressed: () {

                              setState(() {
                                _showFavoritesOnly =
                                false;
                              });
                            },

                            child: const Text(
                              'إلغاء',
                              style: TextStyle(
                                color:
                                Colors.white70,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // =========================
              // البحث
              // =========================

              SliverToBoxAdapter(

                child: ServicesSearchBar(

                  onSearchChanged:
                      (value) {

                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),

              // =========================
              // التصنيفات
              // =========================

              SliverToBoxAdapter(

                child: ServicesCategories(

                  categories: const [

                    {
                      'name': 'الكل',
                      'icon':
                      Icons.grid_view_rounded,
                    },

                    {
                      'name': 'الجوازات',
                      'icon':
                      Icons.card_travel,
                    },

                    {
                      'name':
                      'الأحوال المدنية',
                      'icon':
                      Icons.people_alt,
                    },

                    {
                      'name': 'المرور',
                      'icon':
                      Icons
                          .directions_car_filled,
                    },

                    {
                      'name': 'الصحة',
                      'icon':
                      Icons.local_hospital,
                    },

                    {
                      'name': 'التعليم',
                      'icon': Icons.school,
                    },

                    {
                      'name': 'التجارة',
                      'icon':
                      Icons.business_center,
                    },
                  ],

                  selectedCategory:
                  _selectedCategory,

                  onCategorySelected:
                      (category) {

                    setState(() {
                      _selectedCategory =
                          category;
                    });
                  },
                ),
              ),

              // =========================
              // عنوان الخدمات
              // =========================

              SliverToBoxAdapter(

                child: ServicesSectionTitle(
                  servicesCount:
                  filteredServices.length,
                ),
              ),

              // =========================
              // الشبكة
              // =========================

              SliverPadding(

                padding:
                const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),

                sliver:
                _showFavoritesOnly

                    ? _buildFavoritesGrid()

                    : ServicesGrid(

                  services:
                  filteredServices,

                  animationController:
                  _animationController,

                  onServiceTap:
                      (service,
                      imagePath) {

                    Navigator.push(

                      context,

                      MaterialPageRoute(

                        builder: (_) =>
                            ServiceDetailsScreen(

                              service:
                              _prepareServiceMap(
                                service,
                                imagePath,
                              ),
                            ),
                      ),
                    );
                  },
                ),
              ),

              SliverToBoxAdapter(
                child: SizedBox(
                    height:
                    bottomPadding),
              ),
            ],
          ),
        ),
      ),

      // =========================
      // Bottom Navigation
      // =========================

      bottomNavigationBar:
      ServicesBottomNav(

        selectedIndex:
        _selectedIndex,

        onIndexChanged: (index) {

          setState(() {
            _selectedIndex = index;
          });

          if (index == 0) return;

          if (index == 1) {

            Navigator.push(

              context,

              MaterialPageRoute(
                builder: (_) =>
                const MyRequestsScreen(),
              ),
            );
          }

          if (index == 2) {

            Navigator.push(

              context,

              MaterialPageRoute(
                builder: (_) =>
                const ProfileScreen(),
              ),
            );
          }
        },
      ),
    );
  }

  // =========================
  // المفضلات الأفقية
  // =========================

  Widget _buildFavoritesList() {

    return StreamBuilder<QuerySnapshot>(

      stream: _favoritesStream(),

      builder: (context, snapshot) {

        if (!snapshot.hasData ||
            snapshot.data!.docs.isEmpty) {

          return const SizedBox.shrink();
        }

        final favorites =
            snapshot.data!.docs;

        return Container(

          margin:
          const EdgeInsets.symmetric(
            vertical: 10,
          ),

          padding:
          const EdgeInsets.all(16),

          decoration: BoxDecoration(
            color:
            Colors.white.withOpacity(0.1),
            borderRadius:
            BorderRadius.circular(16),
          ),

          child: Column(

            crossAxisAlignment:
            CrossAxisAlignment.end,

            children: [

              Row(

                mainAxisAlignment:
                MainAxisAlignment.end,

                children: const [

                  Text(
                    'خدماتي المفضلة',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                      FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(width: 8),

                  Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 20,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              SizedBox(

                height: 80,

                child:
                ListView.separated(

                  scrollDirection:
                  Axis.horizontal,

                  reverse: true,

                  itemCount:
                  favorites.length,

                  separatorBuilder:
                      (_, __) =>
                  const SizedBox(
                      width: 10),

                  itemBuilder:
                      (context, index) {

                    final fav =
                    favorites[index]
                        .data()
                    as Map<String,
                        dynamic>;

                    return _buildFavoriteChip(
                        fav);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFavoriteChip(
      Map<String, dynamic> fav) {

    return GestureDetector(

      onTap: () {

        Navigator.push(

          context,

          MaterialPageRoute(

            builder: (_) =>
                ServiceDetailsScreen(

                  service: {

                    'id':
                    fav['serviceId'] ??
                        '',

                    'title':
                    fav['title'] ?? '',

                    'category':
                    fav['category'] ??
                        '',

                    'price':
                    fav['price'] ?? 0,

                    'currency':
                    fav['currency'] ??
                        'ريال',

                    'time':
                    fav['time'] ?? '',

                    'image':
                    fav['image'] ?? '',

                    'likes': 0,

                    'requiredDocs': [
                      'صورة الهوية'
                    ],

                    'description': '',
                  },
                ),
          ),
        );
      },

      child: Container(

        padding:
        const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),

        decoration: BoxDecoration(

          gradient: LinearGradient(
            colors: [
              Colors.white
                  .withOpacity(0.2),
              Colors.white
                  .withOpacity(0.1),
            ],
          ),

          borderRadius:
          BorderRadius.circular(25),

          border: Border.all(
            color: Colors.white
                .withOpacity(0.3),
          ),
        ),

        child: Row(

          mainAxisSize:
          MainAxisSize.min,

          children: [

            const Icon(
              Icons.favorite,
              color: Colors.red,
              size: 16,
            ),

            const SizedBox(width: 8),

            Text(

              fav['title'] ?? '',

              style: const TextStyle(
                color: Colors.white,
                fontWeight:
                FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritesGrid() {
    return const SliverToBoxAdapter(
      child: SizedBox(),
    );
  }

  Map<String, dynamic> _prepareServiceMap(
      ServiceModel service,
      String imagePath) {

    return {

      'id':
      service.title.hashCode.toString(),

      'title': service.title,

      'description':
      service.description,

      'category':
      service.category,

      'price': service.price,

      'currency':
      service.currency,

      'time': service.time,

      'image': imagePath,

      'likes': 0,

      'requiredDocs':
      service.requiredDocs ??
          [
            'صورة الهوية',
            'صورة شخصية'
          ],
    };
  }

  Widget _buildStatCard({

    required String title,

    required String value,

    required IconData icon,

    bool isActive = false,

    Color? activeColor,

  }) {

    return Container(

      padding:
      const EdgeInsets.all(14),

      decoration: BoxDecoration(

        color: isActive
            ? (activeColor ??
            Colors.white)
            .withOpacity(0.2)
            : Colors.white
            .withOpacity(0.12),

        borderRadius:
        BorderRadius.circular(18),

        border: Border.all(

          color: isActive
              ? (activeColor ??
              Colors.white)
              .withOpacity(0.5)
              : Colors.white
              .withOpacity(0.15),
        ),
      ),

      child: Column(

        children: [

          Icon(

            icon,

            color: isActive
                ? (activeColor ??
                Colors.white)
                : Colors.white,

            size: 26,
          ),

          const SizedBox(height: 8),

          Text(

            value,

            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight:
              FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(

            title,

            textAlign:
            TextAlign.center,

            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}