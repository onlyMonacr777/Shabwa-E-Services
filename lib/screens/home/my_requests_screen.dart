import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyRequestsScreen extends StatefulWidget {
  const MyRequestsScreen({super.key});

  @override
  State<MyRequestsScreen> createState() => _MyRequestsScreenState();
}

class _MyRequestsScreenState extends State<MyRequestsScreen> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        title: const Text(
          'طلباتي',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color(0xFF0E7A4A),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),

      body: Column(
        children: [

          // ================= البحث =================

          Container(
            padding: const EdgeInsets.all(16),

            child: Row(
              children: [

                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),

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
                      children: const [

                        Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),

                        SizedBox(width: 10),

                        Text(
                          'طلباتك الإلكترونية',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // ================= العدد =================

                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('orders')
                      .where('uid', isEqualTo: user?.uid)
                      .snapshots(),

                  builder: (context, snapshot) {

                    int total =
                        snapshot.data?.docs.length ?? 0;

                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),

                      decoration: BoxDecoration(
                        color: const Color(0xFF0E7A4A)
                            .withOpacity(0.1),

                        borderRadius:
                        BorderRadius.circular(25),
                      ),

                      child: Row(
                        mainAxisSize: MainAxisSize.min,

                        children: [

                          const Icon(
                            Icons.layers,
                            color: Color(0xFF0E7A4A),
                            size: 20,
                          ),

                          const SizedBox(width: 6),

                          Text(
                            total.toString(),

                            style: const TextStyle(
                              color: Color(0xFF0E7A4A),
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
          ),

          // ================= Tabs =================

          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 16),

            child: Row(
              children: [

                Expanded(
                  child: _tabButton(
                    'نشطة',
                    0,
                    Colors.orange,
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: _tabButton(
                    'مكتملة',
                    1,
                    Colors.green,
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: _tabButton(
                    'ملغية',
                    2,
                    Colors.red,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ================= الطلبات =================

          Expanded(
            child: StreamBuilder<QuerySnapshot>(

              stream: FirebaseFirestore.instance
                  .collection('orders')
                  .where('uid', isEqualTo: user?.uid)
                  .snapshots(),

              builder: (context, snapshot) {

                // تحميل
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {

                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // لا يوجد بيانات
                if (!snapshot.hasData ||
                    snapshot.data!.docs.isEmpty) {

                  return _emptyState();
                }

                // ================= البيانات =================

                final docs = snapshot.data!.docs;

                // ترتيب من الأحدث للأقدم
                docs.sort((a, b) {

                  final aData =
                  a.data() as Map<String, dynamic>;

                  final bData =
                  b.data() as Map<String, dynamic>;

                  final aTime = aData['createdAt'];
                  final bTime = bData['createdAt'];

                  if (aTime == null || bTime == null) {
                    return 0;
                  }

                  return (bTime as Timestamp)
                      .compareTo(aTime as Timestamp);
                });

                // ================= الفلترة =================

                final filteredDocs =
                docs.where((doc) {

                  final data =
                  doc.data() as Map<String, dynamic>;

                  final status =
                      data['status'] ?? 'pending';

                  // نشطة
                  if (selectedTab == 0) {

                    return status == 'pending' ||
                        status == 'approved';
                  }

                  // مكتملة
                  if (selectedTab == 1) {

                    return status == 'completed';
                  }

                  // ملغية
                  return status == 'rejected';

                }).toList();

                if (filteredDocs.isEmpty) {
                  return _emptyState();
                }

                return ListView.separated(

                  padding: const EdgeInsets.all(16),

                  itemCount: filteredDocs.length,

                  separatorBuilder: (_, __) =>
                  const SizedBox(height: 16),

                  itemBuilder: (context, index) {

                    final data =
                    filteredDocs[index].data()
                    as Map<String, dynamic>;

                    return _requestCard(data);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ================= EMPTY =================

  Widget _emptyState() {

    return Center(
      child: Column(
        mainAxisAlignment:
        MainAxisAlignment.center,

        children: [

          Icon(
            Icons.inbox_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),

          const SizedBox(height: 16),

          const Text(
            'لا توجد طلبات',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            'ستظهر طلباتك هنا',
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  // ================= TAB BUTTON =================

  Widget _tabButton(
      String title,
      int index,
      Color color,
      ) {

    bool active = selectedTab == index;

    return GestureDetector(

      onTap: () {

        setState(() {
          selectedTab = index;
        });
      },

      child: Container(

        padding: const EdgeInsets.symmetric(
          vertical: 14,
        ),

        decoration: BoxDecoration(

          color: active
              ? color.withOpacity(0.15)
              : Colors.transparent,

          borderRadius: BorderRadius.circular(25),

          border: active
              ? Border.all(
            color: color,
            width: 2,
          )
              : null,
        ),

        child: Text(

          title,

          textAlign: TextAlign.center,

          style: TextStyle(
            fontWeight: active
                ? FontWeight.bold
                : FontWeight.normal,

            color: active
                ? color
                : Colors.grey[600],

            fontSize: 14,
          ),
        ),
      ),
    );
  }

  // ================= CARD =================

  Widget _requestCard(
      Map<String, dynamic> request,
      ) {

    final status =
        request['status'] ?? 'pending';

    Color statusColor;
    String statusText;
    double progress;

    // approved
    if (status == 'approved') {

      statusColor = Colors.blue;
      statusText = 'مقبول';
      progress = 0.7;
    }

    // completed
    else if (status == 'completed') {

      statusColor = Colors.green;
      statusText = 'مكتمل';
      progress = 1.0;
    }

    // rejected
    else if (status == 'rejected') {

      statusColor = Colors.red;
      statusText = 'ملغي';
      progress = 0.2;
    }

    // pending
    else {

      statusColor = Colors.orange;
      statusText = 'قيد المراجعة';
      progress = 0.4;
    }

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
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            // ================= Header =================

            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,

              children: [

                Container(

                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),

                  decoration: BoxDecoration(

                    color: const Color(0xFF0E7A4A)
                        .withOpacity(0.2),

                    borderRadius:
                    BorderRadius.circular(20),
                  ),

                  child: Text(

                    request['orderId'] ?? '',

                    style: const TextStyle(
                      color: Color(0xFF0E7A4A),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),

                Text(

                  statusText,

                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ================= Title =================

            Text(

              request['serviceTitle'] ?? '',

              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 20),

            // ================= Progress =================

            LinearProgressIndicator(

              value: progress,

              backgroundColor: Colors.grey[300],

              valueColor:
              AlwaysStoppedAnimation<Color>(
                statusColor,
              ),

              minHeight: 8,
            ),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,

              children: [

                Text(

                  statusText,

                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),

                Text(

                  '${(progress * 100).toInt()}%',

                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ================= التفاصيل =================

            SizedBox(

              width: double.infinity,

              child: ElevatedButton(

                onPressed: () {

                  showDialog(

                    context: context,

                    builder: (_) {

                      return AlertDialog(

                        title:
                        const Text('تفاصيل الطلب'),

                        content: Column(

                          mainAxisSize: MainAxisSize.min,

                          crossAxisAlignment:
                          CrossAxisAlignment.start,

                          children: [

                            Text(
                              'الخدمة: ${request['serviceTitle']}',
                            ),

                            Text(
                              'الحالة: $statusText',
                            ),

                            Text(
                              'رقم الطلب: ${request['orderId']}',
                            ),

                            Text(
                              'الاسم: ${request['fullName']}',
                            ),
                          ],
                        ),

                        actions: [

                          TextButton(

                            onPressed: () {
                              Navigator.pop(context);
                            },

                            child:
                            const Text('إغلاق'),
                          ),
                        ],
                      );
                    },
                  );
                },

                style: ElevatedButton.styleFrom(

                  backgroundColor:
                  const Color(0xFF0E7A4A),

                  foregroundColor: Colors.white,

                  padding:
                  const EdgeInsets.symmetric(
                    vertical: 16,
                  ),

                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(12),
                  ),

                  elevation: 2,
                ),

                child: const Text(
                  'عرض التفاصيل',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}