import 'package:flutter/material.dart';

class AdminDrawerWidget extends StatelessWidget {
  const AdminDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text('Admin'),
            accountEmail: const Text('admin@app.com'),
            currentAccountPicture: const CircleAvatar(
              child: Icon(Icons.admin_panel_settings),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text(
              'لوحة التحكم',
              textDirection: TextDirection.rtl,
            ),
            onTap: () {},
          ),

          ListTile(
            leading: const Icon(Icons.list_alt),
            title: const Text(
              'الطلبات',
              textDirection: TextDirection.rtl,
            ),
            onTap: () {},
          ),

          ListTile(
            leading: const Icon(Icons.people),
            title: const Text(
              'المستخدمين',
              textDirection: TextDirection.rtl,
            ),
            onTap: () {},
          ),

          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text(
              'الإعدادات',
              textDirection: TextDirection.rtl,
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}