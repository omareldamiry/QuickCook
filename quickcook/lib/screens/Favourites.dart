import 'package:flutter/material.dart';
import 'package:quickcook/models/Recipe.dart';
import 'package:quickcook/models/favorite.dart';
import 'package:quickcook/services/RecipeDA.dart';
import 'package:quickcook/widgets/appbar.dart';
import 'package:quickcook/widgets/drawer.dart';
import 'package:provider/provider.dart';
import 'package:quickcook/widgets/recipe-card.dart';

class FavouritesPage extends StatefulWidget {
  List<Favorite>? favorites = [];
  FavouritesPage({Key? key, this.favorites}) : super(key: key);

  @override
  _FavouritesPageState createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: "Favourites"),
      drawer: MyDrawer(),
      body: Container(
        alignment: Alignment.center,
        child: FutureBuilder<List<Recipe>>(
          future: context.read<RecipeDA>().getFavourites(
              favoritesIDs: widget.favorites!.map((e) => e.recipeID).toList()),
          builder:
              (BuildContext context, AsyncSnapshot<List<Recipe>> snapshot) {
            if (snapshot.hasError) return Text("Something went wrong");
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(
                child: CircularProgressIndicator(),
              );
            if (snapshot.hasData) if (snapshot.data!.length != 0) {
              return new ListView.builder(
                clipBehavior: Clip.none,
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.1,
                  vertical: MediaQuery.of(context).size.width * 0.05,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (buildContext, index) {
                  return new RecipeCard(
                    key: Key(snapshot.data![index].id),
                    recipe: snapshot.data![index],
                    isFavorite: true,
                    parentRefresh: refresh,
                  );
                },
                // children: [
                //
                // ]
              );
            }
            return Text("Something went wrong");
          },
        ),
      ),
    );
  }

  void refresh(Favorite value) {
    setState(() {
      super
          .widget
          .favorites!
          .removeWhere((favorite) => favorite.id == value.id);
    });
  }
}
