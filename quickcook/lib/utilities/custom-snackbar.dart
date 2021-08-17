import 'package:flutter/material.dart';

void customSnackBar(context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: Duration(seconds: 2),
      content: Text(message),
    ),
  );
}
