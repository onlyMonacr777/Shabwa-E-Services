import 'package:flutter/material.dart';

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final users = [
      'أحمد محمد',
      'محمد علي',
      'سالم خالد',
      'عبدالله حسن',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('المستخدمين'),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: users.length,

        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.person),
              ),

              title: Text(
                users[index],
                textDirection: TextDirection.rtl,
              ),

              subtitle: const Text(
                'مستخدم نشط',
                textDirection: TextDirection.rtl,
              ),
            ),
          );
        },
      ),
    );
  }
}