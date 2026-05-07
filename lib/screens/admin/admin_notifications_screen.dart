import 'package:flutter/material.dart';

class AdminNotificationsScreen
    extends StatelessWidget {

  const AdminNotificationsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final notifications = [
      'تم إرسال طلب جديد',
      'تم قبول طلب',
      'يوجد مستخدم جديد',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'الإشعارات',
        ),
      ),

      body: ListView.builder(
        itemCount: notifications.length,

        itemBuilder: (context, index) {

          return ListTile(
            leading: const Icon(
              Icons.notifications,
            ),

            title: Text(
              notifications[index],
              textDirection:
              TextDirection.rtl,
            ),
          );
        },
      ),
    );
  }
}