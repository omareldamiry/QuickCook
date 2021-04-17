import 'package:flutter/material.dart';

class RecipeList extends StatefulWidget {
  @override
  _RecipeListState createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class Recipe extends StatelessWidget {
  final String recipeName;
  final String recipeDesc;
  final int recipePrepTime;
  final int recipeCal;
  final String recipeVidLink;
  final List<int> recipeIngredients;
  final double recipeRating;
  final String recipeOwner;
  final int cuisine;
  final int diet;
  final int mealType;

  const Recipe({
    Key key,
    this.recipeName = "Advanced Omelette",
    this.recipeDesc = "Perfectly cooked omelette in a pan",
    this.recipePrepTime = 5,
    this.recipeCal = 20,
    this.recipeVidLink = "https://youtu.be/dummylink",
    this.recipeIngredients,
    this.recipeRating = 0.0,
    this.recipeOwner = "test@gmail.com",
    this.cuisine = 1,
    this.diet = 1,
    this.mealType = 0
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
