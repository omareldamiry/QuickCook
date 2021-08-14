import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickcook/models/Recipe.dart';
import 'package:quickcook/services/RecipeDA.dart';
import 'package:quickcook/widgets/recipe-list-builder.dart';

// ignore: must_be_immutable
class RecipeList extends StatefulWidget {
  // ignore: avoid_init_to_null
  List<String>? ingredientsQuery = null;

  RecipeList({this.ingredientsQuery});

  @override
  _RecipeListState createState() => _RecipeListState(ingredientsQuery);
}

class _RecipeListState extends State<RecipeList> {
  List<String>? ingredientsQuery;
  _RecipeListState(this.ingredientsQuery);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<QuerySnapshot<Recipe>>(
        future: context.read<RecipeDA>().getRecipes(query: ingredientsQuery),
        builder: recipeListBuilder(),
      ),
    );
  }
}

class MyRecipeList extends StatefulWidget {
  const MyRecipeList({Key? key}) : super(key: key);

  @override
  _MyRecipeListState createState() => _MyRecipeListState();
}

class _MyRecipeListState extends State<MyRecipeList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: context.read<RecipeDA>().getMyRecipes(),
        builder: recipeListBuilder(refresh: refresh),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
