import 'package:flutter/material.dart';
import 'package:quickcook/models/Ingredient.dart';
import 'package:quickcook/screens/SearchPage.dart';
import 'package:quickcook/widgets/appbar.dart';

// ignore: must_be_immutable
class AddIngredientsPage extends StatefulWidget {
  final Key key = UniqueKey();
  List<Ingredient>? ingredients;
  final Function? parentRefresh;

  AddIngredientsPage({this.parentRefresh, this.ingredients});

  @override
  _AddIngredientsPageState createState() => _AddIngredientsPageState();
}

class _AddIngredientsPageState extends State<AddIngredientsPage> {
  late List<IngredientTile> ingredientsView;
  late IngredientPicker _ingredientPicker;

  @override
  void initState() {
    super.initState();

    ingredientsView = Ingredient.ingredientsList
        .map((e) => IngredientTile(
              key: UniqueKey(),
              title: e.name,
              isChecked: widget.ingredients!
                          .indexWhere((element) => element.name == e.name) !=
                      -1
                  ? true
                  : false,
            ))
        .toList();

    _ingredientPicker = IngredientPicker(
      ingredientsView: ingredientsView,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: "Add Ingredients"),
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
          Icons.check,
          color: Colors.white,
        ),
        onPressed: () {
          List<Ingredient> ingredientsList = ingredientValues(ingredientsView);
          widget.parentRefresh!(ingredientsList);
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
  final Key key = UniqueKey();
  List<IngredientTile>? ingredientsView = [];

  IngredientPicker({this.ingredientsView});

  @override
  _IngredientPickerState createState() =>
      _IngredientPickerState(ingredientsView: ingredientsView!);
}

class _IngredientPickerState extends State<IngredientPicker> {
  List<Ingredient> ingredientsList = [];
  List<IngredientTile> picker = [];
  late final TextEditingController search;
  late Widget searchBar;

  List<IngredientTile>? ingredientsView;

  _IngredientPickerState({this.ingredientsView});

  @override
  void initState() {
    super.initState();
    search = TextEditingController();
    searchBar = ingredientSearchBar(staticKey: UniqueKey());
  }

  @override
  Widget build(BuildContext context) {
    ingredientsList = [];
    return Column(
      children: <Widget>[
            searchBar,
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

  Widget ingredientSearchBar({required Key staticKey}) {
    print("searchbar");
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        key: staticKey,
        controller: search,
        decoration: InputDecoration(
          labelText: "Search",
          suffixIcon: Icon(Icons.search),
        ),
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

  @override
  void dispose() {
    super.dispose();
  }
}
