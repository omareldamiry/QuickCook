import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickcook/db_service.dart';
import 'package:quickcook/screens/EditRecipeForm.dart';
import 'package:quickcook/screens/RecipeDetails.dart';
import 'package:quickcook/utilities/Ingredients.dart';

// ignore: must_be_immutable
class RecipeList extends StatefulWidget {
  // ignore: avoid_init_to_null
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
    return Container(
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
    return Container(
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
  String recipePicLink;
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
      this.recipePicLink = "https://inter.net/dummylink",
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
      margin: EdgeInsets.only(bottom: 40),
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.topRight,
        clipBehavior: Clip.none,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeDetailsPage(context, recipe.id),
                ),
              );
            },
            child: Container(
              height: 200,
              width: screenWidth * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.orange[200],
                image: DecorationImage(
                  alignment: FractionalOffset.center,
                  fit: BoxFit.fitWidth,
                  image: ResizeImage(
                    NetworkImage(
                      "https://cdn.vox-cdn.com/thumbor/ebLyPNyZghyiG1TCxQJ5vI-qxvU=/0x0:1280x853/1200x900/filters:focal(538x325:742x529)/cdn.vox-cdn.com/uploads/chorus_image/image/69482129/Aerial_Image__1_.0.jpg",
                    ),
                    height: 200,
                  ), //? Placeholder
                ),
              ),
            ),
          ),
          PopupMenuButton(
            icon: Container(
              alignment: Alignment.center,
              width: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Icon(
                Icons.more_vert_rounded,
                color: Colors.black,
              ),
            ),
            itemBuilder: (context) {
              if (FirebaseAuth.instance.currentUser!.email!
                      .compareTo(recipe.recipeOwner) !=
                  0) {
                return <PopupMenuEntry<String>>[
                  const PopupMenuItem(
                    child: Text("Add to favourites"),
                    value: "Favourite",
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
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditRecipe(
                      recipe: recipe,
                    ),
                  ),
                );
              } else if (value.compareTo("Delete") == 0) {
                context.read<RecipeDA>().deleteRecipe(recipe.id);
                print("${recipe.recipeName} deleted");
                recipe.parentRefresh!();
              } else if (value.compareTo("Favourite") == 0) {}
            },
          ),
          Positioned(
            bottom: -20,
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
        ],
      ),
    );
  }
}
// context.read<RecipeDA>().deleteRecipe(recipe.id);