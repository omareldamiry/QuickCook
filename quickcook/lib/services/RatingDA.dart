import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickcook/models/Rating.dart';

class RatingDA {
  final FirebaseFirestore _db;

  RatingDA(this._db);

  Future<void> addRating(Rating rating) {
    CollectionReference ratings = _db.collection("ratings");

    return ratings
        .add({
          'recipeID': rating.recipeID,
          'userID': FirebaseAuth.instance.currentUser.email,
          'ratingValue': rating.ratingValue,
        })
        .then((value) => print(value))
        .catchError((err) => print("Failed to add rating: $err"));
  }
}
