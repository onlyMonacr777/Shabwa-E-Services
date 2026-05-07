import 'package:flutter/material.dart';

class AdminButtonWidget
    extends StatelessWidget {

  final String text;
  final VoidCallback onTap;
  final IconData icon;

  const AdminButtonWidget({
    super.key,
    required this.text,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: double.infinity,

      child: ElevatedButton.icon(
        onPressed: onTap,

        icon: Icon(icon),

        label: Text(
          text,
          textDirection:
          TextDirection.rtl,
        ),

        style: ElevatedButton.styleFrom(
          padding:
          const EdgeInsets.all(16),

          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(
                16),
          ),
        ),
      ),
    );
  }
}