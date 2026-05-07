import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class ServiceCardWidget extends StatelessWidget {
  final Map<String, dynamic> service;
  final String imagePath;
  final VoidCallback onTap;

  const ServiceCardWidget({
    super.key,
    required this.service,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    final headingStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.bold,
    );

    final bodyStyle = Theme.of(context).textTheme.bodyMedium;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              service['title'],
              style: headingStyle,
            ),

            const SizedBox(height: 8),

            Text(
              service['description'],
              style: bodyStyle,
            ),


          ],
        ),
      ),
    );
  }}