import 'package:flutter/material.dart';
import '../routes/app_router.dart';

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: AppRouter.onGenerate,
      initialRoute: '/admin-login',
    );
  }
}