import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quickcook/RecipeHandler.dart';
import 'package:quickcook/db_service.dart';
import 'package:quickcook/widgets/appbar.dart';

class EditRecipe extends StatelessWidget {
  final Recipe recipe;

  EditRecipe({required this.recipe});

  @override
  Widget build(BuildContext context) {
    final TextEditingController recipeName =
        TextEditingController(text: recipe.recipeName);

    return Scaffold(
      appBar: myAppBar(title: "Edit Recipe"),
      body: Container(
        margin: EdgeInsets.only(top: 10),
        alignment: Alignment.center,
        child: Form(
          child: Column(
            children: [
              Text(
                "Edit Recipe",
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Form items go here
              //
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 20),
                width: MediaQuery.of(context).size.width * 0.8,
                alignment: Alignment.center,
                child: TextFormField(
                  controller: recipeName,
                  maxLength: 50,
                  decoration: InputDecoration(
                    labelText: "Recipe Name",
                  ),
                ),
              ),

              // Ingredient choice will go here
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.check,
          color: Colors.white,
        ),
        onPressed: () {
          recipe.recipeName = recipeName.value.text;
          RecipeDA(FirebaseFirestore.instance).editRecipe(recipe);
          recipe.parentRefresh!();
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
