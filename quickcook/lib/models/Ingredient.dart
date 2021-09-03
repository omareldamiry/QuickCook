enum IngredientType {
  Dairy,
  Vegetable,
  Fruit,
  Sweetners,
  Grains,
  Legumes,
  Meat,
  Spices,
  Oil,
  Baking,
}

class Ingredient {
  final String name;
  final IngredientType type;

  const Ingredient({required this.name, required this.type});

  @override
  String toString() {
    return name;
  }

  static List<Ingredient> ingredientsList = [
    Ingredient(name: "Apples", type: IngredientType.Fruit),
    Ingredient(name: "Lemons", type: IngredientType.Fruit),
    Ingredient(name: "Eggs", type: IngredientType.Meat),
    Ingredient(name: "Honey", type: IngredientType.Sweetners),
    Ingredient(name: "Flour", type: IngredientType.Grains),
    Ingredient(name: "Rice", type: IngredientType.Grains),
    Ingredient(name: "Sugar", type: IngredientType.Sweetners),
    Ingredient(name: "Brown Sugar", type: IngredientType.Sweetners),
    Ingredient(name: "Salt", type: IngredientType.Spices),
    Ingredient(name: "Butter", type: IngredientType.Dairy),
    Ingredient(name: "Milk", type: IngredientType.Dairy),
    Ingredient(name: "Beans", type: IngredientType.Legumes),
    Ingredient(name: "Fava Beans", type: IngredientType.Legumes),
    Ingredient(name: "Olive Oil", type: IngredientType.Oil),
    Ingredient(name: "Pepper", type: IngredientType.Spices),
    Ingredient(name: "Cumin", type: IngredientType.Spices),
    Ingredient(name: "Bell Pepper", type: IngredientType.Vegetable),
    Ingredient(name: "Chili Pepper", type: IngredientType.Vegetable),
    Ingredient(name: "Parsley", type: IngredientType.Vegetable),
    Ingredient(name: "Tomatoes", type: IngredientType.Vegetable),
    Ingredient(name: "Garlic", type: IngredientType.Vegetable),
    Ingredient(name: "Baking Powder", type: IngredientType.Baking),
    Ingredient(name: "Baking Soda", type: IngredientType.Baking),
  ];

  static Map<String, Ingredient> ingredients() {
    return {
      "Apples": Ingredient(name: "Apples", type: IngredientType.Fruit),
      "Lemons": Ingredient(name: "Lemons", type: IngredientType.Fruit),
      "Eggs": Ingredient(name: "Eggs", type: IngredientType.Meat),
      "Honey": Ingredient(name: "Honey", type: IngredientType.Sweetners),
      "Flour": Ingredient(name: "Flour", type: IngredientType.Grains),
      "Rice": Ingredient(name: "Rice", type: IngredientType.Grains),
      "Sugar": Ingredient(name: "Sugar", type: IngredientType.Sweetners),
      "Brown Sugar":
          Ingredient(name: "Brown Sugar", type: IngredientType.Sweetners),
      "Salt": Ingredient(name: "Salt", type: IngredientType.Spices),
      "Butter": Ingredient(name: "Butter", type: IngredientType.Dairy),
      "Milk": Ingredient(name: "Milk", type: IngredientType.Dairy),
      "Beans": Ingredient(name: "Beans", type: IngredientType.Legumes),
      "Fava Beans":
          Ingredient(name: "Fava Beans", type: IngredientType.Legumes),
      "Olive Oil": Ingredient(name: "Olive Oil", type: IngredientType.Oil),
      "Pepper": Ingredient(name: "Pepper", type: IngredientType.Spices),
      "Cumin": Ingredient(name: "Cumin", type: IngredientType.Spices),
      "Garlic Powder":
          Ingredient(name: "Garlic Powder", type: IngredientType.Spices),
      "Bell Pepper":
          Ingredient(name: "Bell Pepper", type: IngredientType.Vegetable),
      "Chili Pepper":
          Ingredient(name: "Chili Pepper", type: IngredientType.Vegetable),
      "Parsley": Ingredient(name: "Parsley", type: IngredientType.Vegetable),
      "Tomatoes": Ingredient(name: "Tomatoes", type: IngredientType.Vegetable),
      "Garlic": Ingredient(name: "Garlic", type: IngredientType.Vegetable),
      "Baking Powder":
          Ingredient(name: "Baking Powder", type: IngredientType.Baking),
      "Baking Soda":
          Ingredient(name: "Baking Soda", type: IngredientType.Baking),
    };
  }

  static List<Ingredient> fromJsonList(List<dynamic> jsonList) {
    List<Ingredient> output = [];
    jsonList.forEach((element) {
      output.add(Ingredient.ingredients()[element]!);
    });

    return output;
  }
}
