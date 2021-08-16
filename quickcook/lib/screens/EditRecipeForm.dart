import 'package:flutter/material.dart';
import 'package:quickcook/models/Recipe.dart';
import 'package:quickcook/screens/AddRecipeForm.dart';

class EditRecipePage extends StatelessWidget {
  final Recipe recipe;
  final Function? parentRefresh;

  EditRecipePage({required this.recipe, this.parentRefresh});

  @override
  Widget build(BuildContext context) {
    return AddRecipePage(
      mode: "edit",
      recipe: recipe,
    );

    // Scaffold(
    //   appBar: myAppBar(title: "Edit Recipe"),
    //   body: Container(
    //     margin: EdgeInsets.only(top: 10),
    //     alignment: Alignment.center,
    //     child: Form(
    //       child: Column(
    //         children: [
    //           Text(
    //             "Edit Recipe",
    //             style: TextStyle(
    //               fontSize: 27,
    //               fontWeight: FontWeight.bold,
    //             ),
    //           ),
    //           // Form items go here
    //           //
    //           Container(
    //             margin: EdgeInsets.only(top: 10, bottom: 20),
    //             width: MediaQuery.of(context).size.width * 0.8,
    //             alignment: Alignment.center,
    //             child: TextFormField(
    //               controller: recipeName,
    //               maxLength: 50,
    //               decoration: InputDecoration(
    //                 labelText: "Recipe Name",
    //               ),
    //             ),
    //           ),

    //           // Ingredient choice will go here
    //         ],
    //       ),
    //     ),
    //   ),
    //   floatingActionButton: FloatingActionButton(
    //     child: Icon(
    //       Icons.check,
    //       color: Colors.white,
    //     ),
    //     onPressed: () {
    //       // recipe.recipeName = recipeName.value.text;
    //       RecipeDA().editRecipe(recipe);
    //       parentRefresh!();
    //       Navigator.of(context).pop();
    //     },
    //   ),
    // );
  }
}
