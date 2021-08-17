// *Serializable*
import 'package:quickcook/services/UserDA.dart';

class UserData {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? profilePic;
  final bool isAdmin;

  UserData({
    this.id = "",
    required this.email,
    required this.firstName,
    required this.lastName,
    this.profilePic = "",
    this.isAdmin = false,
  });

  UserData.fromJson(String jsonID, Map<String, dynamic> json)
      : this(
          id: jsonID,
          email: json['email']! as String,
          firstName: json['firstName']! as String,
          lastName: json['lastName']! as String,
          profilePic: json['profilePic'] != null
              ? json['profilePic'] as String
              : json['profilePic'],
          isAdmin: json['isAdmin'] as bool,
        );

  Map<String, Object?> toJson() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'profilePic': profilePic,
      'isAdmin': false,
    };
  }

  static Future<UserData> currentUser(String id) async {
    return await UserDA().getUser(id);
  }
}
