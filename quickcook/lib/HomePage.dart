import 'package:flutter/material.dart';
import 'package:quickcook/auth_service.dart';
import 'package:quickcook/widgets/appbar.dart';
import 'package:quickcook/widgets/drawer.dart';
import 'package:provider/provider.dart';
import 'package:quickcook/screens/search.dart';

import 'RecipeHandler.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  // ignore: avoid_init_to_null
  List<int>? ingredientQuery = null;

  HomePage({this.ingredientQuery});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
        title: "QuickCook",
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
      body: RecipeList(ingredientsQuery: ingredientQuery),
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
