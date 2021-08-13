import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickcook/RecipeHandler.dart';
import 'package:quickcook/db_service.dart';
import 'package:quickcook/models/Rating.dart';
import 'package:quickcook/services/RatingDA.dart';
import 'package:quickcook/utilities/Ingredients.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:quickcook/widgets/appbar.dart';

class RecipeDetailsPage extends StatelessWidget {
  final String id;
  final BuildContext context;
  RecipeDetailsPage(this.context, this.id);

  @override
  Widget build(BuildContext context) {
    Future<DocumentSnapshot> recipeInstance =
        context.read<RecipeDA>().getRecipe(id);
    return Scaffold(
      appBar: myAppBar(title: "Details"),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
        child: FutureBuilder(
          future: recipeInstance,
          builder: (BuildContext context,
              AsyncSnapshot<DocumentSnapshot<dynamic>> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (snapshot.hasData) {
              Recipe recipe = Recipe(
                id: snapshot.data!.id,
                recipeName: snapshot.data!.data()!['recipeName'],
                recipeIngredients: snapshot.data!
                    .data()!['ingredients']
                    .map((element) => Ingredients.values[element])
                    .toList()
                    .cast<Ingredients>(),
                recipeOwner: snapshot.data!.data()!['recipeOwner'],
                recipeRating: snapshot.data!.data()!["rating"].toDouble(),
              );

              return RecipeDetails(recipe);
            }

            return CircularProgressIndicator();
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          _recipe.recipeName,
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text("By: " + _recipe.recipeOwner),
        Spacer(),
        Text(
          "Ingredients",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        ..._ingredientDetails(),
        Spacer(),
        Spacer(),
        Spacer(),
        Spacer(),
        Spacer(),
        Spacer(),
        Spacer(),
        Container(
          alignment: Alignment.center,
          child: RatingBar.builder(
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
            onRatingUpdate: (value) {
              Rating rating = Rating(recipeID: _recipe.id, ratingValue: value);

              context.read<RatingDA>().addRating(rating);
            },
          ),
        ),
      ],
    );
  }

  List<Text> _ingredientDetails() {
    List<Text> ingredients = [];
    _recipe.recipeIngredients!.forEach((element) {
      ingredients
          .add(Text(element.toString().substring(12).replaceAll('_', ' ')));
    });

    return ingredients;
  }
}
