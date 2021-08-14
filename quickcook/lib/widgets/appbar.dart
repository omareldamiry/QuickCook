import 'package:flutter/material.dart';

AppBar myAppBar({required String title, List<Widget>? actions}) {
  return AppBar(
    iconTheme: IconThemeData(color: Colors.white),
    title: Text(
      title,
      style: TextStyle(color: Colors.white),
    ),
    actions: actions,
  );
}
