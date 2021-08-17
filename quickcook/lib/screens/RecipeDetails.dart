import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickcook/models/Rating.dart';
import 'package:quickcook/models/Recipe.dart';
import 'package:quickcook/services/RatingDA.dart';
import 'package:quickcook/services/RecipeDA.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:quickcook/services/storage_service.dart';
import 'package:quickcook/utilities/current-user.dart';
import 'package:quickcook/widgets/appbar.dart';

class RecipeDetailsPage extends StatelessWidget {
  final String id;
  RecipeDetailsPage({required this.id});

  @override
  Widget build(BuildContext context) {
    Future<Recipe> recipeInstance = context.read<RecipeDA>().getRecipe(id);
    return Scaffold(
      appBar: myAppBar(title: "Details"),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 30.0),
        child: FutureBuilder<Recipe>(
          future: recipeInstance,
          builder: (BuildContext context, AsyncSnapshot<Recipe> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              Recipe recipe = snapshot.data!;

              return RecipeDetails(recipe);
            }

            return Center(child: Text("Something went wrong"));
          },
        ),
      ),
    );
  }
}

class RecipeDetails extends StatelessWidget {
  final Recipe _recipe;
  const RecipeDetails(this._recipe);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FutureBuilder<String?>(
            future: context
                .read<StorageService>()
                .downloadURL(_recipe.recipePicLink),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  alignment: Alignment.center,
                  height: 200,
                  child: CircularProgressIndicator(),
                );
              }

              return Hero(
                tag: '${_recipe.id}',
                child: Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
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
          SizedBox(
            height: 20,
          ),
          Text(
            _recipe.recipeName,
            style: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text("By: " + _recipe.recipeOwner),
          SizedBox(
            height: 20,
          ),
          Text(
            "Ingredients",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          ..._ingredientDetails(),
          SizedBox(
            height: 30,
          ),
          Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "${_recipe.recipeRating}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                RatingBar.builder(
                  ignoreGestures: true,
                  itemSize: 30,
                  initialRating: _recipe.recipeRating,
                  allowHalfRating: true,
                  minRating: 1,
                  direction: Axis.horizontal,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (value) async {
                    Rating rating = Rating(
                      recipeID: _recipe.id,
                      userID: FirebaseAuth.instance.currentUser!.email,
                      ratingValue: value,
                    );

                    await context.read<RatingDA>().addRating(rating);
                  },
                ),
                FutureBuilder<int>(
                  future:
                      context.read<RatingDA>().recipeRatingCount(_recipe.id),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) return Text("(${snapshot.data})");

                    return Text(" ");
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          !user!.isAdmin
              ? TextButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 50),
                          height: 150,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              RatingBar.builder(
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 4.0),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (value) async {
                                  Rating rating = Rating(
                                    recipeID: _recipe.id,
                                    userID: FirebaseAuth
                                        .instance.currentUser!.email,
                                    ratingValue: value,
                                  );

                                  await context
                                      .read<RatingDA>()
                                      .addRating(rating);
                                  Navigator.of(context).pop();
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Please rate recipe",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // TextField(
                              //   decoration: InputDecoration(
                              //     labelText: "Feedback (optional)",
                              //     border: OutlineInputBorder(
                              //       borderRadius: BorderRadius.all(
                              //         Radius.circular(10),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        );
                      },
                      backgroundColor: Colors.white,
                      elevation: 10,
                    );
                  },
                  child: Text("Rate Recipe"),
                )
              : SizedBox(),
        ],
      ),
    );
  }

  List<Text> _ingredientDetails() {
    List<Text> ingredients = [];
    _recipe.recipeIngredients.forEach((element) {
      ingredients.add(Text(element.toString()));
    });

    return ingredients;
  }
}
