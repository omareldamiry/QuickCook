class Rating {
  final String ratingID;
  final String recipeID;
  final String? userID;
  final double ratingValue;

  const Rating(
      {this.ratingID = "", required this.recipeID, this.userID, required this.ratingValue});
}
