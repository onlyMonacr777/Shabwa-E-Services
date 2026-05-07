import 'package:flutter/material.dart';

class AdminErrorWidget extends StatelessWidget {

  final String message;

  const AdminErrorWidget({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        textDirection: TextDirection.rtl,
        style: const TextStyle(
          color: Colors.red,
          fontSize: 16,
        ),
      ),
    );
  }
}