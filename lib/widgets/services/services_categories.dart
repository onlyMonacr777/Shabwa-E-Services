import 'package:flutter/material.dart';
import '/core/theme/app_theme.dart';

class ServicesCategories extends StatelessWidget {
  final List<Map<String, dynamic>> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const ServicesCategories({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: const EdgeInsets.only(top: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        reverse: true,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) => _buildCategoryItem(categories[index]),
      ),
    );
  }

  Widget _buildCategoryItem(Map<String, dynamic> category) {
    final isSelected = selectedCategory == category['name'];
    return GestureDetector(
      onTap: () => onCategorySelected(category['name']),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(left: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
            colors: [AppTheme.emeraldLight.withOpacity(0.4), AppTheme.primaryGreenLight.withOpacity(0.2)],
          )
              : LinearGradient(
            colors: [AppTheme.white.withOpacity(0.2), AppTheme.white.withOpacity(0.1)],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.emeraldLight : AppTheme.white.withOpacity(0.4),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryGreenDark.withOpacity(isSelected ? 0.5 : 0.3),
              blurRadius: 20,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              category['icon'],
              color: isSelected ? AppTheme.white : AppTheme.white.withOpacity(0.9),
              size: 26,
            ),
            const SizedBox(height: 6),
            Text(
              category['name'],
              style: AppTheme.caption.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? AppTheme.white : AppTheme.white.withOpacity(0.9),
              ),
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
      ),
    );
  }
}