import 'package:flutter/material.dart';

class AdminHelpers {

  static void showSnackBar(
      BuildContext context,
      String text,
      ) {

    ScaffoldMessenger.of(context)
        .showSnackBar(

      SnackBar(
        content: Text(text),
      ),
    );
  }
}