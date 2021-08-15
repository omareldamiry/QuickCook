import 'package:flutter/material.dart';
import 'package:quickcook/models/User.dart';
import 'package:quickcook/widgets/appbar.dart';
import 'package:quickcook/widgets/double-widget-container.dart';
import 'package:quickcook/widgets/drawer.dart';

class ProfilePage extends StatelessWidget {
  final UserData user;
  const ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: "Profile"),
      drawer: MyDrawer(
        currentRoute: '/profile',
      ),
      body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.width * 0.3,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.orange, width: 2),
                    image: DecorationImage(
                        image: ResizeImage(
                      NetworkImage(user.profilePic!.isEmpty
                          ? "https://image.flaticon.com/icons/png/512/847/847969.png"
                          : user.profilePic!),
                      width: 117,
                    )),
                  ),
                ),
                Divider(
                  thickness: 0,
                  color: Colors.white,
                  height: 20,
                ),
                Text(
                  "${user.firstName} ${user.lastName}",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Divider(
                  thickness: 1,
                  color: Colors.white,
                  height: 40,
                ),
                DoubleWidgetContainer(
                  widget1: TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      padding: EdgeInsets.all(0),
                    ),
                    onPressed: () {},
                    child: Text(
                      user.email,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  widget2: TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.grey,
                      backgroundColor: Colors.grey[200],
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      elevation: 2,
                      shadowColor: Color(Colors.grey[200]!.value),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(100),
                        ),
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      "Change Password",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w400),
                    ),
                  ),
                  labels: ["Email", ""],
                ),
                Divider(
                  thickness: 1,
                  color: Colors.white,
                  height: 30,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.orange,
                    backgroundColor: Colors.orange[100],
                    elevation: 2,
                    shadowColor: Color(Colors.grey[200]!.value),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(100),
                      ),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    'Edit Profile',
                    style: TextStyle(color: Colors.orange[400]),
                  ),
                ),
                Divider(
                  thickness: 0,
                  color: Colors.white,
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        primary: Colors.red,
                        backgroundColor: Colors.red[100],
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        elevation: 2,
                        shadowColor: Color(Colors.grey[200]!.value),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(100),
                          ),
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        'Delete Account',
                        style: TextStyle(color: Colors.red[400]),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        primary: Colors.grey,
                        backgroundColor: Colors.grey[200],
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        elevation: 2,
                        shadowColor: Color(Colors.grey[200]!.value),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(100),
                          ),
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        'Log out',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
