import 'package:flutter/material.dart';

class UserTileWidget extends StatelessWidget {

  final String name;
  final String email;

  const UserTileWidget({
    super.key,
    required this.name,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(16),
      ),

      child: ListTile(
        leading: const CircleAvatar(
          child: Icon(Icons.person),
        ),

        title: Text(
          name,
          textDirection:
          TextDirection.rtl,
        ),

        subtitle: Text(
          email,
          textDirection:
          TextDirection.rtl,
        ),

        trailing: PopupMenuButton(
          itemBuilder: (_) => [
            const PopupMenuItem(
              value: 'delete',
              child: Text('حذف'),
            ),

            const PopupMenuItem(
              value: 'block',
              child: Text('حظر'),
            ),
          ],
        ),
      ),
    );
  }
}
