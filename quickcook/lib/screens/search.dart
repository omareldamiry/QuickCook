import 'package:flutter/material.dart';
import 'package:quickcook/HomePage.dart';
import 'package:quickcook/utilities/Ingredients.dart';
import 'package:quickcook/widgets/appbar.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPage createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage> {
  List<IngredientTile> ingredients = Ingredients.values
      .map((e) => IngredientTile(
            title: e.toString().substring(12).replaceAll('_', ' '),
            index: e.index,
          ))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: "Recipe search"),
      body: Container(
        child: ListView(
          children: ingredients,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.arrow_forward,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.pop(context);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage(
                        ingredientQuery: ingredientQuery(ingredients),
                      )));
        },
      ),
    );
  }

  List<int>? ingredientQuery(List<IngredientTile> ingredients) {
    List<int>? query = [];

    ingredients.forEach((element) {
      // ignore: unnecessary_statements
      element.isTrue ? query!.add(element.index) : null;
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
  int index;
  bool isChecked;
  IngredientTile(
      {Key? key,
      required this.title,
      required this.index,
      this.isChecked = false})
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
          super.widget.newValue(changed);
        });
      },
      title: Text("$title"),
    );
  }
}
