import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickcook/RecipeHandler.dart';

class RecipeDA {
  final FirebaseFirestore _db;

  RecipeDA(this._db);

  Future<void> addRecipe(recipeName) {
    CollectionReference recipes = _db.collection("recipes");

    return recipes
        .add({
          'recipeName': recipeName,
          'recipeOwner': FirebaseAuth.instance.currentUser.email,
        })
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

  StreamBuilder<QuerySnapshot> getRecipes() {
    CollectionReference recipes = _db.collection("recipes");

    return StreamBuilder(
        stream: recipes.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

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
              return Recipe(
                key: Key(document.id),
                id: document.id,
                recipeName: document.data()['recipeName'],
                recipeOwner: document.data()['recipeOwner'],
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
        })
        .then((value) => print("${recipe.recipeName} recipe has been edited"))
        .catchError(
            (err) => print("${recipe.recipeName} recipe could not be edited"));
  }

  Future<void> deleteRecipe(String id) {
    CollectionReference recipes = _db.collection("recipes");

    print(recipes.doc(id).id);

    recipes
        .doc(id)
        .delete()
        .then((value) => print("Recipe deleted"))
        .catchError((err) => print("Failed to delete recipe: $err"));

    // return recipes
    //     .doc(id)
    //     .delete()
    //     .then((value) => print("Recipe deleted"))
    //     .catchError((err) => print("Failed to delete recipe: $err"));
  }
}
