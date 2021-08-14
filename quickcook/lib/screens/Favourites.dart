import 'package:flutter/material.dart';
import 'package:quickcook/widgets/appbar.dart';
import 'package:quickcook/widgets/drawer.dart';

class FavouritesPage extends StatelessWidget {
  final List<String>? favourites;
  const FavouritesPage({Key? key, this.favourites}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: "Favourites"),
      drawer: MyDrawer(),
      body: Container(
        alignment: Alignment.center,
        child: Text("$favourites"),
      ),
    );
  }
}
