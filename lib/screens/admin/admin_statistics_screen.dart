import 'package:flutter/material.dart';

class AdminStatisticsScreen
    extends StatelessWidget {

  const AdminStatisticsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'الإحصائيات',
        ),
      ),

      body: Padding(
        padding:
        const EdgeInsets.all(16),

        child: Column(
          children: [

            _buildCard(
              'إجمالي الطلبات',
              '120',
              Icons.list_alt,
              Colors.blue,
            ),

            const SizedBox(height: 16),

            _buildCard(
              'الطلبات المقبولة',
              '85',
              Icons.check_circle,
              Colors.green,
            ),

            const SizedBox(height: 16),

            _buildCard(
              'الطلبات المرفوضة',
              '20',
              Icons.cancel,
              Colors.red,
            ),

            const SizedBox(height: 16),

            _buildCard(
              'طلبات قيد المراجعة',
              '15',
              Icons.access_time,
              Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
      String title,
      String value,
      IconData icon,
      Color color,
      ) {

    return Container(
      width: double.infinity,

      padding:
      const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: color.withOpacity(0.1),

        borderRadius:
        BorderRadius.circular(18),
      ),

      child: Row(
        children: [

          Icon(
            icon,
            size: 40,
            color: color,
          ),

          const Spacer(),

          Column(
            crossAxisAlignment:
            CrossAxisAlignment.end,

            children: [

              Text(
                value,

                style: TextStyle(
                  fontSize: 26,
                  fontWeight:
                  FontWeight.bold,
                  color: color,
                ),
              ),

              Text(
                title,

                textDirection:
                TextDirection.rtl,

                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}