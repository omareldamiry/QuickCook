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
  }
}
