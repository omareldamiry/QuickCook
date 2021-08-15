import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickcook/models/favorite.dart';
import 'package:quickcook/services/FavoriteDA.dart';
import 'package:quickcook/services/auth_service.dart';
import 'package:quickcook/models/User.dart';
import 'package:quickcook/services/UserDA.dart';

// TODO: Refactor navigation logic into a single _navigate() function

class MyDrawer extends StatelessWidget {
  final String currentRoute;

  MyDrawer({required this.currentRoute});

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
                Navigator.pop(context);
                if (currentRoute == '/') {
                } else {
                  Navigator.pushReplacementNamed(context, '/',
                      arguments: <String>[]);
                }
              },
            ),
            Divider(
              thickness: 1,
              height: 0,
            ),
            ListTile(
              title: Text("My Recipes"),
              onTap: () {
                Navigator.pop(context);
                if (currentRoute == '/myrecipes') {
                } else if (currentRoute == '/') {
                  Navigator.pushNamed(context, '/myrecipes');
                } else {
                  Navigator.pushReplacementNamed(context, '/myrecipes');
                }
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

                List<Favorite> favorites = await context
                    .read<FavoriteDA>()
                    .getFavorites(currentUser.id);

                Navigator.pop(context);
                if (currentRoute == '/favorites') {
                } else if (currentRoute == '/') {
                  Navigator.pushNamed(context, '/favorites',
                      arguments: favorites);
                } else {
                  Navigator.pushReplacementNamed(context, '/favorites',
                      arguments: favorites);
                }
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

                Navigator.pop(context);
                if (currentRoute == '/profile') {
                } else if (currentRoute == '/') {
                  Navigator.pushNamed(context, '/profile',
                      arguments: currentUser);
                } else {
                  Navigator.pushReplacementNamed(context, '/profile',
                      arguments: currentUser);
                }
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
          onTap: () async {
            Navigator.pop(context);

            if (currentRoute != '/') Navigator.pop(context);
            await context.read<AuthService>().signOut();
          },
        ),
      ),
    );
  }

  void _navigate(String dest, Object? args) {}
}
