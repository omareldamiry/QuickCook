import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickcook/AddRecipeForm.dart';
import 'package:quickcook/db_service.dart';
import 'package:quickcook/screens/EditRecipeForm.dart';

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
  String id;
  String recipeName;
  String recipeDesc;
  int recipePrepTime;
  int recipeCal;
  String recipeVidLink;
  List<int> recipeIngredients;
  double recipeRating;
  String recipeOwner;
  int cuisine;
  int diet;
  int mealType;

  Recipe(
      {Key key,
      this.id,
      this.recipeName,
      this.recipeDesc = "Perfectly cooked in a pan",
      this.recipePrepTime = 5,
      this.recipeCal = 20,
      this.recipeVidLink = "https://youtu.be/dummylink",
      this.recipeIngredients,
      this.recipeRating = 0.0,
      this.recipeOwner = "test@gmail.com",
      this.cuisine = 1,
      this.diet = 1,
      this.mealType = 0});

  String get name {
    return this.recipeName;
  }

  set name(String value) {
    this.recipeName = value;
  }

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
            alignment: Alignment.topRight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              image: DecorationImage(
                alignment: FractionalOffset.center,
                fit: BoxFit.fitWidth,
                image: new AssetImage("assets/img/pancake.jpg"), //? Placeholder
              ),
            ),
            child: PopupMenuButton(
              icon: Icon(
                Icons.more_vert_rounded,
                color: Colors.white,
              ),
              itemBuilder: (context) => <PopupMenuEntry<String>>[
                const PopupMenuItem(
                  value: "Edit",
                  child: Text("Edit"),
                ),
                const PopupMenuItem(
                  value: "Delete",
                  child: Text(
                    "Delete",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
              onSelected: (String value) {
                if (value.compareTo("Edit") == 0) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EditRecipe(
                            recipe: recipe,
                          )));
                } else if (value.compareTo("Delete") == 0) {
                  setState(() {
                    context.read<RecipeDA>().deleteRecipe(recipe.id);
                  });
                }
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
// context.read<RecipeDA>().deleteRecipe(recipe.id);