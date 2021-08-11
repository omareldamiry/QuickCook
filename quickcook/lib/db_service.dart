import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickcook/RecipeHandler.dart';

import 'utilities/Ingredients.dart';

class RecipeDA {
  final FirebaseFirestore _db;

  RecipeDA(this._db);

  // Future<void> addRecipe(recipeName) {
  //   CollectionReference recipes = _db.collection("recipes");

  //   return recipes
  //       .add({
  //         'recipeName': recipeName,
  //         'recipeOwner': FirebaseAuth.instance.currentUser.email,
  //       })
  //       .then((value) => print(value))
  //       .catchError((err) => print("Failed to add recipe: $err"));
  // }

  Future<void> addRecipe(Recipe recipe) {
    CollectionReference recipes = _db.collection("recipes");

    List<int> ingredients =
        recipe.recipeIngredients.map((e) => e.index).toList();

    return recipes
        .add({
          'recipeName': recipe.recipeName,
          'ingredients': ingredients,
          'recipeOwner': FirebaseAuth.instance.currentUser.email,
        })
        .then((value) => print(value))
        .catchError((err) => print("Failed to add recipe: $err"));
  }

  Future<Recipe> getRecipe(String id) {
    CollectionReference recipes = _db.collection("recipes");

    return recipes.doc(id).get().then((value) {
      return Recipe(
        id: value.id,
        recipeName: value.data()["recipeName"],
        recipeIngredients: value.data()["ingredients"],
        recipeOwner: value.data()['recipeOwner'],
      );
    });
  }

  // ignore: avoid_init_to_null
  FutureBuilder<QuerySnapshot> getRecipes({List<int> query = null}) {
    CollectionReference recipes = _db.collection("recipes");

    return FutureBuilder<QuerySnapshot>(
        future: recipes.where('ingredients', arrayContainsAny: query).get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.data.docs.isNotEmpty) {
            return new ListView(
              children: snapshot.data.docs.map((DocumentSnapshot document) {
                return new Recipe(
                  key: Key(document.id),
                  id: document.id,
                  recipeName: document.data()['recipeName'],
                  recipeOwner: document.data()['recipeOwner'],
                );
              }).toList(),
            );
          }

          return Text('No recipes');
        });
  }

  StreamBuilder<QuerySnapshot> getMyRecipes(Function refresh) {
    String user = FirebaseAuth.instance.currentUser.email;
    Query recipes =
        _db.collection("recipes").where("recipeOwner", isEqualTo: user);

    return StreamBuilder(
        stream: recipes.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return ListView(
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              print(document.data());
              return Recipe(
                key: Key(document.id),
                id: document.id,
                recipeName: document.data()['recipeName'],
                recipeOwner: document.data()['recipeOwner'],
                recipeIngredients:
                    document.data()['ingredients'].cast<Ingredients>(),
                parentRefresh: refresh,
              );
            }).toList(),
          );
        });
  }

  Future<void> editRecipe(Recipe recipe) {
    CollectionReference recipes = _db.collection("recipes");

    if (FirebaseAuth.instance.currentUser.email.compareTo(recipe.recipeOwner) !=
        0) {
      return null;
    }

    return recipes
        .doc(recipe.id)
        .set({
          'recipeName': recipe.recipeName,
          'recipeOwner': recipe.recipeOwner,
          'ingredients': recipe.recipeIngredients.cast<int>(),
        })
        .then((value) => print("${recipe.recipeName} recipe has been edited"))
        .catchError(
            (err) => print("${recipe.recipeName} recipe could not be edited"));
  }

  Future<void> deleteRecipe(String id) {
    CollectionReference recipes = _db.collection("recipes");

    print(recipes.doc(id).id);

    return recipes
        .doc(id)
        .delete()
        .then((value) => print("Recipe deleted"))
        .catchError((err) => print("Failed to delete recipe: $err"));
  }
}
