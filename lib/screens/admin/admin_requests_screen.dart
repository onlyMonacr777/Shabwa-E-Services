import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/mock/requests_data.dart';
import '../../models/request_model.dart';
import '../../widgets/admin/request_card_widget.dart';
class AdminRequestsScreen extends StatelessWidget {
  const AdminRequestsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final requests = requestsData
        .map((e) => RequestModel.fromMap(e))
        .toList();
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('طلبات المستخدمين',

                style: AppTheme.titleLarge,
                textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: requests.length,
                    itemBuilder: (context, index) {
                      final request = requests[index];
                      return RequestCardWidget(
                          request: request,
                          onApprove: () {},
                          onReject: () {},
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}