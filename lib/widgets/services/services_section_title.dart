import 'package:flutter/material.dart';
import '/core/theme/app_theme.dart';

class ServicesSectionTitle extends StatelessWidget {
  final int servicesCount;

  const ServicesSectionTitle({
    super.key,
    required this.servicesCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildServicesCountBadge(),
          Text(
            'الخدمات المتاحة',
            style: AppTheme.titleMedium.copyWith(height: 1.2),
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }

  Widget _buildServicesCountBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.emeraldLight.withOpacity(0.4), AppTheme.primaryGreenLight.withOpacity(0.2)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.emeraldLight.withOpacity(0.6)),
      ),
      child: Text(
        '$servicesCount خدمة',
        style: AppTheme.caption.copyWith(fontSize: 14, fontWeight: FontWeight.bold),
        textDirection: TextDirection.rtl,
      ),
    );
  }
}