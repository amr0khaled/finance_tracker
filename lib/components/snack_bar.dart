import 'package:flutter/material.dart';

SnackBar snack(context,
    {required String content, String? label, VoidCallback? onPressed}) {
  return SnackBar(
      content: Text(
        content,
        style: const TextStyle(color: Colors.white),
      ),
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      action: label != null && onPressed != null
          ? SnackBarAction(
              label: label,
              onPressed: onPressed,
              textColor: Colors.black,
              backgroundColor: Colors.white,
            )
          : null,
      behavior: SnackBarBehavior.floating,
      dismissDirection: DismissDirection.horizontal,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)));
}
