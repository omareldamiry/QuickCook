import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickcook/models/User.dart';
import 'package:quickcook/services/storage_service.dart';
import 'package:quickcook/utilities/custom-snackbar.dart';
import 'package:quickcook/widgets/appbar.dart';
import 'package:quickcook/widgets/double-widget-container.dart';
import 'package:quickcook/widgets/drawer.dart';
import 'package:provider/provider.dart';
import 'package:quickcook/widgets/image-upload-widget.dart';

class ProfilePage extends StatefulWidget {
  final UserData user;
  const ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _mode = "view";
  XFile? img;
  ImageUploadWidget _picker = ImageUploadWidget(
    button: Icon(
      Icons.camera_alt,
      size: 50,
    ),
  );

  @override
  Widget build(BuildContext context) {
    Future<String?> imgLink =
        context.read<StorageService>().downloadURL(widget.user.profilePic!);

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
              FutureBuilder<String?>(
                future: imgLink,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.width * 0.3,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.orange, width: 3),
                      ),
                      child: CircularProgressIndicator(),
                    );

                  if (snapshot.hasData)
                    return Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.width * 0.3,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.orange, width: 3),
                        image: DecorationImage(
                          image: _picker.img == null
                              ? ResizeImage(
                                  NetworkImage(snapshot.data!),
                                  width: 117,
                                )
                              : ResizeImage(
                                  FileImage(
                                    File(_picker.img!.path),
                                  ),
                                  width: 117,
                                ),
                        ),
                      ),
                      child: _mode == "edit" ? _picker : null,
                    );

                  return Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.width * 0.3,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.orange, width: 3),
                      image: DecorationImage(
                        image: ResizeImage(
                          NetworkImage(
                              "https://image.flaticon.com/icons/png/512/847/847969.png"),
                          width: 117,
                        ),
                      ),
                    ),
                    child: _mode == "edit" ? _picker : null,
                  );
                },
              ),
              Divider(
                thickness: 0,
                color: Colors.white,
                height: 20,
              ),
              Text(
                "${widget.user.firstName} ${widget.user.lastName}",
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
                    widget.user.email,
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
                  onPressed: () async {
                    customSnackBar(context, "Your password has been changed!");
                  },
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
              if (_mode == "view") ...[
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
                  onPressed: () {
                    setState(() {
                      _mode = "edit";
                    });
                  },
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
              ] else ...[
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.red,
                    backgroundColor: Colors.red[100],
                    elevation: 2,
                    shadowColor: Color(Colors.grey[200]!.value),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(100),
                      ),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _mode = "view";
                    });
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.red[400]),
                  ),
                ),
                Divider(
                  thickness: 0,
                  color: Colors.white,
                  height: 5,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.green,
                    backgroundColor: Colors.green[100],
                    elevation: 2,
                    shadowColor: Color(Colors.grey[200]!.value),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(100),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    img = _picker.img;
                    print(img!.path);

                    customSnackBar(context, "Profile updated!");
                    setState(() {
                      _mode = "view";
                    });
                  },
                  child: Text(
                    'Confirm Changes',
                    style: TextStyle(color: Colors.green[400]),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
