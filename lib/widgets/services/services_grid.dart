import 'package:flutter/material.dart';
import '/core/theme/app_theme.dart';
import '../../models/service_model.dart';
import 'service_card.dart';

class ServicesGrid extends StatelessWidget {
  final List<ServiceModel> services;
  final AnimationController animationController;
  final Function(ServiceModel, String) onServiceTap;

  const ServicesGrid({
    super.key,
    required this.services,
    required this.animationController,
    required this.onServiceTap,
  });

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: _buildGridDelegate(context),
      delegate: SliverChildBuilderDelegate(
            (context, index) => ServiceCard(
          service: services[index],
          index: index,
          animationController: animationController,
          onTap: (service, imagePath) => onServiceTap(service, imagePath),
        ),
        childCount: services.length,
        addAutomaticKeepAlives: false,
        addRepaintBoundaries: false,
      ),
    );
  }

  SliverGridDelegateWithFixedCrossAxisCount _buildGridDelegate(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width > 600 || width > 360 ? 2 : 2;
    final childAspectRatio = width > 600 ? 0.75 : 0.68;
    final mainAxisExtent = width > 600 ? 260.0 : 240.0;

    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: crossAxisCount,
      childAspectRatio: childAspectRatio,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      mainAxisExtent: mainAxisExtent,
    );
  }
}