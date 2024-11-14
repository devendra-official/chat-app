import 'package:flutter/material.dart';

void showMessage(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    showCloseIcon: true,
    content: Text(message,
        style: const TextStyle(overflow: TextOverflow.ellipsis), maxLines: 1),
  ));
}
