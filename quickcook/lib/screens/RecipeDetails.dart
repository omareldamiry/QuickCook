import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickcook/RecipeHandler.dart';
import 'package:quickcook/db_service.dart';

class RecipeDetails extends StatelessWidget {
  final String id;
  final BuildContext context;
  RecipeDetails(this.context, this.id);

  @override
  Widget build(BuildContext context) {
    Future<Recipe> recipeInstance = context.read<RecipeDA>().getRecipe(id);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Details",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        child: FutureBuilder(
          future: recipeInstance,
          builder: (BuildContext context, AsyncSnapshot<Recipe> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (snapshot.hasData) {
              return snapshot.data;
            }

            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
