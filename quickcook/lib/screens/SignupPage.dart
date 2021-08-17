import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quickcook/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:quickcook/models/User.dart';
import 'package:quickcook/screens/LoginPage.dart';
import 'package:quickcook/services/UserDA.dart';
import 'package:quickcook/utilities/custom-snackbar.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: SignupForm(),
      ),
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
  static Key formKey = new UniqueKey();

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
                        labelText: "Confirm Password",
                        labelStyle: TextStyle(
                          fontSize: 15,
                        ),
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
                          ? () async {
                              String? status = await context
                                  .read<AuthService>()
                                  .signUp(
                                      email: emailController.text.trim(),
                                      password: passwordController.text.trim())
                                  .catchError((err) => err);

                              customSnackBar(context, status!);

                              UserData newUser = UserData(
                                id: FirebaseAuth.instance.currentUser!.uid,
                                email: emailController.text.trim(),
                                firstName: fNameController.text.trim(),
                                lastName: lNameController.text.trim(),
                              );

                              await context
                                  .read<UserDA>()
                                  .addUser(newUser)
                                  .catchError((err) => err);

                              Navigator.pushReplacementNamed(context, '/');
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
