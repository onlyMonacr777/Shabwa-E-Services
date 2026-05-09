import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminRequestsScreen extends StatelessWidget {
  const AdminRequestsScreen({super.key});

  // ================= UPDATE STATUS =================
  Future<void> _updateStatus(String docId, String status) async {
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(docId)
        .update({
      "status": status,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF0C1425),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0C1425),
          title: const Text("كل الطلبات"),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('orders')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  "لا توجد طلبات",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            final orders = snapshot.data!.docs;

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final doc = orders[index];
                final data = doc.data() as Map<String, dynamic>;

                return _buildOrderCard(doc.id, data);
              },
            );
          },
        ),
      ),
    );
  }

  // ================= ORDER CARD =================
  Widget _buildOrderCard(String docId, Map<String, dynamic> data) {
    final status = data['status'] ?? 'pending';

    Color statusColor;
    String statusText;

    if (status == 'approved') {
      statusColor = Colors.green;
      statusText = 'مقبول';
    } else if (status == 'rejected') {
      statusColor = Colors.red;
      statusText = 'مرفوض';
    } else {
      statusColor = Colors.orange;
      statusText = 'قيد المراجعة';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [

          // 🔹 رقم الطلب
          Text(
            "رقم الطلب: #${data['orderId'] ?? ''}",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            "الخدمة: ${data['serviceTitle'] ?? ''}",
            style: const TextStyle(color: Colors.white70),
          ),

          const SizedBox(height: 8),

          Text("الاسم: ${data['fullName'] ?? ''}",
              style: const TextStyle(color: Colors.white70)),

          Text("الهوية: ${data['idNumber'] ?? ''}",
              style: const TextStyle(color: Colors.white70)),

          Text("الجوال: ${data['phone'] ?? ''}",
              style: const TextStyle(color: Colors.white70)),

          Text("الإيميل: ${data['userEmail'] ?? ''}",
              style: const TextStyle(color: Colors.white70)),

          const SizedBox(height: 10),

          // ================= STATUS + ACTIONS =================
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              // الحالة
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: statusColor),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // أزرار التحكم
              Row(
                children: [

                  // قبول
                  IconButton(
                    icon: const Icon(Icons.check_circle,
                        color: Colors.green),
                    onPressed: () {
                      _updateStatus(docId, "approved");
                    },
                  ),

                  // رفض
                  IconButton(
                    icon: const Icon(Icons.cancel,
                        color: Colors.red),
                    onPressed: () {
                      _updateStatus(docId, "rejected");
                    },
                  ),

                  // قيد المراجعة
                  IconButton(
                    icon: const Icon(Icons.hourglass_empty,
                        color: Colors.orange),
                    onPressed: () {
                      _updateStatus(docId, "pending");
                    },
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}