import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quickcook/models/Ingredient.dart';
import 'package:quickcook/models/Recipe.dart';
import 'package:provider/provider.dart';
import 'package:quickcook/services/RecipeDA.dart';
import 'package:quickcook/widgets/appbar.dart';
import 'package:quickcook/widgets/double-widget-container.dart';
import 'package:quickcook/widgets/image-upload-widget.dart';

class AddRecipePage extends StatelessWidget {
  final TextEditingController recipeName = TextEditingController();
  final TextEditingController recipeDesc = TextEditingController();
  late final int calCount;
  late final int prepTime;
  final NumericValueInput calWidget = NumericValueInput(unit: "Cal(s)");
  final NumericValueInput timeWidget = NumericValueInput(unit: "min(s)");
  final List<Ingredient> ingredientsList = [];
  final IngredientInput ingredientInput = IngredientInput(
    ingredients: [],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: "Add New Recipe"),
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
                  "Add Recipe",
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
                        widget1: ImageUploadWidget(),
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
        onPressed: () {
          Recipe newRecipe = Recipe(
            recipeName: recipeName.value.text,
            recipeIngredients: ingredientInput.ingredients,
            recipeCal: calWidget.count,
            recipePrepTime: timeWidget.count,
            recipeOwner: FirebaseAuth.instance.currentUser!.email!,
          );

          context.read<RecipeDA>().addRecipe(newRecipe);
          Navigator.pushReplacementNamed(context, '/myrecipes');
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class IngredientInput extends StatefulWidget {
  List<Ingredient> ingredients = [];

  IngredientInput({Key? key, required this.ingredients}) : super(key: key);

  void newIngredients(List<Ingredient> _ingredients) {
    ingredients = _ingredients;
  }

  @override
  _IngredientInputState createState() =>
      _IngredientInputState(ingredients: ingredients);
}

class _IngredientInputState extends State<IngredientInput> {
  late List<Ingredient> ingredients;
  int ingredientCount = 0;

  _IngredientInputState({required List<Ingredient> ingredients});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("$ingredientCount selected"),
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
          onPressed: () {
            Navigator.pushNamed(context, '/addingredients', arguments: refresh);
          },
          child: Text("Add Ingredients"),
        ),
      ],
    );
  }

  void refresh(List<Ingredient> _ingredients) {
    setState(() {
      ingredients = _ingredients;
      ingredientCount = _ingredients.length;
      super.widget.newIngredients(_ingredients);
    });
  }
}

class NumericValueInput extends StatefulWidget {
  final String unit;
  final Key key = new UniqueKey();
  int count = 1;

  NumericValueInput({this.unit = ""});

  @override
  _NumericValueInputState createState() => _NumericValueInputState(unit);
}

class _NumericValueInputState extends State<NumericValueInput> {
  int count = 1;
  String unit = "";

  _NumericValueInputState(this.unit);

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
