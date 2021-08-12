import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:provider/provider.dart';
import 'package:quickcook/HomePage.dart';
import 'package:quickcook/auth_service.dart';
import 'package:quickcook/db_service.dart';
import 'package:quickcook/services/RatingDA.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<AuthService>(
            create: (_) => AuthService(FirebaseAuth.instance),
          ),
          Provider<RecipeDA>(
            create: (_) => RecipeDA(FirebaseFirestore.instance),
          ),
          Provider<RatingDA>(
            create: (_) => RatingDA(FirebaseFirestore.instance),
          ),
          StreamProvider<User?>(
            create: (context) => context.read<AuthService>().authStateChanges,
            initialData: null,
          ),
        ],
        child: MaterialApp(
          title: 'QuickCook',
          theme: ThemeData(
            primarySwatch: Colors.orange,
          ),
          home: AuthWrapper(),
        ));
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User? firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      return HomePage(
        ingredientQuery: [],
      );
    }

    return LoginPage();
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
          style: TextStyle(color: Colors.white),
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
      child: Container(
        alignment: Alignment.center,
        width: 250.0,
        child: Form(
          key: GlobalKey<FormState>(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
              ElevatedButton(
                child: Text('Log in'),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    EdgeInsets.only(left: 100, right: 100),
                  ),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                ),
                onPressed: () {
                  context.read<AuthService>().signIn(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim());
                },
              ),
              Text("Or"),
              ElevatedButton(
                child: Text('Sign up'),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    EdgeInsets.only(left: 100, right: 100),
                  ),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                ),
                onPressed: () {
                  context.read<AuthService>().signUp(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim());
                },
              ),
            ],
          ),
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
