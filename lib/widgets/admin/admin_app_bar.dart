import 'package:flutter/material.dart';

class AdminAppBar extends StatelessWidget
    implements PreferredSizeWidget {

  final String title;

  const AdminAppBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,

      title: Text(
        title,
        textDirection: TextDirection.rtl,
      ),
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight);
}