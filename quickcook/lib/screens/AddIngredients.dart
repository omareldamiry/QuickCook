import 'package:flutter/material.dart';
import 'package:quickcook/models/Ingredient.dart';
import 'package:quickcook/screens/SearchPage.dart';
import 'package:quickcook/widgets/appbar.dart';

// ignore: must_be_immutable
class AddIngredientsPage extends StatelessWidget {
  List<Ingredient>? ingredients;
  final Function? parentRefresh;

  AddIngredientsPage({Key? key, this.parentRefresh, this.ingredients})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<IngredientTile> ingredientsView = Ingredient.ingredientsList
        .map((e) => IngredientTile(
              key: UniqueKey(),
              title: e.name,
              isChecked: ingredients!
                          .indexWhere((element) => element.name == e.name) !=
                      -1
                  ? true
                  : false,
            ))
        .toList();

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
          List<Ingredient> ingredientsList = ingredientValues(ingredientsView);
          parentRefresh!(ingredientsList);
          Navigator.pop(context);
        },
      ),
    );
  }

  List<Ingredient> ingredientValues(List<IngredientTile> ingredientsView) {
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
  final Key key = new UniqueKey();
  final Function? parentRefresh;
  List<IngredientTile>? ingredientsView = [];

  IngredientPicker({this.parentRefresh, this.ingredientsView});

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
      children: <Widget>[
            ingredientSearchBar(),
            SizedBox(
              height: 20,
            ),
            if (picker.isEmpty) ...expansionTileBuilder() else SizedBox(),
          ] +
          picker +
          [
            SizedBox(
              height: 80,
            ),
          ],
    );
  }

  List<Widget> expansionTileBuilder() {
    List<Widget> exTiles = [];

    IngredientType.values.forEach((type) {
      List<IngredientTile> temp = [];

      ingredientsView!.forEach((tile) {
        if (Ingredient.ingredients()[tile.title]!.type == type) {
          temp.add(tile);
        }
      });

      exTiles.add(
        Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey[200]!,
                offset: Offset(0, 2),
                blurRadius: 2,
                spreadRadius: 2,
              ),
            ],
            borderRadius: BorderRadius.circular(50),
          ),
          child: ExpansionTile(
            tilePadding: EdgeInsets.symmetric(horizontal: 25),
            childrenPadding: EdgeInsets.only(left: 10),
            title: Text(
              type.toString().substring(15),
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.white,
            children: temp,
          ),
        ),
      );
    });
    return exTiles;
  }

  Widget ingredientSearchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        key: UniqueKey(),
        controller: search,
        decoration: InputDecoration(
            labelText: "Search", suffixIcon: Icon(Icons.search)),
        onChanged: (value) {
          addSelected();

          setState(() {
            picker.clear();
            ingredientSearchResult(keyword: value);
          });
        },
      ),
    );
  }

  void ingredientSearchResult({String keyword = ""}) {
    keyword = keyword.toUpperCase();

    if (keyword.isNotEmpty)
      ingredientsView!.forEach((e) {
        if (e.title.toUpperCase().startsWith(keyword)) {
          picker.add(e);
        }
      });
  }

  void addSelected() {
    picker.forEach((e) {
      if (e.isTrue &&
          !ingredientsList.contains(Ingredient.ingredients()[e.title])) {
        ingredientsList.add(Ingredient.ingredients()[e.title]!);
      }
    });
  }
}
