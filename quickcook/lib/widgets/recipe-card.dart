import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quickcook/models/Recipe.dart';
import 'package:quickcook/screens/EditRecipeForm.dart';
import 'package:quickcook/screens/RecipeDetails.dart';
import 'package:quickcook/services/RecipeDA.dart';
import 'package:provider/provider.dart';

class RecipeCard extends StatefulWidget {
  final Recipe recipe;

  final Function? parentRefresh;

  RecipeCard({Key? key, required this.recipe, this.parentRefresh});

  @override
  _RecipeCardState createState() => _RecipeCardState(recipe, parentRefresh);
}

class _RecipeCardState extends State<RecipeCard> {
  final Recipe recipe;
  final Function? parentRefresh;

  _RecipeCardState(this.recipe, this.parentRefresh);

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
                      parentRefresh: parentRefresh,
                    ),
                  ),
                );
              } else if (value.compareTo("Delete") == 0) {
                context.read<RecipeDA>().deleteRecipe(recipe.id);
                print("${recipe.recipeName} deleted");
                parentRefresh!();
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
