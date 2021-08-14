// *Serializable*
class UserData {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? profilePic;
  final List<String>? favorites;

  UserData({
    this.id = "",
    required this.email,
    required this.firstName,
    required this.lastName,
    this.profilePic,
    this.favorites,
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
          favorites: json['favorites'] != null
              ? json['favorites'].cast<String>()
              : json['favorites'],
        );

  Map<String, Object?> toJson() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'profilePic': profilePic,
      'favorites': favorites,
    };
  }
}
