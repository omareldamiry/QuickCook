import 'package:flutter/material.dart';
import 'package:quickcook/services/auth_service.dart';
import 'package:quickcook/utilities/current-user.dart';
import 'package:quickcook/widgets/appbar.dart';
import 'package:quickcook/widgets/drawer.dart';
import 'package:provider/provider.dart';
import 'package:quickcook/screens/SearchPage.dart';

import '../utilities/RecipeHandler.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  // ignore: avoid_init_to_null
  List<String>? ingredientQuery = null;

  HomePage({this.ingredientQuery});

  @override
  Widget build(BuildContext context) {
    if (ingredientQuery != null) if (ingredientQuery!.isEmpty)
      ingredientQuery = null;
    return Scaffold(
      appBar: myAppBar(
        title: !user!.isAdmin ? "QuickCook" : "QuickCook - Admin",
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app_rounded),
            color: Colors.white,
            onPressed: () async {
              await context.read<AuthService>().signOut();
            },
          ),
        ],
      ),
      drawer: MyDrawer(
        currentRoute: '/',
      ),
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
          }),
    );
  }
}
