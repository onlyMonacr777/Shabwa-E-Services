import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../models/request_model.dart';
class RequestCardWidget extends StatelessWidget {
  final RequestModel request;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  const RequestCardWidget({
    super.key,
    required this.request,
    required this.onApprove,
    required this.onReject,
  });
  Color _statusColor() {
    switch (request.status) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.white.withOpacity(0.20),
              AppTheme.white.withOpacity(0.10),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppTheme.white.withOpacity(0.4),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [

            Text(
              request.userName,
              style: AppTheme.titleMedium,
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 8),
            Text(
              request.serviceName,
              style: AppTheme.bodyMedium,
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor().withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    request.status,
                    style: TextStyle(
                      color: _statusColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: onApprove,
                      icon: const Icon(Icons.check_circle),
                      color: Colors.green,
                    ),
                    IconButton(
                      onPressed: onReject,
                      icon: const Icon(Icons.cancel),
                      color: Colors.red,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),

    );
  }
}