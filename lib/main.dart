import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/main.dart';

import 'firebase_options.dart';

import 'providers/auth_provider.dart';
import 'providers/navigation_provider.dart';
import 'providers/requests_provider.dart';
import 'providers/services_provider.dart';

import 'screens/splash/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/admin/admin_dashboard.dart';
import 'screens/services/services_list_screen.dart' hide AdminDashboard;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => NavigationProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ServicesProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => RequestsProvider(),
        ),
      ],
      child: const ShabwaEServicesApp(),
    );
  }
}

class ShabwaEServicesApp extends StatelessWidget {
  const ShabwaEServicesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'بوابة شبوة للخدمات الإلكترونية',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const AppStartup(),
    );
  }
}

class AppStartup extends StatefulWidget {
  const AppStartup({super.key});

  @override
  State<AppStartup> createState() => _AppStartupState();
}

class _AppStartupState extends State<AppStartup> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await Future.delayed(
      const Duration(seconds: 3),
    );

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const SplashFlowHandler(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}

class SplashFlowHandler extends StatelessWidget {
  const SplashFlowHandler({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider =
    Provider.of<AuthProvider>(context);

    if (!authProvider.isLoggedIn) {
      return const LoginScreen();
    }

    final bool isAdmin =
        authProvider.userRole == 'admin';

    if (isAdmin) {
      return const AdminDashboard();
    }

    return const ServicesListScreen();
  }
}