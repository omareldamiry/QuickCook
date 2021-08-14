import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickcook/models/Rating.dart';
import 'package:quickcook/services/RecipeDA.dart';

class RatingDA {
  final FirebaseFirestore _db;

  RatingDA(this._db);

  final ratingsRef = FirebaseFirestore.instance
      .collection("ratings")
      .withConverter(
          fromFirestore: (snapshot, _) =>
              Rating.fromJson(snapshot.id, snapshot.data()!),
          toFirestore: (rating, _) => rating.toJson());

  Future<void> addRating(Rating rating) {
    return ratingsRef
        .where("recipeID", isEqualTo: rating.recipeID)
        .where("userID", isEqualTo: rating.userID)
        .get()
        .then((value) {
      if (value.size < 1) {
        return ratingsRef
            .add(rating)
            .then((value) => RecipeDA().updateRecipeRating(rating))
            .catchError((err) => print(err));
      }

      return updateRating(value.docs.first.id, rating);
    }).catchError((err) => print(err));
  }

  Future<void> updateRating(String ratingID, Rating rating) {
    CollectionReference ratings = _db.collection("ratings");

    return ratingsRef
        .doc(ratingID)
        .set(rating)
        .then((value) => RecipeDA().updateRecipeRating(rating));
  }
}
