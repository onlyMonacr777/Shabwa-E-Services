import 'package:flutter/material.dart';

import '../../models/request_model.dart';

class RequestDetailsScreen extends StatelessWidget {
  final RequestModel request;

  const RequestDetailsScreen({
    super.key,
    required this.request,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل الطلب'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              request.userName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textDirection: TextDirection.rtl,
            ),

            const SizedBox(height: 20),

            Text(
              'الخدمة: ${request.serviceName}',
              textDirection: TextDirection.rtl,
            ),

            const SizedBox(height: 12),

            Text(
              'الحالة: ${request.status}',
              textDirection: TextDirection.rtl,
            ),

            const SizedBox(height: 12),

            Text(
              'التاريخ: ${request.date}',
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
      ),
    );
  }
}