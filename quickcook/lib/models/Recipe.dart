import 'package:quickcook/models/Ingredient.dart';

// *Serializable*
class Recipe {
  final String id;
  final String recipeName;
  final String recipeDesc;
  final int recipePrepTime;
  final int recipeCal;
  final String recipeVidLink;
  final String recipePicLink;
  final List<Ingredient> recipeIngredients;
  final double recipeRating;
  final String recipeOwner;
  final int cuisine;
  final int diet;
  final int mealType;

  Recipe({
    this.id = "",
    required this.recipeName,
    this.recipeDesc = "Perfectly cooked",
    this.recipePrepTime = 5,
    this.recipeCal = 20,
    this.recipeVidLink = "https://youtu.be/dummylink",
    this.recipePicLink = "https://youtu.be/dummylink",
    required this.recipeIngredients,
    this.recipeRating = 0.0,
    required this.recipeOwner,
    this.cuisine = 1,
    this.diet = 1,
    this.mealType = 0,
  });

  Recipe.fromJson(String jsonID, Map<String, dynamic> json)
      : this(
          id: jsonID,
          recipeName: json['recipeName']! as String,
          // recipeDesc: json['recipeDesc']! as String,
          // recipePrepTime: json['recipePrepTime']! as int,
          // recipeCal: json['recipeCal']! as int,
          // recipeVidLink: json['recipeVidLink']! as String,
          recipeIngredients: Ingredient.fromJsonList(json['ingredients']!),
          recipeRating: json['rating']!.toDouble(),
          recipeOwner: json['recipeOwner']! as String,
          // cuisine: json['cuisine']! as int,
          // diet: json['diet']! as int,
          // mealType: json['mealType']! as int,
        );

  Map<String, Object?> toJson() {
    return {
      'recipeName': recipeName,
      'recipeDesc': recipeDesc,
      'recipePrepTime': recipePrepTime,
      'recipeCal': recipeCal,
      'recipeVidLink': recipeVidLink,
      'ingredients': recipeIngredients.map((e) => e.toString()).toList(),
      'rating': recipeRating,
      'recipeOwner': recipeOwner,
      'cuisine': cuisine,
      'diet': diet,
      'mealType': mealType,
    };
  }
}
