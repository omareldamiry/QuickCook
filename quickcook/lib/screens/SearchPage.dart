import 'package:flutter/material.dart';
import 'package:quickcook/models/Ingredient.dart';
import 'package:quickcook/screens/AddIngredients.dart';
import 'package:quickcook/widgets/appbar.dart';

class SearchPage extends StatefulWidget {
  final Key key = UniqueKey();

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  static final Key key = new UniqueKey();
  late IngredientPicker _ingredientPicker;

  late List<IngredientTile> ingredients;

  @override
  void initState() {
    super.initState();

    ingredients = Ingredient.ingredientsList
        .map((e) => IngredientTile(
              key: UniqueKey(),
              title: e.toString(),
            ))
        .toList();

    _ingredientPicker = IngredientPicker(
      key: key,
      ingredientsView: ingredients,
    );
  }

  @override
  Widget build(BuildContext context) {
    _ingredientPicker = IngredientPicker(
      ingredientsView: ingredients,
    );
    return Scaffold(
      appBar: myAppBar(title: "Recipe search"),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.1,
                right: MediaQuery.of(context).size.width * 0.1),
            width: MediaQuery.of(context).size.width * 0.8,
            child: _ingredientPicker,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.arrow_forward,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, '/',
              arguments: ingredientQuery(_ingredientPicker.ingredientsView!));
        },
      ),
    );
  }

  List<String>? ingredientQuery(List<IngredientTile> ingredients) {
    List<String>? query = [];

    ingredients.forEach((element) {
      // ignore: unnecessary_statements
      element.isTrue ? query!.add(element.title) : null;
    });

    if (query.isEmpty) {
      query = null;
    }

    return query;
  }
}

// ignore: must_be_immutable
class IngredientTile extends StatefulWidget {
  String title;
  int? index;
  bool isChecked;
  IngredientTile(
      {Key? key, required this.title, this.index, this.isChecked = false})
      : super(key: key);

  get isTrue {
    return isChecked;
  }

  void newValue(bool newValue) {
    this.isChecked = newValue;
  }

  @override
  _IngredientTileState createState() =>
      _IngredientTileState(title: title, changed: isChecked);
}

class _IngredientTileState extends State<IngredientTile> {
  String title;
  bool changed = false;

  _IngredientTileState({required this.title, required this.changed});

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: changed,
      onChanged: (bool? value) {
        setState(() {
          changed = value!;
          widget.newValue(changed);
        });
      },
      title: Text("$title"),
    );
  }
}
