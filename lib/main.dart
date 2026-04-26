import 'package:flutter/material.dart';
import 'core/theme/app_colors.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/home/my_requests_screen.dart';
import 'screens/admin/admin_dashboard.dart';
import 'screens/services/services_list_screen.dart';

void main() {
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
    //  {'name': SplashScreen(), 'widget': const SplashScreen()},
    //  {'name': LoginScreen(), 'widget': const LoginScreen()},
    //  {'name': RegisterScreen(), 'widget': const RegisterScreen()},
    // {'name': ShabwaApp(), 'widget':  ShabwaApp()},
   //   {'name': MyRequestsScreen(), 'widget': const MyRequestsScreen()},
   //   {'name': ServicesListScreen(), 'widget': const ServicesListScreen()},
      {'name': AdminDashboard(), 'widget': const AdminDashboard()},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('معاينة الشاشات'),
        backgroundColor: AppColors.ocean,
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
                backgroundColor: AppColors.ocean,
                child: Text('${index + 1}',
                    style: const TextStyle(color: Colors.white)),
              ),
              title: Text(
                screen['name']!.runtimeType.toString().replaceAll('Screen', ''),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(
                  Icons.arrow_forward_ios, color: AppColors.ocean),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => screen['widget']!),
                );
              },
            ),
          );
        },
      ),
    );
  }}

