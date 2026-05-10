import 'package:flutter/material.dart';

class ServicesBottomNav extends StatelessWidget {
  final int selectedIndex;

  final Function(int) onIndexChanged;

  const ServicesBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onIndexChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,

      onTap: onIndexChanged,

      backgroundColor: Colors.white,

      selectedItemColor: Color(0xFF014230),

      unselectedItemColor: Colors.grey,

      type: BottomNavigationBarType.fixed,

      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: 'الرئيسية',
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.assignment_rounded),
          label: 'طلباتي',
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.person_rounded),
          label: 'حسابي',
        ),
      ],
    );
  }
}