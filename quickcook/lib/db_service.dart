// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:quickcook/RecipeHandler.dart';
// import 'package:quickcook/models/Rating.dart';
// import 'package:quickcook/utilities/Ingredients.dart';

// class RecipeDA {
//   final FirebaseFirestore _db;

//   RecipeDA(this._db);

//   Future<void> addRecipe(Recipe recipe) {
//     CollectionReference recipes = _db.collection("recipes");

//     List<int> ingredients =
//         recipe.recipeIngredients!.map((e) => e.index).toList();

//     return recipes
//         .add({
//           'recipeName': recipe.recipeName,
//           'ingredients': ingredients,
//           'recipeOwner': FirebaseAuth.instance.currentUser!.email,
//           'rating': recipe.recipeRating,
//         })
//         .then((value) => print(value))
//         .catchError((err) => print("Failed to add recipe: $err"));
//   }

//   Future<DocumentSnapshot> getRecipe(String id) {
//     CollectionReference recipes = _db.collection("recipes");

//     return recipes.doc(id).get().then((value) {
//       return value;
//     });
//   }

//   // ignore: avoid_init_to_null
//   FutureBuilder<QuerySnapshot> getRecipes({List<int>? query = null}) {
//     CollectionReference recipes = _db.collection("recipes");

//     return FutureBuilder<QuerySnapshot>(
//         future: recipes.where('ingredients', arrayContainsAny: query).get(),
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.hasError) {
//             return Text("Something went wrong");
//           }

//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Container(
//               alignment: Alignment.center,
//               width: double.minPositive,
//               child: CircularProgressIndicator(),
//             );
//           }
//           if (snapshot.data!.docs.isNotEmpty) {
//             return new ListView(
//               clipBehavior: Clip.none,
//               padding: EdgeInsets.symmetric(
//                 horizontal: MediaQuery.of(context).size.width * 0.1,
//                 vertical: MediaQuery.of(context).size.width * 0.05,
//               ),
//               children:
//                   snapshot.data!.docs.map((DocumentSnapshot<dynamic> document) {
//                 return new Recipe(
//                   key: Key(document.id),
//                   id: document.id,
//                   recipeName: document.data()!['recipeName'],
//                   recipeOwner: document.data()!['recipeOwner'],
//                   recipeRating: document.data()!['rating'].toDouble(),
//                 );
//               }).toList(),
//             );
//           }

//           return Text('No recipes');
//         });
//   }

//   StreamBuilder<QuerySnapshot> getMyRecipes(Function refresh) {
//     String? user = FirebaseAuth.instance.currentUser!.email;
//     Query recipes =
//         _db.collection("recipes").where("recipeOwner", isEqualTo: user);

//     return StreamBuilder(
//         stream: recipes.snapshots(),
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.hasError) {
//             return Text("Something went wrong");
//           }

//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return CircularProgressIndicator();
//           }

//           return ListView(
//             clipBehavior: Clip.none,
//             padding: EdgeInsets.symmetric(
//                 horizontal: MediaQuery.of(context).size.width * 0.1,
//                 vertical: MediaQuery.of(context).size.width * 0.05,
//               ),
//             children:
//                 snapshot.data!.docs.map((DocumentSnapshot<dynamic> document) {
//               return Recipe(
//                 key: Key(document.id),
//                 id: document.id,
//                 recipeName: document.data()!['recipeName'],
//                 recipeOwner: document.data()!['recipeOwner'],
//                 recipeIngredients:
//                     document.data()!['ingredients'].cast<Ingredients>(),
//                 parentRefresh: refresh,
//               );
//             }).toList(),
//           );
//         });
//   }

//   Future<void>? editRecipe(Recipe recipe) {
//     CollectionReference recipes = _db.collection("recipes");

//     if (FirebaseAuth.instance.currentUser!.email!
//             .compareTo(recipe.recipeOwner) !=
//         0) {
//       return null;
//     }

//     return recipes
//         .doc(recipe.id)
//         .update({
//           'recipeName': recipe.recipeName,
//           'ingredients': recipe.recipeIngredients!.cast<int>(),
//         })
//         .then((value) => print("${recipe.recipeName} recipe has been edited"))
//         .catchError(
//             (err) => print("${recipe.recipeName} recipe could not be edited"));
//   }

//   Future<void> deleteRecipe(String id) {
//     CollectionReference recipes = _db.collection("recipes");
//     CollectionReference ratings = _db.collection("ratings");

//     return recipes.doc(id).delete().then((value) {
//       return ratings.where('recipeID', isEqualTo: id).get().then((value) {
//         List<DocumentReference> references = [];
//         value.docs.forEach((document) {
//           references.add(document.reference);
//         });

//         return references.forEach((reference) {
//           reference.delete().then((value) => null).catchError((err) => null);
//         });
//       });
//     }).catchError((err) => print("Failed to delete recipe: $err"));
//   }

//   Future<void> updateRecipeRating(Rating rating) {
//     CollectionReference recipes = _db.collection("recipes");
//     CollectionReference ratings = _db.collection("ratings");

//     return recipes.doc(rating.recipeID).get().then((value) {
//       double totalRating = 0.0;
//       List<double> allRatings = [];

//       return ratings.where('recipeID', isEqualTo: value.id).get().then((value) {
//         value.docs.forEach((QueryDocumentSnapshot<dynamic> document) {
//           allRatings.add(document.data()['ratingValue'].toDouble());
//         });

//         allRatings.forEach((value) {
//           totalRating += value;
//         });

//         totalRating = (totalRating / allRatings.length) * 10;
//         totalRating = totalRating.roundToDouble();
//         totalRating /= 10;

//         return recipes.doc(rating.recipeID).update({
//           'rating': totalRating,
//         }).then((value) => print('Rating updated'));
//       });
//     });
//   }
// }
