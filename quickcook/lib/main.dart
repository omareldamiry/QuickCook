import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:provider/provider.dart';
import 'package:quickcook/screens/HomePage.dart';
import 'package:quickcook/services/auth_service.dart';
import 'package:quickcook/screens/LoginPage.dart';
import 'package:quickcook/services/RatingDA.dart';
import 'package:quickcook/services/RecipeDA.dart';
import 'package:quickcook/services/UserDA.dart';

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
        Provider<UserDA>(
          create: (_) => UserDA(),
        ),
        Provider<RecipeDA>(
          create: (_) => RecipeDA(),
        ),
        Provider<RatingDA>(
          create: (_) => RatingDA(),
        ),
        StreamProvider<User?>(
          create: (context) => context.read<AuthService>().authStateChanges,
          initialData: null,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'QuickCook',
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User? firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      return HomePage();
    }

    return LoginPage();
  }
}
