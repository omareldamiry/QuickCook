import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quickcook/models/Recipe.dart';
import 'package:quickcook/widgets/recipe-card.dart';

Widget Function(BuildContext, AsyncSnapshot<QuerySnapshot<Recipe>>) recipeListBuilder({Function? refresh}) {
  return (BuildContext context, AsyncSnapshot<QuerySnapshot<Recipe>> snapshot) {
    if (snapshot.hasError) {
      return Text("Something went wrong");
    }

    if (snapshot.connectionState == ConnectionState.waiting) {
      return Container(
        alignment: Alignment.center,
        width: double.minPositive,
        child: CircularProgressIndicator(),
      );
    }
    if (snapshot.data!.docs.isNotEmpty) {
      return new ListView(
        clipBehavior: Clip.none,
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.1,
          vertical: MediaQuery.of(context).size.width * 0.05,
        ),
        children: snapshot.data!.docs.map((DocumentSnapshot<Recipe> document) {
          return new RecipeCard(
            key: Key(document.id),
            recipe: document.data()!,
            parentRefresh: refresh,
          );
        }).toList(),
      );
    }

    return Center(child: Text('No recipes'));
  };
}
