import 'package:flutter/material.dart';
import 'package:quickcook/screens/search.dart';
import 'package:quickcook/utilities/Ingredients.dart';
import 'package:quickcook/widgets/appbar.dart';

// ignore: must_be_immutable
class AddIngredients extends StatelessWidget {
  List<Ingredients>? ingredients;
  final Function? parentRefresh;

  List<IngredientTile> ingredientsView = Ingredients.values
      .map((e) => IngredientTile(
            key: UniqueKey(),
            title: e.toString().substring(12).replaceAll('_', ' '),
            index: e.index,
          ))
      .toList();

  AddIngredients({Key? key, this.parentRefresh, this.ingredients})
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
          List<Ingredients> ingredientsList = ingredientValues();
          parentRefresh!(ingredientsList);
          Navigator.pop(context);
        },
      ),
    );
  }

  List<Ingredients> ingredientValues() {
    List<Ingredients> values = [];

    ingredientsView.forEach((ingredientTile) {
      if (ingredientTile.isTrue)
        values.add(Ingredients.values[ingredientTile.index]);
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
  List<Ingredients> ingredientsList = [];
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
        if (e.title.contains(keyword)) {
          picker.add(e);
        }
      });
  }

  void addSelected() {
    picker.forEach((e) {
      if (e.isTrue && !ingredientsList.contains(Ingredients.values[e.index])) {
        ingredientsView![e.index].newValue(true);
        ingredientsList.add(Ingredients.values[e.index]);
      }
    });
  }
}
