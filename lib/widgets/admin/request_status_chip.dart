import 'package:flutter/material.dart';

class RequestStatusChip extends StatelessWidget {
  final String status;

  const RequestStatusChip({
    super.key,
    required this.status,
  });

  Color getColor() {
    switch (status) {
      case 'approved':
        return Colors.green;

      case 'rejected':
        return Colors.red;

      default:
        return Colors.orange;
    }
  }

  String getText() {
    switch (status) {
      case 'approved':
        return 'مقبول';

      case 'rejected':
        return 'مرفوض';

      default:
        return 'قيد المراجعة';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: getColor().withOpacity(0.15),

      label: Text(
        getText(),

        style: TextStyle(
          color: getColor(),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}