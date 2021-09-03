import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickcook/models/favorite.dart';
import 'package:quickcook/services/FavoriteDA.dart';
import 'package:quickcook/services/auth_service.dart';
import 'package:quickcook/models/User.dart';
import 'package:quickcook/services/UserDA.dart';
import 'package:quickcook/utilities/current-user.dart';

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
            user!.isAdmin
                ? ListTile(
                    title: Text("My Recipes"),
                    onTap: () {
                      String dest = '/myrecipes';
                      _navigate(context: context, dest: dest);
                    },
                  )
                : SizedBox(),
            Divider(
              thickness: 1,
              height: 0,
            ),
            !user!.isAdmin
                ? ListTile(
                    title: Text("Favorites"),
                    onTap: () async {
                      String dest = '/favorites';
                      UserData currentUser = await context
                          .read<UserDA>()
                          .getUser(FirebaseAuth.instance.currentUser!.uid);

                      List<Favorite> favorites = await context
                          .read<FavoriteDA>()
                          .getFavorites(currentUser.id);

                      _navigate(context: context, dest: dest, args: favorites);
                    },
                  )
                : SizedBox(),
            Divider(
              thickness: 1,
              height: 0,
            ),
            ListTile(
              title: Text("Profile"),
              onTap: () async {
                String dest = '/profile';
                UserData currentUser = await context
                    .read<UserDA>()
                    .getUser(FirebaseAuth.instance.currentUser!.uid);

                _navigate(context: context, dest: dest, args: currentUser);
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

  void _navigate({context, required String dest, Object? args}) {
    Navigator.pop(context);
    if (currentRoute == dest) {
    } else if (currentRoute == '/') {
      Navigator.pushNamed(context, dest, arguments: args);
    } else {
      Navigator.pushReplacementNamed(context, dest, arguments: args);
    }
  }
}
