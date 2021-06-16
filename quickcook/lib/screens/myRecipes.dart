import 'package:flutter/material.dart';
import 'package:quickcook/AddRecipeForm.dart';
import 'package:quickcook/RecipeHandler.dart';
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
      body: Container(
        alignment: Alignment.center,
        child: RecipeList(),
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
