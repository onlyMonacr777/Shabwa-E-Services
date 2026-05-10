import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart' as intl;

class MyRequestsScreen extends StatefulWidget {
  const MyRequestsScreen({super.key});

  @override
  State<MyRequestsScreen> createState() => _MyRequestsScreenState();
}

class _MyRequestsScreenState extends State<MyRequestsScreen>
    with SingleTickerProviderStateMixin {
  int _selectedTab = 0;
  String _searchQuery = '';

  final _searchController = TextEditingController();

  late AnimationController _animCtrl;
  late Animation<double> _fade;

  final List<String> _tabs = ['الكل', 'نشطة', 'مكتملة', 'ملغية'];

  // ✅ قائمة محلية للطلبات (تبقى ظاهرة حتى بعد التحديث)
  List<QueryDocumentSnapshot> _localDocs = [];

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut),
    );
    _animCtrl.forward();
  }

  String _statusText(String status) {
    switch (status) {
      case 'approved':
        return 'مقبول';
      case 'rejected':
        return 'مرفوض';
      case 'review':
        return 'تمت المراجعة';
      case 'completed':
        return 'مكتمل';
      case 'failed':
        return 'فشل';
      default:
        return 'قيد المراجعة';
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'approved':
        return const Color(0xFF0E7A4A);
      case 'rejected':
        return Colors.red;
      case 'review':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'failed':
        return Colors.grey;
      default:
        return Colors.orange;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'approved':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      case 'review':
        return Icons.visibility;
      case 'completed':
        return Icons.task_alt;
      case 'failed':
        return Icons.error;
      default:
        return Icons.pending;
    }
  }

  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return 'غير محدد';
    if (timestamp is Timestamp) {
      return intl.DateFormat('yyyy/MM/dd').format(timestamp.toDate());
    }
    return 'غير محدد';
  }

  bool _matchesTab(String status) {
    switch (_selectedTab) {
      case 1: // نشطة
        return status == 'pending' || status == 'approved' || status == 'review';
      case 2: // مكتملة
        return status == 'completed';
      case 3: // ملغية
        return status == 'rejected' || status == 'failed';
      default: // الكل
        return true;
    }
  }

  bool _matchesSearch(Map<String, dynamic> data) {
    if (_searchQuery.isEmpty) return true;
    final query = _searchQuery.toLowerCase();
    final serviceTitle = (data['serviceTitle'] ?? '').toString().toLowerCase();
    final orderId = (data['orderId'] ?? '').toString().toLowerCase();
    final fullName = (data['fullName'] ?? '').toString().toLowerCase();
    return serviceTitle.contains(query) ||
        orderId.contains(query) ||
        fullName.contains(query);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        appBar: AppBar(
          title: const Text(
            'طلباتي',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          backgroundColor: const Color(0xFF014230),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: Column(
          children: [
            _buildSearchBar(user),
            _buildTabs(),
            const SizedBox(height: 12),
            Expanded(
              // ✅ استخدم FutureBuilder بدل StreamBuilder لتجنب الاختفاء
              child: _buildOrdersList(user),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ دالة جديدة: بناء قائمة الطلبات مع الحفاظ عليها
  Widget _buildOrdersList(User? user) {
    if (user == null) {
      return _buildEmptyState();
    }

    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('orders')
          .where('uid', isEqualTo: user.uid)
          .get(),
      builder: (context, snapshot) {
        // ✅ تحديث القائمة المحلية فقط إذا فيه بيانات جديدة
        if (snapshot.hasData && snapshot.data != null) {
          _localDocs = snapshot.data!.docs;
        }

        // ✅ إذا القائمة المحلية فيها بيانات، نستخدمها
        if (_localDocs.isNotEmpty) {
          return _buildListFromDocs(_localDocs);
        }

        // ✅ إذا فيه loading وما فيه بيانات محلية
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF014230),
            ),
          );
        }

        // ✅ فعلاً ما فيه بيانات
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState();
        }

        return _buildListFromDocs(snapshot.data!.docs);
      },
    );
  }

  // ✅ دالة مساعدة: بناء القائمة من الـ docs
  Widget _buildListFromDocs(List<QueryDocumentSnapshot> docs) {
    final filtered = docs.where((d) {
      final data = d.data() as Map<String, dynamic>;
      return _matchesTab(data['status'] ?? 'pending') &&
          _matchesSearch(data);
    }).toList();

    if (filtered.isEmpty) {
      return _buildEmptyState(isSearch: _searchQuery.isNotEmpty);
    }

    return FadeTransition(
      opacity: _fade,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: filtered.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final data = filtered[index].data() as Map<String, dynamic>;
          return _buildOrderCard(filtered[index].id, data);
        },
      ),
    );
  }

  Widget _buildSearchBar(User? user) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() => _searchQuery = value);
                      },
                      decoration: const InputDecoration(
                        hintText: 'ابحث في طلباتك...',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  if (_searchQuery.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                      child: Icon(
                        Icons.close,
                        color: Colors.grey.shade400,
                        size: 20,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          // ✅ عدّلنا الـ StreamBuilder هنا أيضاً
          FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection('orders')
                .where('uid', isEqualTo: user?.uid)
                .get(),
            builder: (context, snapshot) {
              final total = snapshot.data?.docs.length ?? _localDocs.length;
              return Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF014230).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.layers,
                      color: Color(0xFF014230),
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      total.toString(),
                      style: const TextStyle(
                        color: Color(0xFF014230),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(child: _tabButton('الكل', 0, Colors.orange)),
          const SizedBox(width: 8),
          Expanded(child: _tabButton('نشطة', 1, Colors.green)),
          const SizedBox(width: 8),
          Expanded(child: _tabButton('مكتملة', 2, Colors.blue)),
          const SizedBox(width: 8),
          Expanded(child: _tabButton('ملغية', 3, Colors.red)),
        ],
      ),
    );
  }

  Widget _tabButton(String title, int index, Color color) {
    final active = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: active ? color.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          border: active ? Border.all(color: color, width: 2) : null,
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
            color: active ? color : Colors.grey[600],
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(String docId, Map<String, dynamic> data) {
    final status = data['status'] ?? 'pending';
    final color = _statusColor(status);
    final progress = status == 'completed'
        ? 1.0
        : status == 'approved'
        ? 0.7
        : status == 'rejected'
        ? 0.2
        : 0.4;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF014230).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '#${data['orderId'] ?? docId.substring(0, 6)}',
                    style: const TextStyle(
                      color: Color(0xFF014230),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: color.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_statusIcon(status), color: color, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        _statusText(status),
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              data['serviceTitle'] ?? '',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  color: Colors.grey.shade400,
                  size: 14,
                ),
                const SizedBox(width: 6),
                Text(
                  _formatDate(data['createdAt']),
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${(progress * 100).toInt()}% مكتمل',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  _statusText(status),
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showDetails(data, status, color),
                icon: const Icon(Icons.info_outline, size: 18),
                label: const Text('عرض التفاصيل'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF014230),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetails(
      Map<String, dynamic> data, String status, Color color) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.85,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: ListView(
            controller: controller,
            padding: const EdgeInsets.all(24),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(_statusIcon(status), color: color, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _statusText(status),
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '#${data['orderId'] ?? 'غير محدد'}',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildDetailTile(
                Icons.design_services_rounded,
                'الخدمة',
                data['serviceTitle'] ?? 'غير محدد',
              ),
              _buildDetailTile(
                Icons.person_rounded,
                'الاسم',
                data['fullName'] ?? 'غير معروف',
              ),
              _buildDetailTile(
                Icons.phone_rounded,
                'الهاتف',
                data['phone'] ?? 'غير محدد',
              ),
              _buildDetailTile(
                Icons.email_rounded,
                'البريد الإلكتروني',
                data['email'] ?? 'غير محدد',
              ),
              _buildDetailTile(
                Icons.calendar_today_rounded,
                'تاريخ الطلب',
                _formatDate(data['createdAt']),
              ),
              if (data['description'] != null)
                _buildDetailTile(
                  Icons.description_rounded,
                  'الوصف',
                  data['description'].toString(),
                ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF014230),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'إغلاق',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailTile(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF014230).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF014230), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({bool isSearch = false}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSearch ? Icons.search_off_rounded : Icons.inbox_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            isSearch ? 'لا توجد نتائج' : 'لا توجد طلبات',
            style: const TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            isSearch
                ? 'جرب كلمات بحث مختلفة'
                : 'ستظهر طلباتك هنا',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _searchController.dispose();
    super.dispose();
  }
}