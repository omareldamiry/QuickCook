import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuickCook',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login', style: TextStyle(color: Colors.white),),
      ),
      body: Container(
        alignment: Alignment.center,
        child: LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        width: 250.0,
        child: Form(
          key: GlobalKey<FormState>(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _customTextFormField(label: 'Enter your email address'),
              _customTextFormField(label: 'Enter your password', pass: true),
              ElevatedButton(
                child: Text('Log in'),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    EdgeInsets.only(left: 100, right: 100),
                  ),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                ),
                onPressed: () {
                  setState(() {});
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _customTextFormField({String label = "", bool pass = false}) {
    return TextFormField(
      obscureText: pass,
      style: TextStyle(fontSize: 15),
      decoration: InputDecoration(
        // border: OutlineInputBorder(
        //     borderRadius: BorderRadius.all(Radius.circular(10.0))),
        labelText: label,
        labelStyle: TextStyle(fontSize: 15),
      ),
    );
  }
}
