import 'package:flutter/material.dart';
import 'package:quickcook/auth_service.dart';
import 'package:quickcook/widgets/drawer.dart';
import 'package:provider/provider.dart';
import 'package:quickcook/screens/search.dart';

import 'RecipeHandler.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  List<int>? ingredientQuery = [];

  HomePage({this.ingredientQuery});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "QuickCook",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app_rounded),
            color: Colors.white,
            onPressed: () {
              context.read<AuthService>().signOut();
            },
          ),
        ],
      ),
      drawer: MyDrawer(),
      body: Center(child: RecipeList(ingredientsQuery: ingredientQuery)),
      floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.search,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchPage()),
            );
            // context.read<RecipeDA>().addRecipe();
          }),
    );
  }
}
