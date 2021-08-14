import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quickcook/HomePage.dart';
import 'package:quickcook/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:quickcook/models/User.dart';
import 'package:quickcook/screens/LoginPage.dart';
import 'package:quickcook/services/UserDA.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SignupForm(),
    );
  }
}

class SignupForm extends StatefulWidget {
  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  bool _initialized = false;
  bool _error = false;
  bool _isPasswordMatching = false;
  final TextEditingController fNameController = TextEditingController();
  final TextEditingController lNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  static GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return Center();
    }

    if (!_initialized) {
      return Center();
    }

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 70),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Signup",
                      style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      controller: fNameController,
                      style: TextStyle(fontSize: 15),
                      decoration: InputDecoration(
                        // border: OutlineInputBorder(
                        //     borderRadius: BorderRadius.all(Radius.circular(10.0))),
                        labelText: "First Name",
                        labelStyle: TextStyle(fontSize: 15),
                      ),
                    ),
                    TextFormField(
                      controller: lNameController,
                      style: TextStyle(fontSize: 15),
                      decoration: InputDecoration(
                        // border: OutlineInputBorder(
                        //     borderRadius: BorderRadius.all(Radius.circular(10.0))),
                        labelText: "Last Name",
                        labelStyle: TextStyle(fontSize: 15),
                      ),
                    ),
                    TextFormField(
                      controller: emailController,
                      style: TextStyle(fontSize: 15),
                      decoration: InputDecoration(
                        // border: OutlineInputBorder(
                        //     borderRadius: BorderRadius.all(Radius.circular(10.0))),
                        labelText: "Email",
                        labelStyle: TextStyle(fontSize: 15),
                      ),
                    ),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      style: TextStyle(fontSize: 15),
                      decoration: InputDecoration(
                        // border: OutlineInputBorder(
                        //     borderRadius: BorderRadius.all(Radius.circular(10.0))),
                        labelText: "Password",
                        labelStyle: TextStyle(fontSize: 15),
                      ),
                    ),
                    TextFormField(
                      onChanged: (value) {
                        if (value.compareTo(passwordController.text) == 0) {
                          setState(() {
                            _isPasswordMatching = true;
                          });
                        } else
                          setState(() {
                            _isPasswordMatching = false;
                          });
                      },
                      obscureText: true,
                      style: TextStyle(fontSize: 15),
                      decoration: InputDecoration(
                        // border: OutlineInputBorder(
                        //     borderRadius: BorderRadius.all(Radius.circular(10.0))),
                        labelText: "Confirm Password",
                        labelStyle: TextStyle(fontSize: 15),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      child: Text('Sign up'),
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                          EdgeInsets.only(left: 100, right: 100),
                        ),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                      ),
                      onPressed: _isPasswordMatching
                          ? () {
                              UserData newUser = UserData(
                                email: emailController.text.trim(),
                                firstName: fNameController.text.trim(),
                                lastName: lNameController.text.trim(),
                              );

                              context.read<UserDA>().addUser(newUser);

                              context.read<AuthService>().signUp(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim());

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomePage(),
                                ),
                              );
                            }
                          : null,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Or"),
                    TextButton(
                      child: Text(
                        'Log in',
                        style: TextStyle(
                            color: Colors.orange,
                            decoration: TextDecoration.underline),
                      ),
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                          EdgeInsets.only(left: 100, right: 100),
                        ),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ));
                      },
                    ),
                  ],
                ),
              ),
            ),
            // Spacer(),
          ],
        ),
      ),
    );
  }
}
