import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickcook/db_service.dart';
import 'package:quickcook/screens/EditRecipeForm.dart';
import 'package:quickcook/screens/RecipeDetails.dart';
import 'package:quickcook/utilities/Ingredients.dart';

// ignore: must_be_immutable
class RecipeList extends StatefulWidget {
  List<int>? ingredientsQuery = null;

  RecipeList({this.ingredientsQuery});

  @override
  _RecipeListState createState() => _RecipeListState(ingredientsQuery);
}

class _RecipeListState extends State<RecipeList> {
  List<int>? ingredientsQuery;
  _RecipeListState(this.ingredientsQuery);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth * 0.8,
      margin: EdgeInsets.only(top: 20),
      child: context.read<RecipeDA>().getRecipes(query: ingredientsQuery),
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
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth * 0.8,
      margin: EdgeInsets.only(top: 20),
      child: context.read<RecipeDA>().getMyRecipes(refresh),
    );
  }

  void refresh() {
    setState(() {});
  }
}

// ignore: must_be_immutable
class Recipe extends StatefulWidget {
  String id;
  String recipeName;
  String recipeDesc;
  int recipePrepTime;
  int recipeCal;
  String recipeVidLink;
  List<Ingredients>? recipeIngredients;
  double recipeRating;
  String recipeOwner;
  int cuisine;
  int diet;
  int mealType;

  Function? parentRefresh;

  Recipe(
      {Key? key,
      this.id = "",
      required this.recipeName,
      this.recipeDesc = "Perfectly cooked in a pan",
      this.recipePrepTime = 5,
      this.recipeCal = 20,
      this.recipeVidLink = "https://youtu.be/dummylink",
      this.recipeIngredients,
      this.recipeRating = 0.0,
      required this.recipeOwner,
      this.cuisine = 1,
      this.diet = 1,
      this.mealType = 0,
      this.parentRefresh});

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
              color: Colors.orange[200],
              // image: DecorationImage(
              //   alignment: FractionalOffset.center,
              //   fit: BoxFit.fitWidth,
              //   image: new AssetImage("assets/img/pancake.jpg"), //? Placeholder
              // ),
            ),
            child: PopupMenuButton(
              icon: Icon(
                Icons.more_vert_rounded,
                color: Colors.white,
              ),
              itemBuilder: (context) {
                if (FirebaseAuth.instance.currentUser!.email!
                        .compareTo(recipe.recipeOwner) !=
                    0) {
                  return <PopupMenuEntry<String>>[
                    const PopupMenuItem(
                      child: Text("Add to favourites"),
                    ),
                  ];
                }
                return <PopupMenuEntry<String>>[
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
                ];
              },
              onSelected: (String value) {
                if (value.compareTo("Edit") == 0) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EditRecipe(
                            recipe: recipe,
                          )));
                } else if (value.compareTo("Delete") == 0) {
                  context.read<RecipeDA>().deleteRecipe(recipe.id);
                  // setState(() {
                  //   print("${recipe.recipeName} ${recipe.id} deleted");
                  //   recipe.parentRefresh();
                  // });
                  print("${recipe.recipeName} deleted");
                  recipe.parentRefresh!();
                }
              },
            ),
          ),
          Positioned(
            bottom: -10,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeDetailsPage(context, recipe.id),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.8),
                        spreadRadius: 1,
                        blurRadius: 3,
                      )
                    ]),
                width: screenWidth * 0.8,
                padding: EdgeInsets.all(10),
                child: Text(
                  "${recipe.recipeName}", //? Placeholder
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// context.read<RecipeDA>().deleteRecipe(recipe.id);