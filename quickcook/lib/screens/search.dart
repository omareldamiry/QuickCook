import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
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
          children: [
            CheckboxListTile(
              value: false,
              onChanged: (value) {},
              title: Text("Eggs"),
            ),
            CheckboxListTile(
              value: false,
              onChanged: (value) {},
              title: Text("Milk"),
            ),
            CheckboxListTile(
              value: false,
              onChanged: (value) {},
              title: Text("Flour"),
            ),
            CheckboxListTile(
              value: false,
              onChanged: (value) {},
              title: Text("Dates"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.arrow_forward,
          color: Colors.white,
        ),
        onPressed: () {},
      ),
    );
  }
}
