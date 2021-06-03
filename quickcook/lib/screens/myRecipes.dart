import 'package:flutter/material.dart';
import 'package:quickcook/widgets/drawer.dart';

class MyRecipesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "My Recipes",
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: MyDrawer(),
    );
  }
}
