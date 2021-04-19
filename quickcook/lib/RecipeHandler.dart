import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickcook/db_service.dart';

class RecipeList extends StatefulWidget {
  @override
  _RecipeListState createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth * 0.8,
      margin: EdgeInsets.only(top: 20),
      child: context.read<RecipeDA>().getRecipes(),
    );
  }
}

class Recipe extends StatefulWidget {
  final String id;
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

  const Recipe(
      {Key key,
      this.id,
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
      this.mealType = 0})
      : super(key: key);

  @override
  _RecipeState createState() => _RecipeState(this);
}

class _RecipeState extends State<Recipe> {
  final Recipe recipe;

  _RecipeState(this.recipe);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.only(bottom: 30),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: screenWidth * 0.8,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              image: DecorationImage(
                alignment: FractionalOffset.center,
                fit: BoxFit.fitWidth,
                image: new AssetImage("assets/img/pancake.jpg"), //? Placeholder
              ),
            ),
            child: IconButton(
              padding: EdgeInsets.all(15),
              color: Colors.white,
              alignment: FractionalOffset.topRight,
              icon: Icon(Icons.more_vert_rounded),
              onPressed: () {
                setState(() {
                  context.read<RecipeDA>().deleteRecipe(recipe.id);
                });
              },
            ),
          ),
          Positioned(
            bottom: -10,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.8),
                      spreadRadius: 5,
                      blurRadius: 7,
                    )
                  ]),
              width: screenWidth * 0.8,
              padding: EdgeInsets.all(10),
              child: Text(
                recipe.recipeName, //? Placeholder
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
