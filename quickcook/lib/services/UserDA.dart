import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickcook/models/User.dart';

class UserDA {
  UserDA();

  final usersRef =
      FirebaseFirestore.instance.collection('users').withConverter<UserData>(
            fromFirestore: (snapshot, _) =>
                UserData.fromJson(snapshot.id, snapshot.data()!),
            toFirestore: (userData, _) => userData.toJson(),
          );

  Future<void> addUser(UserData userData) async {
    await usersRef.add(userData);
  }

  Future<UserData> getUser(String email) async {
    List<QueryDocumentSnapshot<UserData>> users = await usersRef
        .where('email', isEqualTo: email)
        .get()
        .then((snapshot) => snapshot.docs);

    return users.first.data();
  }

  Future<void> updateUserProfile(UserData userData) async {
    await usersRef.doc(userData.id).update(userData.toJson());
  }

  Future<void> deleteProfile(String email) async {
    try {
      await usersRef
          .where('email', isEqualTo: email)
          .get()
          .then((snapshot) => snapshot.docs.first.reference.delete());
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }
}
