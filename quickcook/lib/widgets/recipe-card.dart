import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quickcook/models/Recipe.dart';
import 'package:quickcook/models/User.dart';
import 'package:quickcook/models/favorite.dart';
import 'package:quickcook/services/FavoriteDA.dart';
import 'package:quickcook/services/RecipeDA.dart';
import 'package:provider/provider.dart';
import 'package:quickcook/services/UserDA.dart';
import 'package:quickcook/services/storage_service.dart';
import 'package:quickcook/utilities/current-user.dart';

// ignore: must_be_immutable
class RecipeCard extends StatefulWidget {
  final Recipe recipe;
  bool isFavorite;

  final Function? parentRefresh;
  final Function? favoriteRefresh;

  RecipeCard({
    Key? key,
    required this.recipe,
    this.parentRefresh,
    this.favoriteRefresh,
    this.isFavorite = false,
  });

  @override
  _RecipeCardState createState() =>
      _RecipeCardState(recipe, parentRefresh, favoriteRefresh);
}

class _RecipeCardState extends State<RecipeCard> {
  final Recipe recipe;
  final Function? parentRefresh;
  final Function? favoriteRefresh;

  _RecipeCardState(this.recipe, this.parentRefresh, this.favoriteRefresh);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    Future<String?> recipePicPath =
        context.read<StorageService>().downloadURL(recipe.recipePicLink);

    Color? timeColor;
    Color? timeBackgroundColor;

    if (recipe.recipePrepTime <= 5) {
      timeColor = Colors.green;
      timeBackgroundColor = Colors.green[100];
    } else if (recipe.recipePrepTime <= 10) {
      timeColor = Colors.orange[300];
      timeBackgroundColor = Colors.yellow[100];
    } else if (recipe.recipePrepTime <= 20) {
      timeColor = Colors.orange;
      timeBackgroundColor = Colors.orange[100];
    } else {
      timeColor = Colors.red;
      timeBackgroundColor = Colors.red[100];
    }

    return Container(
      margin: EdgeInsets.only(bottom: 40),
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.topRight,
        clipBehavior: Clip.none,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/details', arguments: recipe.id);
            },
            child: FutureBuilder<String?>(
              future: recipePicPath,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Container(
                    height: 200,
                    alignment: Alignment.center,
                    width: screenWidth * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.grey[200],
                    ),
                    child: CircularProgressIndicator(),
                  );
                return Hero(
                  tag: '${recipe.id}',
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
                          NetworkImage(snapshot.data!),
                          height: 200,
                        ), //? Placeholder
                      ),
                    ),
                  ),
                );
              },
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
              if (user!.email.compareTo(recipe.recipeOwner) != 0 &&
                  !user!.isAdmin) {
                return !super.widget.isFavorite
                    ? <PopupMenuEntry<String>>[
                        const PopupMenuItem(
                          child: Text("Add to favorites"),
                          value: "Favorite",
                        ),
                      ]
                    : <PopupMenuEntry<String>>[
                        const PopupMenuItem(
                          child: Text("Remove from favorites"),
                          value: "Unfavorite",
                        ),
                      ];
              } else
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
            onSelected: (String value) async {
              if (value.compareTo("Edit") == 0) {
                Map<String, Object?> args = {
                  'recipe': recipe,
                  'refresh': parentRefresh
                };

                Navigator.pushNamed(context, '/editrecipe', arguments: args);
              } else if (value.compareTo("Delete") == 0) {
                await context.read<RecipeDA>().deleteRecipe(recipe.id);
                print("${recipe.recipeName} deleted");
                parentRefresh!();
              } else if (value.compareTo("Favorite") == 0) {
                UserData user = await context
                    .read<UserDA>()
                    .getUser(FirebaseAuth.instance.currentUser!.uid);
                Favorite favorite =
                    Favorite(userID: user.id, recipeID: recipe.id);
                await context.read<FavoriteDA>().addToFavorites(favorite);
                setState(() {
                  super.widget.isFavorite = true;
                });
              } else if (value.compareTo("Unfavorite") == 0) {
                UserData user = await context
                    .read<UserDA>()
                    .getUser(FirebaseAuth.instance.currentUser!.uid);

                Favorite favorite = await context
                    .read<FavoriteDA>()
                    .getFavorite(user.id, recipe.id);

                await context.read<FavoriteDA>().deleteFavorite(favorite.id);

                setState(() {
                  if (favoriteRefresh != null) favoriteRefresh!(favorite);
                  super.widget.isFavorite = false;
                });
              }
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
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Text(
                    "${recipe.recipeName}", //? Placeholder
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Positioned(
                    right: 10,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: timeBackgroundColor,
                      ),
                      child: Text(
                        "${recipe.recipePrepTime}",
                        style: TextStyle(
                          color: timeColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
