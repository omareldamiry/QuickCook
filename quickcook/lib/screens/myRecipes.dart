import 'package:flutter/material.dart';
import 'package:quickcook/screens/AddRecipeForm.dart';
import 'package:quickcook/RecipeHandler.dart';
import 'package:quickcook/widgets/appbar.dart';
import 'package:quickcook/widgets/drawer.dart';

class MyRecipesPage extends StatefulWidget {
  @override
  _MyRecipesPage createState() => _MyRecipesPage();
}

class _MyRecipesPage extends State<MyRecipesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: "My Recipes"),
      drawer: MyDrawer(),
      body: Container(
        alignment: Alignment.center,
        child: MyRecipeList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddRecipe()));
        },
      ),
    );
  }
}
