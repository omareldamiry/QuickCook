import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickcook/RecipeHandler.dart';

class RecipeDA {
  final FirebaseFirestore _db;

  RecipeDA(this._db);

  Future<void> addRecipe() {
    CollectionReference recipes = _db.collection("recipes");

    return recipes
        .add({'recipeName': "Omelette v2"})
        .then((value) => print(value))
        .catchError((err) => print("Failed to add recipe: $err"));
  }

  FutureBuilder<DocumentSnapshot> getRecipe() {
    CollectionReference recipes = _db.collection("recipes");

    return FutureBuilder<DocumentSnapshot>(
      future: recipes.doc("ABC123").get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          return Recipe(
            recipeName: data['recipeName'],
          );
        }

        return CircularProgressIndicator();
      },
    );
  }

  // List<Recipe> getRecipes() {
  //   List<Recipe> recipes = [];

  //   FirebaseFirestore.instance
  //       .collection('recipes')
  //       .get()
  //       .then((QuerySnapshot querySnapshot) {
  //     querySnapshot.docs.forEach((doc) {
  //       recipes.add(Recipe(
  //         recipeName: doc["recipeName"],
  //       ));
  //     });

  //     return recipes;
  //   });

  //   return recipes;
  // }

  FutureBuilder<QuerySnapshot> getRecipes() {
    CollectionReference recipes = _db.collection("recipes");
    List<Recipe> recipeList = [];

    return FutureBuilder(
        future: recipes.get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            snapshot.data.docs.forEach((doc) {
              recipeList.add(Recipe(recipeName: doc['recipeName']));
            });

            return Column(children: recipeList);
          }

          return CircularProgressIndicator();
        });
  }
}
