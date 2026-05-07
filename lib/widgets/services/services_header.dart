import 'package:flutter/material.dart';
import '/core/theme/app_theme.dart';

class ServicesHeader extends StatelessWidget {
  const ServicesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNotificationButton(),
              _buildGreeting(),
            ],
          ),
          const SizedBox(height: 24),
          _buildStatsCard(),
        ],
      ),
    );
  }

  Widget _buildNotificationButton() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.white.withOpacity(0.2), AppTheme.white.withOpacity(0.1)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.white.withOpacity(0.6), width: 2),
        boxShadow: [AppTheme.primaryShadow],
      ),
      child: Stack(
        children: [
          Icon(Icons.notifications_outlined, color: AppTheme.emeraldLight, size: 24),
          Positioned(
            right: 4,
            top: 4,
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'مرحباً، أحمد',
          style: AppTheme.titleMedium.copyWith(height: 1.2),
          textDirection: TextDirection.rtl,
        ),
        const SizedBox(height: 4),
        Text(
          'سعيد بعودتك مرة أخرى',
          style: AppTheme.bodyMedium.copyWith(fontSize: 14),
          textDirection: TextDirection.rtl,
        ),
      ],
    );
  }

  Widget _buildStatsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.white.withOpacity(0.25), AppTheme.white.withOpacity(0.15)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.white.withOpacity(0.6), width: 2),
        boxShadow: [AppTheme.primaryShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNewBadge(),
              Text(
                'إحصائيات طلباتك',
                style: AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                textDirection: TextDirection.rtl,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _statItem('طلباتي', '3', Icons.folder_open_outlined)),
              Container(width: 1, height: 50, color: AppTheme.white.withOpacity(0.3)),
              Expanded(child: _statItem('مكتملة', '1', Icons.check_circle_outline)),
              Container(width: 1, height: 50, color: AppTheme.white.withOpacity(0.3)),
              Expanded(child: _statItem('قيد المراجعة', '2', Icons.access_time)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNewBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.emeraldLight.withOpacity(0.3), AppTheme.emeraldLight.withOpacity(0.1)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.emeraldLight.withOpacity(0.5), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'جديد',
            style: AppTheme.caption.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 6),
          Icon(Icons.circle, color: AppTheme.white, size: 8),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.emeraldLight.withOpacity(0.3), AppTheme.primaryGreenLight.withOpacity(0.2)],
            ),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppTheme.white, size: 22),
        ),
        const SizedBox(height: 8),
        Text(value, style: AppTheme.bodyLarge.copyWith(fontSize: 20)),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppTheme.bodyMedium.copyWith(fontSize: 11),
          textDirection: TextDirection.rtl,
        ),
      ],
    );
  }
}