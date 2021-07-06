import 'package:flutter/material.dart';
import 'package:quickcook/AddRecipeForm.dart';
import 'package:quickcook/RecipeHandler.dart';
import 'package:quickcook/widgets/drawer.dart';

class MyRecipesPage extends StatefulWidget {
  @override
  _MyRecipesPage createState() => _MyRecipesPage();
}

class _MyRecipesPage extends State<MyRecipesPage> {
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
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => AddRecipe()));
        },
      ),
    );
  }
}
