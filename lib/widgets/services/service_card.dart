import 'package:flutter/material.dart';
import '/core/theme/app_theme.dart';
import '../../models/service_model.dart';

class ServiceCard extends StatelessWidget {
  final ServiceModel service;
  final int index;
  final AnimationController animationController;
  final Function(ServiceModel, String) onTap;

  const ServiceCard({
    super.key,
    required this.service,
    required this.index,
    required this.animationController,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final imagePath = _getServiceImage();

    return GestureDetector(
      onTap: () => onTap(service, imagePath),
      child: AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          final delay = index * 0.08;
          final animationValue = (animationController.value - delay).clamp(0.0, 1.0);
          return Transform.translate(
            offset: Offset(0, 20 * (1 - animationValue)),
            child: Opacity(
              opacity: animationValue,
              child: child,
            ),
          );
        },
        child: _buildCard(context, imagePath),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String imagePath) {
    return Container(
      height: MediaQuery.of(context).size.width > 600 ? 260 : 240,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.white.withOpacity(0.25), AppTheme.white.withOpacity(0.15)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.white.withOpacity(0.6), width: 1.5),
        boxShadow: [AppTheme.primaryShadow],
      ),
      child: Stack(
        children: [
          _buildImage(imagePath),
          _buildContent(),
          _buildPriceTimeRow(),
        ],
      ),
    );
  }

  Widget _buildImage(String imagePath) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: 115,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          width: double.infinity,
          height: 115,
          alignment: Alignment.center,
          errorBuilder: (context, error, stackTrace) => _buildImageError(),
        ),
      ),
    );
  }

  Widget _buildImageError() {
    return Container(
      height: 115,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.emeraldLight.withOpacity(0.6), AppTheme.primaryGreenLight.withOpacity(0.4)],
        ),
      ),
      child: Icon(Icons.image, color: Colors.white, size: 50),
    );
  }

  Widget _buildContent() {
    return Positioned(
      top: 120,
      left: 12,
      right: 12,
      bottom: 50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            service.title,
            textAlign: TextAlign.right,
            style: AppTheme.bodyMedium.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppTheme.white,
              shadows: [Shadow(offset: const Offset(1, 1), blurRadius: 3, color: Colors.black.withOpacity(0.5))],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            service.description,
            textAlign: TextAlign.right,
            style: AppTheme.caption.copyWith(
              fontSize: 10,
              height: 1.2,
              color: AppTheme.white.withOpacity(0.95),
              shadows: [Shadow(offset: const Offset(1, 1), blurRadius: 2, color: Colors.black.withOpacity(0.4))],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceTimeRow() {
    return Positioned(
      bottom: 8,
      left: 12,
      right: 12,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.emeraldLight.withOpacity(0.9), AppTheme.primaryGreenLight.withOpacity(0.8)],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.emeraldLight.withOpacity(0.8), width: 1),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryGreenDark.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              service.currency,
              style: AppTheme.caption.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              service.price,
              style: AppTheme.bodyMedium.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            Container(width: 1, height: 14, color: Colors.white.withOpacity(0.7)),
            const SizedBox(width: 8),
            Icon(Icons.access_time, size: 12, color: Colors.white),
            const SizedBox(width: 4),
            Text(
              service.time,
              style: AppTheme.caption.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getServiceImage() {
    final List<String> serviceImages = [
      'assets/images/10.png',
      'assets/images/20.png',
      'assets/images/40.png',
      'assets/images/30.png',
      'assets/images/60.png',
      'assets/images/50.png',
      'assets/images/80.png',
      'assets/images/70.png',
    ];
    return serviceImages[index % serviceImages.length];
  }
}