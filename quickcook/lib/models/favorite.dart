class Favorite {
  final String id;
  final String userID;
  final String recipeID;

  const Favorite({
    this.id = "",
    required this.userID,
    required this.recipeID,
  });

  Favorite.fromJson(String jsonID, Map<String, dynamic> json)
      : this(
          id: jsonID,
          userID: json['userID'] as String,
          recipeID: json['recipeID'] as String,
        );

  Map<String, Object?> toJson() {
    return {
      'userID': userID,
      'recipeID': recipeID,
    };
  }
}
