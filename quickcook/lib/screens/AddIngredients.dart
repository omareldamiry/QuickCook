import 'package:flutter/material.dart';
import 'package:quickcook/models/Ingredient.dart';
import 'package:quickcook/screens/SearchPage.dart';
import 'package:quickcook/widgets/appbar.dart';

// ignore: must_be_immutable
class AddIngredientsPage extends StatelessWidget {
  List<Ingredient>? ingredients;
  final Function? parentRefresh;

  List<IngredientTile> ingredientsView = Ingredient.ingredientsList
      .map((e) => IngredientTile(
            key: UniqueKey(),
            title: e.toString(),
          ))
      .toList();

  AddIngredientsPage({Key? key, this.parentRefresh, this.ingredients})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: "Add Ingredients"),
      body: SingleChildScrollView(
        controller: ScrollController(),
        child: Container(
          alignment: Alignment.topCenter,
          margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.1,
              right: MediaQuery.of(context).size.width * 0.1),
          width: MediaQuery.of(context).size.width * 0.8,
          child: IngredientPicker(
            parentRefresh: parentRefresh!,
            ingredientsView: ingredientsView,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.check,
          color: Colors.white,
        ),
        onPressed: () {
          List<Ingredient> ingredientsList = ingredientValues();
          parentRefresh!(ingredientsList);
          Navigator.pop(context);
        },
      ),
    );
  }

  List<Ingredient> ingredientValues() {
    List<Ingredient> values = [];

    ingredientsView.forEach((ingredientTile) {
      if (ingredientTile.isTrue)
        values.add(Ingredient.ingredients()[ingredientTile.title]!);
    });

    return values;
  }
}

// ignore: must_be_immutable
class IngredientPicker extends StatefulWidget {
  final Function? parentRefresh;
  List<IngredientTile>? ingredientsView = [];

  IngredientPicker({Key? key, this.parentRefresh, this.ingredientsView})
      : super(key: key);

  @override
  _IngredientPickerState createState() => _IngredientPickerState(
      parentRefresh: parentRefresh!, ingredientsView: ingredientsView!);
}

class _IngredientPickerState extends State<IngredientPicker> {
  List<Ingredient> ingredientsList = [];
  List<IngredientTile> picker = [];
  TextEditingController search = TextEditingController();
  Function? parentRefresh;

  List<IngredientTile>? ingredientsView;

  _IngredientPickerState({this.parentRefresh, this.ingredientsView});

  @override
  Widget build(BuildContext context) {
    ingredientsList = [];
    return Column(
      children: <Widget>[ingredientSearchBar()] + picker,
    );
  }

  TextFormField ingredientSearchBar() {
    return TextFormField(
      controller: search,
      decoration: InputDecoration(
        labelText: "Search",
        icon: Icon(Icons.search),
      ),
      onChanged: (value) {
        // addSelected();

        setState(() {
          picker.clear();
          ingredientSearchResult(keyword: value);
        });
      },
    );
  }

  void ingredientSearchResult({String keyword = ""}) {
    keyword = keyword.toUpperCase();

    if (keyword.isNotEmpty)
      ingredientsView!.forEach((e) {
        if (e.title.toUpperCase().contains(keyword)) {
          picker.add(e);
        }
      });
  }

  void addSelected() {
    picker.forEach((e) {
      if (e.isTrue &&
          !ingredientsList.contains(Ingredient.ingredients()[e.title])) {
        // ingredientsView![e.index].newValue(true);
        ingredientsList.add(Ingredient.ingredients()[e.title]!);
      }
    });
  }
}
