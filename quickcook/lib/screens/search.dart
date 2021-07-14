import 'package:flutter/material.dart';
import 'package:quickcook/HomePage.dart';
import 'package:quickcook/RecipeHandler.dart';

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
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Recipe search",
          style: TextStyle(color: Colors.white),
        ),
      ),
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

  List<int> ingredientQuery(List<IngredientTile> ingredients) {
    List<int> query = [];

    ingredients.forEach((element) {
      element.isTrue
          ? query.add(element.index)
          : print('${element.title} is false');
    });

    if (query.isEmpty) {
      query = null;
    }

    return query;
  }
}

class IngredientTile extends StatefulWidget {
  String title;
  int index;
  bool value = false;
  IngredientTile({Key key, this.title, this.index}) : super(key: key);

  get isTrue {
    return value;
  }

  void newValue(bool newValue) {
    this.value = newValue;
  }

  @override
  _IngredientTileState createState() => _IngredientTileState(
        title: title,
      );
}

class _IngredientTileState extends State<IngredientTile> {
  String title;
  bool _changed = false;

  _IngredientTileState({
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: _changed,
      onChanged: (bool value) {
        super.widget.newValue(_changed);
        print(super.widget.title);
        setState(() {
          _changed = value;
          super.widget.newValue(_changed);
        });
      },
      title: Text("$title"),
    );
  }
}
