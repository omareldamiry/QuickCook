import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickcook/db_service.dart';
import 'package:quickcook/models/Rating.dart';

class RatingDA {
  final FirebaseFirestore _db;

  RatingDA(this._db);

  Future<void> addRating(Rating rating) {
    CollectionReference ratings = _db.collection("ratings");

    return ratings
        .where("recipeID", isEqualTo: rating.recipeID)
        .where("userID", isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get()
        .then((value) {
      if (value.size < 1) {
        return ratings
            .add({
              'recipeID': rating.recipeID,
              'userID': FirebaseAuth.instance.currentUser!.email,
              'ratingValue': rating.ratingValue,
            })
            .then((value) => RecipeDA(_db).updateRecipeRating(rating))
            .catchError((err) => null);
      }

      return updateRating(value.docs.first.id, rating);
    }).catchError((err) => print(err));
  }

  Future<void> updateRating(String ratingID, Rating rating) {
    CollectionReference ratings = _db.collection("ratings");

    return ratings.doc(ratingID).update({
      'ratingValue': rating.ratingValue,
    }).then((value) => RecipeDA(_db).updateRecipeRating(rating));
  }
}
