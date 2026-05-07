import 'package:flutter/material.dart';

import '../../widgets/admin/admin_stat_card.dart';
import 'admin_requests_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة المشرف'),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: AdminStatCard(
                    title: 'الطلبات',
                    value: '24',
                    icon: Icons.description,
                    color: Colors.blue,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: AdminStatCard(
                    title: 'معلقة',
                    value: '10',
                    icon: Icons.access_time,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: AdminStatCard(
                    title: 'مقبولة',
                    value: '8',
                    icon: Icons.check_circle,
                    color: Colors.green,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: AdminStatCard(
                    title: 'مرفوضة',
                    value: '6',
                    icon: Icons.cancel,
                    color: Colors.red,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                      const AdminRequestsScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.list),
                label: const Text('عرض الطلبات'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}