import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

import 'core/theme/app_colors.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/home/my_requests_screen.dart';
import 'screens/admin/admin_dashboard.dart';
import 'screens/services/services_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'بوابة شبوة - Preview',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const PreviewScreen(),
    );
  }
}

// ========== شاشة المعاينة ==========
class PreviewScreen extends StatelessWidget {
  const PreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, Widget>> screens = [
      {
        'name': const SplashScreen(),
        'widget': const SplashScreen(),
      },
      {
        'name': LoginScreen(),
        'widget': LoginScreen(),
      },
      {
        'name': const RegisterScreen(),
        'widget': const RegisterScreen(),
      },
      {
        'name': MyRequestsScreen(),
        'widget': MyRequestsScreen(),
      },
      {
        'name': const ServicesListScreen(),
        'widget': const ServicesListScreen(),
      },
      {
        'name': const AdminDashboard(),
        'widget': const AdminDashboard(),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('معاينة الشاشات'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: screens.length,
        itemBuilder: (context, index) {
          final screen = screens[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(
                screen['name']!.runtimeType
                    .toString()
                    .replaceAll('Screen', ''),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.blueGrey,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => screen['widget']!,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}