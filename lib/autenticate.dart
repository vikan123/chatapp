import 'package:chatapp/Screen/homeScreen.dart';
import 'package:chatapp/Screen/loginscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class Authenticate extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

   Authenticate({super.key});
  @override
  Widget build(BuildContext context) {
    if(_auth.currentUser != null){
      return const HomeScreen();
    }
    else{
      return const LoginScreen();
    }
  }
}
