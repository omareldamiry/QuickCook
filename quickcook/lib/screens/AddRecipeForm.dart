import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quickcook/models/Ingredient.dart';
import 'package:quickcook/models/Recipe.dart';
import 'package:provider/provider.dart';
import 'package:quickcook/services/RecipeDA.dart';
import 'package:quickcook/services/storage_service.dart';
import 'package:quickcook/widgets/appbar.dart';
import 'package:quickcook/widgets/double-widget-container.dart';
import 'package:quickcook/widgets/image-upload-widget.dart';

// ignore: must_be_immutable
class AddRecipePage extends StatelessWidget {
  final String mode;
  final Recipe? recipe;
  late final TextEditingController recipeName = TextEditingController();
  late final TextEditingController recipeDesc = TextEditingController();
  late final int calCount;
  late final int prepTime;
  late NumericValueInput calWidget;
  late NumericValueInput timeWidget;
  late final ImageUploadWidget imageWidget = ImageUploadWidget();
  // late final List<Ingredient> ingredientsList;
  late IngredientInput ingredientInput;

  AddRecipePage({this.mode = "add", this.recipe});

  @override
  Widget build(BuildContext context) {
    if (recipe != null) {
      recipeName.text = recipe!.recipeName;
      calWidget = NumericValueInput(count: recipe!.recipeCal, unit: "Cal(s)");
      timeWidget =
          NumericValueInput(count: recipe!.recipePrepTime, unit: "min(s)");
      ingredientInput = IngredientInput(ingredients: recipe!.recipeIngredients);
    } else {
      calWidget = NumericValueInput(unit: "Cal(s)");
      timeWidget = NumericValueInput(unit: "min(s)");
      ingredientInput = IngredientInput(ingredients: []);
    }

    return Scaffold(
      appBar: myAppBar(title: mode == "add" ? "Add New Recipe" : "Edit Recipe"),
      body: Form(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            padding: EdgeInsets.symmetric(
                vertical: 20,
                horizontal: MediaQuery.of(context).size.width * 0.1),
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  mode == "add" ? "Add Recipe" : "Edit Recipe",
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
                // Form items go here
                //
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 0),
                  width: MediaQuery.of(context).size.width * 0.8,
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      DoubleWidgetContainer(
                        widget1: TextFormField(
                          controller: recipeName,
                          maxLength: 50,
                          decoration: InputDecoration(
                            labelText: "Recipe Name",
                          ),
                        ),
                        widget2: ingredientInput,
                        labels: ["", "Ingredients"],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      DoubleWidgetContainer(
                        widget1: calWidget,
                        widget2: timeWidget,
                        labels: ["Calories", "Preparation Time"],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      DoubleWidgetContainer(
                        widget1: imageWidget,
                        widget2: TextFormField(
                          enabled: false,
                          maxLength: 50,
                        ),
                        labels: ["Recipe Picture", "Description"],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.check,
          color: Colors.white,
        ),
        onPressed: () async {
          String filePath = imageWidget.img!.path;
          String fileName = imageWidget.img!.name;
          String dest = "/imgs/recipepics/";

          Recipe newRecipe = Recipe(
            recipeName: recipeName.value.text,
            recipeIngredients: ingredientInput.ingredients,
            recipeCal: calWidget.count,
            recipePrepTime: timeWidget.count,
            recipeOwner: FirebaseAuth.instance.currentUser!.email!,
            recipePicLink: dest + imageWidget.img!.name,
          );

          if (mode == "add") {
            await context
                .read<StorageService>()
                .uploadFile(filePath, fileName, dest);
            await context.read<RecipeDA>().addRecipe(newRecipe);
          } else {
            print(newRecipe.toJson());
            // await context.read<RecipeDA>().editRecipe(newRecipe);
          }

          Navigator.pushReplacementNamed(context, '/myrecipes');
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class IngredientInput extends StatefulWidget {
  Key key = new UniqueKey();
  List<Ingredient> ingredients;

  IngredientInput({required this.ingredients});

  void newIngredients(List<Ingredient> _ingredients) {
    ingredients = _ingredients;
  }

  @override
  _IngredientInputState createState() =>
      _IngredientInputState(ingredients: ingredients);
}

class _IngredientInputState extends State<IngredientInput> {
  List<Ingredient> ingredients;
  // int ingredientCount = 0;

  _IngredientInputState({required this.ingredients});

  @override
  Widget build(BuildContext context) {
    // ingredientCount = ingredients.length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("${ingredients.length} selected"),
        TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 11),
            backgroundColor: Colors.orange[100],
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(50),
              ),
            ),
          ),
          onPressed: () async {
            Map<String, Object?> args = {
              'ingredients': ingredients,
              'refresh': refresh
            };
            await Navigator.pushNamed(context, '/addingredients',
                arguments: args);
          },
          child: Text("Add Ingredients"),
        ),
      ],
    );
  }

  void refresh(List<Ingredient> _ingredients) {
    setState(() {
      ingredients = _ingredients;
      // ingredientCount = _ingredients.length;
      widget.newIngredients(_ingredients);
    });
  }
}

// ignore: must_be_immutable
class NumericValueInput extends StatefulWidget {
  final String unit;
  final Key key = new UniqueKey();
  int count;

  NumericValueInput({this.count = 1, this.unit = ""});

  @override
  _NumericValueInputState createState() => _NumericValueInputState(count, unit);
}

class _NumericValueInputState extends State<NumericValueInput> {
  int count = 1;
  String unit = "";

  _NumericValueInputState(this.count, this.unit);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              Icons.chevron_left,
              color: Colors.orange,
            ),
            color: Colors.red,
            splashColor: Colors.orange,
            onPressed: () {
              if (count > 1)
                setState(() {
                  count--;
                  widget.count = count;
                });
            },
          ),
          Text("$count $unit"),
          IconButton(
              icon: Icon(
                Icons.chevron_right,
                color: Colors.orange,
              ),
              onPressed: () {
                setState(() {
                  count++;
                  widget.count = count;
                });
              }),
        ],
      ),
    );
  }
}
