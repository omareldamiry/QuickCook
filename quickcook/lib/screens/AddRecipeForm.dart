import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quickcook/models/Ingredient.dart';
import 'package:quickcook/models/Recipe.dart';
import 'package:provider/provider.dart';
import 'package:quickcook/services/RecipeDA.dart';
import 'package:quickcook/widgets/appbar.dart';

class AddRecipePage extends StatelessWidget {
  final TextEditingController recipeName = TextEditingController();
  final List<Ingredient> ingredientsList = [];
  final IngredientInput ingredientInput = IngredientInput(
    ingredients: [],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: "Add New Recipe"),
      body: Container(
        margin: EdgeInsets.only(top: 10),
        alignment: Alignment.center,
        child: Form(
          child: Column(
            children: [
              Text(
                "Add Recipe",
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Form items go here
              //
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 20),
                width: MediaQuery.of(context).size.width * 0.8,
                alignment: Alignment.center,
                child: Column(
                  children: [
                    TextFormField(
                      controller: recipeName,
                      maxLength: 50,
                      decoration: InputDecoration(
                        labelText: "Recipe Name",
                      ),
                    ),
                    ingredientInput,
                  ],
                ),
              ),
            ],
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
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.orange[100]),
          ),
          onPressed: () {
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) =>
            //             AddIngredientsPage(parentRefresh: refresh)));

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

  const NumericValueInput({this.unit = ""});

  @override
  _NumericValueInputState createState() => _NumericValueInputState(unit);
}

class _NumericValueInputState extends State<NumericValueInput> {
  int count = 0;
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
            onPressed: () {
              if (count > 0)
                setState(() {
                  count--;
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
                });
              }),
        ],
      ),
    );
  }
}
