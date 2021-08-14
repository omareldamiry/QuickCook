import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickcook/screens/HomePage.dart';
import 'package:quickcook/services/auth_service.dart';
import 'package:quickcook/models/User.dart';
import 'package:quickcook/screens/Favourites.dart';
import 'package:quickcook/screens/ProfilePage.dart';
import 'package:quickcook/screens/myRecipes.dart';
import 'package:quickcook/services/UserDA.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Scaffold(
        body: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                "QuickCook",
                style: TextStyle(color: Colors.white),
              ),
              decoration: BoxDecoration(
                color: Colors.orange,
              ),
            ),
            ListTile(
              title: Text("Home"),
              onTap: () {
                // Navigator.pop(context);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
            ),
            Divider(
              thickness: 1,
              height: 0,
            ),
            ListTile(
              title: Text("My Recipes"),
              onTap: () {
                // Navigator.pop(context);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => MyRecipesPage()));
              },
            ),
            Divider(
              thickness: 1,
              height: 0,
            ),
            ListTile(
              title: Text("Favorites"),
              onTap: () async {
                UserData currentUser = await context
                    .read<UserDA>()
                    .getUser(FirebaseAuth.instance.currentUser!.email!);

                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          FavouritesPage(favourites: currentUser.favorites),
                    ));
              },
            ),
            Divider(
              thickness: 1,
              height: 0,
            ),
            ListTile(
              title: Text("Profile"),
              onTap: () async {
                UserData currentUser = await context
                    .read<UserDA>()
                    .getUser(FirebaseAuth.instance.currentUser!.email!);

                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfilePage(user: currentUser)));
              },
            ),
          ],
        ),
        bottomNavigationBar: ListTile(
          title: Text("Logout"),
          trailing: Icon(
            Icons.logout,
            color: Colors.red,
          ),
          onTap: () {
            context.read<AuthService>().signOut();
          },
        ),
      ),
    );
  }
}
