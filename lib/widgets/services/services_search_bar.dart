import 'package:flutter/material.dart';
import '/core/theme/app_theme.dart';

class ServicesSearchBar extends StatelessWidget {
  final Function(String) onSearchChanged;

  const ServicesSearchBar({
    super.key,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.white.withOpacity(0.25), AppTheme.white.withOpacity(0.15)],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.white.withOpacity(0.6), width: 2),
          boxShadow: [AppTheme.primaryShadow],
        ),
        child: TextField(
          textAlign: TextAlign.right,
          style: AppTheme.bodyMedium.copyWith(fontSize: 16),
          onChanged: onSearchChanged,
          decoration: InputDecoration(
            hintText: 'ابحث عن خدمة حكومية...',
            hintStyle: AppTheme.caption.copyWith(fontSize: 14),
            prefixIcon: _buildSearchIcon(),
            suffixIcon: _buildFilterIcon(),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchIcon() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppTheme.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(Icons.search, color: AppTheme.white.withOpacity(0.9), size: 20),
    );
  }

  Widget _buildFilterIcon() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.emeraldLight.withOpacity(0.4), AppTheme.primaryGreenLight.withOpacity(0.2)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(Icons.tune, color: AppTheme.white, size: 20),
    );
  }
}