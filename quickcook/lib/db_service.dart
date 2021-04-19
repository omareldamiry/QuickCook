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
        .add({'recipeName': "Pancakes"})
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
            // snapshot.data.docs.forEach((doc) {
            //   recipeList.add(Recipe(id: doc.id, recipeName: doc['recipeName']));
            // });

            return CircularProgressIndicator();
          }

          return new ListView(
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              return new Recipe(
                id: document.id,
                recipeName: document.data()['recipeName'],
              );
            }).toList(),
          );
        });
  }

  Future<void> deleteRecipe(id) {
    CollectionReference recipes = _db.collection("recipes");

    return recipes
        .doc(id)
        .delete()
        .then((value) => print("Recipe deleted"))
        .catchError((err) => print("Failed to delete recipe: $err"));
  }
}
