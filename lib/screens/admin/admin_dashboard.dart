import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart' as intl;

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  Stream<QuerySnapshot> _ordersStream() {
    return FirebaseFirestore.instance
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> _changeStatus(
      String docId,
      String status,
      Map<String, dynamic> data,
      ) async {
    await FirebaseFirestore.instance.collection('orders').doc(docId).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    await FirebaseFirestore.instance.collection('notifications').add({
      'uid': data['uid'],
      'title': 'تحديث حالة الطلب',
      'body': 'تم تحديث حالة طلبك إلى: ${_statusText(status)}',
      'createdAt': FieldValue.serverTimestamp(),
      'read': false,
    });
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
        return 'تم اكتمال الطلب';
      case 'failed':
        return 'فشل الطلب';
      default:
        return 'قيد المراجعة';
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'approved':
        return const Color(0xFF22C55E);
      case 'rejected':
        return const Color(0xFFEF4444);
      case 'review':
        return const Color(0xFF3B82F6);
      case 'completed':
        return const Color(0xFF14B8A6);
      case 'failed':
        return const Color(0xFF6B7280);
      default:
        return const Color(0xFFF59E0B);
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'approved':
        return Icons.check_circle_rounded;
      case 'rejected':
        return Icons.cancel_rounded;
      case 'review':
        return Icons.visibility_rounded;
      case 'completed':
        return Icons.task_alt_rounded;
      case 'failed':
        return Icons.error_rounded;
      default:
        return Icons.pending_rounded;
    }
  }

  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return 'غير محدد';
    if (timestamp is Timestamp) {
      final date = timestamp.toDate();
      return intl.DateFormat('yyyy/MM/dd - HH:mm').format(date);
    }
    return 'غير محدد';
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF0B1120),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF0B1120),
                const Color(0xFF111827),
                const Color(0xFF1E293B).withOpacity(0.8),
              ],
            ),
          ),
          child: SafeArea(
            child: StreamBuilder<QuerySnapshot>(
              stream: _ordersStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF60A5FA),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          size: 48,
                          color: Colors.red[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'حدث خطأ في تحميل البيانات',
                          style: TextStyle(
                            color: Colors.red[300],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final docs = snapshot.data?.docs ?? [];

                if (docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 64,
                          color: Colors.white.withOpacity(0.2),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'لا توجد طلبات حالياً',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.4),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: _buildHeader(docs.length),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (context, index) {
                            final doc = docs[index];
                            final data = doc.data() as Map<String, dynamic>;
                            return _RequestCard(
                              docId: doc.id,
                              data: data,
                              statusColor: _statusColor,
                              statusText: _statusText,
                              statusIcon: _statusIcon,
                              formatDate: _formatDate,
                              onStatusChange: _changeStatus,
                            );
                          },
                          childCount: docs.length,
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 30),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(int count) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFF1E3A5F),
            Color(0xFF2563EB),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2563EB).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.admin_panel_settings_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'لوحة تحكم المشرف',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'إدارة ومراقبة جميع الطلبات',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.receipt_long_rounded,
                  color: Colors.white.withOpacity(0.8),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'إجمالي الطلبات: ',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
                Text(
                  '$count',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RequestCard extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> data;
  final Color Function(String) statusColor;
  final String Function(String) statusText;
  final IconData Function(String) statusIcon;
  final String Function(dynamic) formatDate;
  final Future<void> Function(String, String, Map<String, dynamic>) onStatusChange;

  const _RequestCard({
    required this.docId,
    required this.data,
    required this.statusColor,
    required this.statusText,
    required this.statusIcon,
    required this.formatDate,
    required this.onStatusChange,
  });

  @override
  State<_RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<_RequestCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final status = widget.data['status'] ?? 'pending';
    final color = widget.statusColor(status);

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                const Color(0xFF1E293B),
                const Color(0xFF1E293B).withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: color.withOpacity(0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Column(
              children: [
                // Status indicator bar
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        color.withOpacity(0.8),
                        color.withOpacity(0.3),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Row: Status & Menu
                      Row(
                        children: [
                          _buildStatusChip(status, color),
                          const Spacer(),
                          _buildPopupMenu(status),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Service Title
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3B82F6).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.design_services_rounded,
                              color: Color(0xFF60A5FA),
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'الخدمة',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  widget.data['serviceTitle'] ?? 'غير محدد',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // User Info
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF8B5CF6).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.person_rounded,
                              color: Color(0xFFA78BFA),
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'العميل',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  widget.data['fullName'] ?? 'غير معروف',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Date
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF59E0B).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.schedule_rounded,
                              color: Color(0xFFFBBF24),
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'تاريخ الطلب',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  widget.formatDate(widget.data['createdAt']),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Expandable Details
                      if (widget.data['description'] != null ||
                          widget.data['phone'] != null) ...[
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isExpanded = !_isExpanded;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.03),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _isExpanded
                                      ? Icons.keyboard_arrow_up_rounded
                                      : Icons.keyboard_arrow_down_rounded,
                                  color: Colors.white.withOpacity(0.5),
                                  size: 20,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _isExpanded ? 'إخفاء التفاصيل' : 'عرض التفاصيل',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.6),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        AnimatedCrossFade(
                          firstChild: const SizedBox.shrink(),
                          secondChild: _buildDetails(),
                          crossFadeState: _isExpanded
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          duration: const Duration(milliseconds: 300),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            widget.statusIcon(status),
            color: color,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            widget.statusText(status),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopupMenu(String currentStatus) {
    final items = [
      _StatusItem('approved', 'مقبول', Icons.check_circle_rounded, const Color(0xFF22C55E)),
      _StatusItem('rejected', 'مرفوض', Icons.cancel_rounded, const Color(0xFFEF4444)),
      _StatusItem('review', 'تمت المراجعة', Icons.visibility_rounded, const Color(0xFF3B82F6)),
      _StatusItem('completed', 'تم اكتمال الطلب', Icons.task_alt_rounded, const Color(0xFF14B8A6)),
      _StatusItem('failed', 'فشل الطلب', Icons.error_rounded, const Color(0xFF6B7280)),
      _StatusItem('pending', 'قيد المراجعة', Icons.pending_rounded, const Color(0xFFF59E0B)),
    ];

    return PopupMenuButton<String>(
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: const Color(0xFF1E293B),
      elevation: 8,
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(
          Icons.more_vert_rounded,
          color: Colors.white60,
          size: 20,
        ),
      ),
      onSelected: (value) => widget.onStatusChange(widget.docId, value, widget.data),
      itemBuilder: (context) => items.map((item) {
        final isSelected = item.value == currentStatus;
        return PopupMenuItem<String>(
          value: item.value,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Icon(
                  item.icon,
                  color: item.color,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  item.label,
                  style: TextStyle(
                    color: isSelected ? item.color : Colors.white.withOpacity(0.9),
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                if (isSelected) ...[
                  const Spacer(),
                  Icon(
                    Icons.check_rounded,
                    color: item.color,
                    size: 18,
                  ),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDetails() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.data['description'] != null) ...[
            _buildDetailRow(
              Icons.description_outlined,
              'الوصف',
              widget.data['description'].toString(),
            ),
            const SizedBox(height: 12),
          ],
          if (widget.data['phone'] != null)
            _buildDetailRow(
              Icons.phone_outlined,
              'رقم الهاتف',
              widget.data['phone'].toString(),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: Colors.white.withOpacity(0.4),
          size: 18,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatusItem {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  _StatusItem(this.value, this.label, this.icon, this.color);
}