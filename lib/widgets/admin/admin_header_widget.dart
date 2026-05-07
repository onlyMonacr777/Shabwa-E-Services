import 'package:flutter/material.dart';

class AdminHeaderWidget
    extends StatelessWidget {

  final String title;
  final String subtitle;

  const AdminHeaderWidget({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,

      padding:
      const EdgeInsets.all(20),

      decoration: BoxDecoration(
        borderRadius:
        BorderRadius.circular(20),

        gradient: const LinearGradient(
          colors: [
            Colors.green,
            Colors.teal,
          ],
        ),
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.end,

        children: [
          Text(
            title,

            textDirection:
            TextDirection.rtl,

            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight:
              FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            subtitle,

            textDirection:
            TextDirection.rtl,

            style: const TextStyle(
              color: Colors.white70,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}