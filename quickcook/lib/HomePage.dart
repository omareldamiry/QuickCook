import 'package:flutter/material.dart';
import 'package:quickcook/auth_service.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "QuickCook",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.read<AuthService>().signOut();
          },
          child: Text(
            "Sign Out",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
