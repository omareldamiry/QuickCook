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
    Ingredient(name: "Eggs", type: IngredientType.Meat),
    Ingredient(name: "Honey", type: IngredientType.Sweetners),
    Ingredient(name: "Flour", type: IngredientType.Grains),
    Ingredient(name: "Sugar", type: IngredientType.Sweetners),
    Ingredient(name: "Salt", type: IngredientType.Spices),
    Ingredient(name: "Butter", type: IngredientType.Dairy),
    Ingredient(name: "Milk", type: IngredientType.Dairy),
    Ingredient(name: "Beans", type: IngredientType.Legumes),
    Ingredient(name: "Olive Oil", type: IngredientType.Oil),
    Ingredient(name: "Pepper", type: IngredientType.Spices),
    Ingredient(name: "Tomatoes", type: IngredientType.Vegetable),
  ];

  static Map<String, Ingredient> ingredients() {
    return {
      "Eggs": Ingredient(name: "Eggs", type: IngredientType.Meat),
      "Honey": Ingredient(name: "Honey", type: IngredientType.Sweetners),
      "Flour": Ingredient(name: "Flour", type: IngredientType.Grains),
      "Sugar": Ingredient(name: "Sugar", type: IngredientType.Sweetners),
      "Salt": Ingredient(name: "Salt", type: IngredientType.Spices),
      "Butter": Ingredient(name: "Butter", type: IngredientType.Dairy),
      "Milk": Ingredient(name: "Milk", type: IngredientType.Dairy),
      "Beans": Ingredient(name: "Beans", type: IngredientType.Legumes),
      "Olive Oil": Ingredient(name: "Olive Oil", type: IngredientType.Oil),
      "Pepper": Ingredient(name: "Pepper", type: IngredientType.Spices),
      "Tomatoes": Ingredient(name: "Tomatoes", type: IngredientType.Vegetable),
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
