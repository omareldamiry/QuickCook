import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quickcook/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:quickcook/screens/SignupPage.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height * 0.2),
        child: Container(
          padding: EdgeInsets.only(top: 50),
          color: Colors.orange,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/svg/cooking-pot.svg',
                width: 100,
                color: Colors.white,
              ),
              SizedBox(height: 10),
              Text(
                "QuickCook",
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Ariel-Rounded",
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      body: LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _initialized = false;
  bool _error = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  static UniqueKey formKey = new UniqueKey();

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
                      "Login",
                      style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
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
                    SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      child: Text('Log in'),
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                          EdgeInsets.only(left: 100, right: 100),
                        ),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                      ),
                      onPressed: () async {
                        String? status = await context
                            .read<AuthService>()
                            .signIn(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim())
                            .then((value) => value);

                        if (status == "Signed in") {
                          // Navigator.pushReplacementNamed(context, '/');
                        } else {
                          // Signin failure implementation
                          print("Sign in failed");
                        }
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Or"),
                    TextButton(
                      child: Text(
                        'Sign up',
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
                              builder: (context) => SignupPage(),
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

  // Widget _customTextFormField({String label = "", bool pass = false}) {
  //   return TextFormField(
  //     obscureText: pass,
  //     style: TextStyle(fontSize: 15),
  //     decoration: InputDecoration(
  //       // border: OutlineInputBorder(
  //       //     borderRadius: BorderRadius.all(Radius.circular(10.0))),
  //       labelText: label,
  //       labelStyle: TextStyle(fontSize: 15),
  //     ),
  //   );
  // }
}
