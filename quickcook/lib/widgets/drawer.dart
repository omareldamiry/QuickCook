import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickcook/HomePage.dart';
import 'package:quickcook/models/User.dart';
import 'package:quickcook/screens/ProfilePage.dart';
import 'package:quickcook/screens/myRecipes.dart';
import 'package:quickcook/services/UserDA.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
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
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            },
          ),
          ListTile(
            title: Text("My Recipes"),
            onTap: () {
              // Navigator.pop(context);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => MyRecipesPage()));
            },
          ),
          ListTile(
            title: Text("Favorites"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text("Profile"),
            onTap: () async {
              UserData currentUser = await context
                  .read<UserDA>()
                  .getUser(FirebaseAuth.instance.currentUser!.email!);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => ProfilePage(user: currentUser)));
            },
          ),
        ],
      ),
    );
  }
}
