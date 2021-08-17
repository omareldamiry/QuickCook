import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickcook/models/Rating.dart';
import 'package:quickcook/models/Recipe.dart';
import 'package:quickcook/models/User.dart';
import 'package:quickcook/models/favorite.dart';
import 'package:quickcook/utilities/current-user.dart';

//  RecipeDA
// *(aka. db_service 2.0)*
class RecipeDA {
  RecipeDA();

  final recipesRef =
      FirebaseFirestore.instance.collection("recipes").withConverter(
            fromFirestore: (snapshot, _) =>
                Recipe.fromJson(snapshot.id, snapshot.data()!),
            toFirestore: (recipe, _) => recipe.toJson(),
          );

  final ratingsRef =
      FirebaseFirestore.instance.collection("ratings").withConverter(
            fromFirestore: (snapshot, _) =>
                Rating.fromJson(snapshot.id, snapshot.data()!),
            toFirestore: (rating, _) => rating.toJson(),
          );

  final favoritesRef = FirebaseFirestore.instance
      .collection('favorites')
      .withConverter(
          fromFirestore: (snapshot, _) =>
              Favorite.fromJson(snapshot.id, snapshot.data()!),
          toFirestore: (favorite, _) => favorite.toJson());

  final usersRef =
      FirebaseFirestore.instance.collection('users').withConverter<UserData>(
            fromFirestore: (snapshot, _) =>
                UserData.fromJson(snapshot.id, snapshot.data()!),
            toFirestore: (userData, _) => userData.toJson(),
          );

  Future<void> addRecipe(Recipe recipe) async {
    await recipesRef.add(recipe).then((value) => null);
  }

  Future<Recipe> getRecipe(String id) async {
    Recipe recipe =
        await recipesRef.doc(id).get().then((snapshot) => snapshot.data()!);

    return recipe;
  }

  // ignore: avoid_init_to_null
  Future<QuerySnapshot<Recipe>> getRecipes({List<String>? query = null}) async {
    QuerySnapshot<Recipe> recipesQuerySnapshot = await recipesRef
        .where(
          'ingredients',
          arrayContainsAny: query,
        )
        .get()
        .then((querySnapshot) => querySnapshot)
        .catchError((err) {
      print(err);
    });

    return recipesQuerySnapshot;
  }

  Future<List<Recipe>> getFavorites(
      // ignore: avoid_init_to_null
      {List<String>? favoritesIDs = null}) async {
    List<Recipe> favorites = [];

    await recipesRef
        .get()
        .then((querySnapshot) => querySnapshot.docs.forEach((snapshot) {
              if (favoritesIDs!.contains(snapshot.id)) {
                favorites.add(snapshot.data());
              }
            }))
        .catchError((err) {
      print(err);
    });

    return favorites;
  }

  Stream<QuerySnapshot<Recipe>> getMyRecipes() {
    return recipesRef.where('recipeOwner', isEqualTo: user!.email).snapshots();
  }

  Future<void>? editRecipe(Recipe recipe) async {
    if (FirebaseAuth.instance.currentUser!.email!
            .compareTo(recipe.recipeOwner) !=
        0) {
      return null;
    }

    try {
      await recipesRef
          .doc(recipe.id)
          .update(recipe.toJson())
          .then((value) => null)
          .catchError((err) {
        throw err;
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> deleteRecipe(String id) {
    return recipesRef.doc(id).delete().then((value) {
      return ratingsRef.where('recipeID', isEqualTo: id).get().then((value) {
        List<DocumentReference<Rating>> references = [];
        value.docs.forEach((document) {
          references.add(document.reference);
        });

        return references.forEach((reference) {
          reference.delete().then((value) => null).catchError((err) => null);
        });
      });
    }).catchError((err) => print("Failed to delete recipe: $err"));
  }

  Future<void> updateRecipeRating(Rating rating) {
    return recipesRef.doc(rating.recipeID).get().then((value) {
      double totalRating = 0.0;
      List<double> allRatings = [];

      return ratingsRef
          .where('recipeID', isEqualTo: value.id)
          .get()
          .then((value) {
        value.docs.forEach((document) {
          allRatings.add(document.data().ratingValue);
        });

        allRatings.forEach((value) {
          totalRating += value;
        });

        totalRating = (totalRating / allRatings.length) * 10;
        totalRating = totalRating.roundToDouble();
        totalRating /= 10;

        return recipesRef.doc(rating.recipeID).update({
          'rating': totalRating,
        }).then((value) => print('Rating updated'));
      });
    });
  }

  Future<bool> isFavorite(String recipeID, String userID) async {
    bool isInFavorites = await favoritesRef
        .where('userID', isEqualTo: userID)
        .where('recipeID', isEqualTo: recipeID)
        .get()
        .then((snapshot) => snapshot.docs.isNotEmpty);

    return isInFavorites;
  }

  Future<List<bool>> listIsFavorite(List<Recipe> recipes) async {
    List<bool> x = [];
    UserData user = await usersRef
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email!)
        .get()
        .then((snapshot) => snapshot.docs.first.data());

    for (int i = 0; i < recipes.length; i++) {
      bool isInFavorites = await favoritesRef
          .where('userID', isEqualTo: user.id)
          .where('recipeID', isEqualTo: recipes[i].id)
          .get()
          .then((snapshot) => snapshot.docs.isNotEmpty);

      x.add(isInFavorites);
    }

    return x;
  }
}
