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
      drawer: MyDrawer(),
      
    );
  }
}
