import 'package:flutter/material.dart';
import 'package:quickcook/models/User.dart';
import 'package:quickcook/widgets/appbar.dart';
import 'package:quickcook/widgets/drawer.dart';

class ProfilePage extends StatelessWidget {
  final UserData user;
  const ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: "Profile"),
      drawer: MyDrawer(currentRoute: '/profile',),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          "${user.firstName} ${user.lastName}",
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
