import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickcook/models/favorite.dart';

class FavoriteDA {
  FavoriteDA();

  final favoritesRef = FirebaseFirestore.instance
      .collection('favorites')
      .withConverter(
          fromFirestore: (snapshot, _) =>
              Favorite.fromJson(snapshot.id, snapshot.data()!),
          toFirestore: (favorite, _) => favorite.toJson());

  Future<Favorite> getFavorite(String userID, String recipeID) async {
    return await favoritesRef
        .where('userID', isEqualTo: userID)
        .where('recipeID', isEqualTo: recipeID)
        .get()
        .then((snapshot) => snapshot.docs.first.data());
  }

  Future<List<Favorite>> getFavorites(String userID) async {
    List<Favorite> favorites = [];
    await favoritesRef
        .where('userID', isEqualTo: userID)
        .get()
        .then((value) => value.docs.forEach((snapshot) {
              favorites.add(snapshot.data());
            }));

    return favorites;
  }

  Future<void> addToFavorites(Favorite favorite) async {
    await favoritesRef.add(favorite);
  }

  Future<void> deleteFavorite(String id) async {
    await favoritesRef.doc(id).delete();
  }
}
