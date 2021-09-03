// *Serializable*
class Rating {
  final String ratingID;
  final String recipeID;
  final String? userID;
  final double ratingValue;
  final String feedback;

  const Rating({
    this.ratingID = "",
    required this.recipeID,
    this.userID,
    required this.ratingValue,
    this.feedback = "",
  });

  Rating.fromJson(String jsonID, Map<String, dynamic> json)
      : this(
          ratingID: jsonID,
          recipeID: json['recipeID']! as String,
          userID: json['userID'],
          ratingValue: json['ratingValue']! as double,
          feedback: json['feedback'] != null ? json['feedback'] as String : "",
        );

  Map<String, Object?> toJson() {
    return {
      'recipeID': recipeID,
      'userID': userID,
      'ratingValue': ratingValue,
      'feedback': feedback
    };
  }
}
