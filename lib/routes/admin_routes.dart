import 'package:flutter/material.dart';

import '../screens/admin/admin_home_screen.dart';
import '../screens/admin/admin_login_screen.dart';

class AdminRoutes {

  static Route<dynamic> generateRoute(
      RouteSettings settings,
      ) {

    switch (settings.name) {

      case '/admin-login':
        return MaterialPageRoute(
          builder: (_) =>
          const AdminLoginScreen(),
        );

      case '/admin-home':
        return MaterialPageRoute(
          builder: (_) =>
          const AdminHomeScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Page Not Found'),
            ),
          ),
        );
    }
  }
}