import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quickcook/db_service.dart';
import 'package:quickcook/screens/myRecipes.dart';

class AddRecipe extends StatelessWidget {
  final TextEditingController recipeName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Add New Recipe",
          style: TextStyle(color: Colors.white),
        ),
      ),
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
                child: TextFormField(
                  controller: recipeName,
                  maxLength: 50,
                  decoration: InputDecoration(
                    labelText: "Recipe Name",
                  ),
                ),
              ),

              // Ingredient choice will go here
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
          RecipeDA(FirebaseFirestore.instance).addRecipe(recipeName.value.text);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => MyRecipesPage()));
        },
      ),
    );
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

  // void _onPressed() {}
}
