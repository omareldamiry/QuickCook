import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quickcook/models/Ingredient.dart';
import 'package:quickcook/models/Recipe.dart';
import 'package:provider/provider.dart';
import 'package:quickcook/services/RecipeDA.dart';
import 'package:quickcook/services/storage_service.dart';
import 'package:quickcook/utilities/custom-snackbar.dart';
import 'package:quickcook/widgets/appbar.dart';
import 'package:quickcook/widgets/double-widget-container.dart';
import 'package:quickcook/widgets/image-upload-widget.dart';

// ignore: must_be_immutable
class AddRecipePage extends StatefulWidget {
  final Key key = UniqueKey();
  final String mode;
  final Recipe? recipe;

  AddRecipePage({this.mode = "add", this.recipe});

  @override
  _AddRecipePageState createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  TextEditingController recipeName = TextEditingController();
  TextEditingController recipeDesc = TextEditingController();
  // int? calCount;
  // int? prepTime;
  NumericValueInput? calWidget;
  NumericValueInput? timeWidget;
  ImageUploadWidget imageWidget = ImageUploadWidget();
  IngredientInput? ingredientInput;

  @override
  void initState() {
    super.initState();
    if (widget.recipe != null) {
      recipeName.text = widget.recipe!.recipeName;
      recipeDesc.text = widget.recipe!.recipeDesc;
      calWidget =
          NumericValueInput(count: widget.recipe!.recipeCal, unit: "Cal(s)");
      timeWidget = NumericValueInput(
          count: widget.recipe!.recipePrepTime, unit: "min(s)");
      ingredientInput =
          IngredientInput(ingredients: widget.recipe!.recipeIngredients);
    } else {
      calWidget = NumericValueInput(unit: "Cal(s)");
      timeWidget = NumericValueInput(unit: "min(s)");
      ingredientInput = IngredientInput(ingredients: []);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
          title: widget.mode == "add" ? "Add New Recipe" : "Edit Recipe"),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Form(
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
                    widget.mode == "add" ? "Add Recipe" : "Edit Recipe",
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
                            controller: recipeDesc,
                            maxLines: 20,
                            maxLength: 1000,
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
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.check,
          color: Colors.white,
        ),
        onPressed: () async {
          if (recipeName.text == "") {
            customSnackBar(context, "Recipe name cannot be empty");
          } else if (ingredientInput!.ingredients.length < 2) {
            customSnackBar(
                context, "A recipe must have at least 2 ingredients");
          } else if (calWidget!.count < 1) {
            customSnackBar(context, "Calories cannot be less than 1 calorie");
          } else if (timeWidget!.count < 1) {
            customSnackBar(
                context, "Preparation time cannot be less than 1 minute");
          } else {
            String filePath = "";
            String fileName = "";
            if (imageWidget.img != null) {
              filePath = imageWidget.img!.path;
              fileName = imageWidget.img!.name;
            }
            String dest = "/imgs/recipepics/";

            String newRecipePicLink;

            if (imageWidget.img != null) {
              newRecipePicLink = dest + imageWidget.img!.name;
            } else if (widget.recipe != null) {
              newRecipePicLink = widget.recipe!.recipePicLink;
            } else {
              newRecipePicLink = "/imgs/recipepics/default_recipepic.jpg";
            }
            Recipe newRecipe = Recipe(
              id: widget.recipe != null ? widget.recipe!.id : "",
              recipeName: recipeName.value.text,
              recipeDesc: recipeDesc.text != ""
                  ? recipeDesc.value.text
                  : "No preparation steps for this recipe",
              recipeIngredients: ingredientInput!.ingredients,
              recipeCal: calWidget!.count,
              recipeRating:
                  widget.recipe != null ? widget.recipe!.recipeRating : 0.0,
              recipePrepTime: timeWidget!.count,
              recipeOwner: FirebaseAuth.instance.currentUser!.email!,
              recipePicLink: newRecipePicLink,
            );

            if (widget.mode == "add") {
              if (newRecipePicLink != "/imgs/recipepics/default_recipepic.jpg")
                await context
                    .read<StorageService>()
                    .uploadFile(filePath, fileName, dest);
              await context.read<RecipeDA>().addRecipe(newRecipe);
            } else {
              print(newRecipe.toJson());
              if (imageWidget.img != null &&
                  newRecipePicLink != "/imgs/recipepics/default_recipepic.jpg")
                await context
                    .read<StorageService>()
                    .uploadFile(filePath, fileName, dest);
              await context.read<RecipeDA>().editRecipe(newRecipe);
            }

            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, '/myrecipes');
          }
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
      widget.ingredients = _ingredients;
    });
  }

  @override
  void dispose() {
    super.dispose();
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
  TextEditingController _countController = TextEditingController();

  _NumericValueInputState(this.count, this.unit);

  @override
  Widget build(BuildContext context) {
    _countController.text = count.toString();
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
                  _countController.text = count.toString();
                  widget.count = count;
                });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 30,
                child: TextField(
                  controller: _countController,
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.ltr,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    if (value != "") {
                      count = int.parse(value);
                      widget.count = count;
                    }
                  },
                  decoration: InputDecoration(
                    isDense: true,
                  ),
                ),
              ),
              Text(unit),
            ],
          ),
          // Text("$count $unit"),
          IconButton(
              icon: Icon(
                Icons.chevron_right,
                color: Colors.orange,
              ),
              onPressed: () {
                setState(() {
                  count++;
                  _countController.text = count.toString();
                  widget.count = count;
                });
              }),
        ],
      ),
    );
  }
}
