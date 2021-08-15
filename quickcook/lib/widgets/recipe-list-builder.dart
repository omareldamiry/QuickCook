import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quickcook/models/Recipe.dart';
import 'package:quickcook/services/RecipeDA.dart';
import 'package:quickcook/widgets/recipe-card.dart';
import 'package:provider/provider.dart';

Widget Function(BuildContext, AsyncSnapshot<QuerySnapshot<Recipe>>)
    recipeListBuilder({Function? refresh}) {
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
      return FutureBuilder<List<bool>>(
        future: context.read<RecipeDA>().listIsFavorite(
              snapshot.data!.docs.map((e) => e.data()).toList(),
            ),
        builder: (BuildContext context, AsyncSnapshot<List<bool>> s) {
          if (s.hasError)
            return Center(
              child: Text("Something went wrong with favorites."),
            );

          if (s.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );

          if (s.hasData)
            return new ListView.builder(
              clipBehavior: Clip.none,
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.1,
                vertical: MediaQuery.of(context).size.width * 0.05,
              ),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, i) {
                var document = snapshot.data!.docs[i];
                return new RecipeCard(
                  key: Key(document.id),
                  recipe: document.data(),
                  parentRefresh: refresh,
                  isFavorite: s.data![i],
                );
              },
            );

          return Container();
        },
      );
    }

    return Center(child: Text('No recipes'));
  };
}
