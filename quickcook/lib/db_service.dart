import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeDA {
  final FirebaseFirestore _db;

  RecipeDA(this._db);

  Future<void> addRecipe() {
    CollectionReference recipes = _db.collection("recipes");

    return recipes.add({
      'recipeName' : "Omelette v2"
    }).then((value) => print(value))
    .catchError((err) => print("Failed to add recipe: $err"));
  }
}
