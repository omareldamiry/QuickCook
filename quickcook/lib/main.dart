import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:provider/provider.dart';
import 'package:quickcook/models/Ingredient.dart';
import 'package:quickcook/models/Recipe.dart';
import 'package:quickcook/models/User.dart';
import 'package:quickcook/models/favorite.dart';
import 'package:quickcook/screens/AddIngredients.dart';
import 'package:quickcook/screens/AddRecipeForm.dart';
import 'package:quickcook/screens/EditRecipeForm.dart';
import 'package:quickcook/screens/FavoritesPage.dart';
import 'package:quickcook/screens/HomePage.dart';
import 'package:quickcook/screens/ProfilePage.dart';
import 'package:quickcook/screens/RecipeDetails.dart';
import 'package:quickcook/screens/SearchPage.dart';
import 'package:quickcook/screens/SignupPage.dart';
import 'package:quickcook/screens/MyRecipesPage.dart';
import 'package:quickcook/services/FavoriteDA.dart';
import 'package:quickcook/services/auth_service.dart';
import 'package:quickcook/screens/LoginPage.dart';
import 'package:quickcook/services/RatingDA.dart';
import 'package:quickcook/services/RecipeDA.dart';
import 'package:quickcook/services/UserDA.dart';
import 'package:quickcook/services/storage_service.dart';

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
        Provider<StorageService>(
          create: (_) => StorageService(),
        ),
        Provider<UserDA>(
          create: (_) => UserDA(),
        ),
        StreamProvider<User?>(
          create: (context) => context.read<AuthService>().authStateChanges,
          initialData: null,
        ),
        Provider<RecipeDA>(
          create: (_) => RecipeDA(),
        ),
        Provider<RatingDA>(
          create: (_) => RatingDA(),
        ),
        Provider<FavoriteDA>(
          create: (_) => FavoriteDA(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: (settings) {
          if (settings.name == '/') {
            Object? args = settings.arguments;
            if (args == null) args = <String>[];
            return MaterialPageRoute(
                builder: (context) => AuthWrapper(
                      ingredientQuery: args as List<String>,
                    ));
          }

          if (settings.name == '/login') {
            return MaterialPageRoute(builder: (context) => LoginPage());
          }

          if (settings.name == '/signup') {
            return MaterialPageRoute(builder: (context) => SignupPage());
          }

          if (settings.name == '/search') {
            return MaterialPageRoute(builder: (context) => SearchPage());
          }

          if (settings.name == '/myrecipes') {
            return MaterialPageRoute(builder: (context) => MyRecipesPage());
          }

          if (settings.name == '/addrecipe') {
            return MaterialPageRoute(builder: (context) => AddRecipePage());
          }

          if (settings.name == '/editrecipe') {
            Map<String, Object?> args =
                settings.arguments! as Map<String, Object?>;
            return MaterialPageRoute(
                builder: (context) => EditRecipePage(
                      recipe: args['recipe']! as Recipe,
                      parentRefresh: args['refresh']! as Function,
                    ));
          }

          if (settings.name == '/addingredients') {
            Map<String, Object?> args =
                settings.arguments! as Map<String, Object?>;
            return MaterialPageRoute(
                builder: (context) => AddIngredientsPage(
                      ingredients: args['ingredients']! as List<Ingredient>,
                      parentRefresh: args['refresh']! as Function,
                    ));
          }

          if (settings.name == '/details') {
            return MaterialPageRoute(
                builder: (context) =>
                    RecipeDetailsPage(id: settings.arguments! as String));
          }

          if (settings.name == '/favorites') {
            return MaterialPageRoute(
                builder: (context) => FavoritesPage(
                      favorites: settings.arguments! as List<Favorite>,
                    ));
          }

          if (settings.name == '/profile') {
            return MaterialPageRoute(
                builder: (context) =>
                    ProfilePage(user: settings.arguments! as UserData));
          }
        },
        title: 'QuickCook',
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        // home: AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  final List<String>? ingredientQuery;

  const AuthWrapper({this.ingredientQuery});

  @override
  Widget build(BuildContext context) {
    final User? firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      return HomePage(
        ingredientQuery: ingredientQuery,
      );
    }

    return LoginPage();
  }
}
