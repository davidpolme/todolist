import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todolist/MyTask.dart';


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.green,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final FirebaseAuth  firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn  googleSignIn = new GoogleSignIn();


  Future<FirebaseUser> _signIn() async{
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    FirebaseUser firebaseUser = await firebaseAuth.signInWithGoogle(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken
    );

    Navigator.of(context).push(
      new MaterialPageRoute(
          builder: (BuildContext context) => new MyTask(user: firebaseUser, googleSignIn: googleSignIn  )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("img/bg.jpg"), fit: BoxFit.cover
            )
        ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                new Image.asset("img/checkBox.png"),
                new Padding(padding: const EdgeInsets.only(bottom: 80.0),),
                new InkWell(
                    onTap: (){
                      _signIn();
                    },
                    child: new Image.asset("img/SignInGo.png", width: 300.0,)),
              ],
            ),
      )
    );
  }
}


