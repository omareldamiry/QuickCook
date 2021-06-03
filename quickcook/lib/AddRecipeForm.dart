import 'package:flutter/material.dart';

class AddRecipe extends StatelessWidget {
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
        alignment: Alignment.topLeft,
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
              TextFormField(),
              NumericValueInput(
                unit: "min(s)",
              ),
              NumericValueInput(
                unit: "Cal",
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
        onPressed: () {},
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
