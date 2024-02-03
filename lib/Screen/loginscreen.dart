import 'package:chatapp/Screen/create_account.dart';
import 'package:chatapp/Screen/homeScreen.dart';
import 'package:chatapp/methods.dart';
import 'package:chatapp/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isLoading = false;
  bool isGoogleLogin = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: isLoading
            ? Center(
                child: Container(
                height: size.height / 20,
                width: size.width / 20,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              ))
            : SingleChildScrollView(
                child: Column(
                children: [
                  SizedBox(
                    height: size.height / 20,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios),
                            onPressed: () {},
                          ),
                        ),
                        Expanded(
                            child:Padding(padding: EdgeInsets.all(20),child:Align(
                                alignment: Alignment.centerRight,
                                child: Switch(
                          value: Provider.of<ThemeProvider>(context).isDarkMode,
                          onChanged: (value) {
                            Provider.of<ThemeProvider>(context, listen: false)
                                .toggleTheme();
                          },
                        ))
                        ))]),
                  SizedBox(
                    height: size.height / 50,
                  ),
                  Container(
                    width: size.width / 1.2,
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Welcome",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: size.width / 1.2,
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Sign in to continue!",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey),
                    ),
                  ),
                  SizedBox(
                    height: size.height / 10,
                  ),
                  Container(
                    width: size.width,
                    alignment: Alignment.center,
                    child: field(size, "email", Icons.account_box, _email),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      child: Container(
                        width: size.width,
                        alignment: Alignment.center,
                        child: field(size, "password", Icons.lock, _password),
                      )),
                  SizedBox(
                    height: size.height / 20,
                  ),
                  customButton(size),
                  SizedBox(
                    height: size.height / 40,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const CreateAccount())),
                    child: const Text(
                      "Create Account",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue),
                    ),
                  ),
                  SizedBox(height: size.height/25,),
                  InkWell(
                    onTap: () async{
                      signInWithGoogle();
                    },
                    child: CircleAvatar(
                      radius: 30,
                      child: Image.network("https://www.freepnglogos.com/uploads/google-logo-png/google-logo-png-suite-everything-you-need-know-about-google-newest-0.png"),
                    )
                  )
                ],
              )));
  }

  Widget customButton(Size size) {
    return GestureDetector(
        onTap: () {
          if (_email.text.isNotEmpty && _password.text.isNotEmpty) {
            setState(() {
              isLoading = true;
            });
            login(_email.text, _password.text).then((user) {
              if (user != null) {
                setState(() {
                  isLoading = false;
                });
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()));
                print("Login Successfull!");
              } else {
                print("Login Failed!");
              }
            });
          } else {
            print("please enter all fields");
          }
        },
        child: Container(
          height: size.height / 15,
          width: size.width / 1.1,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.blue,
          ),
          alignment: Alignment.center,
          child: const Text("Login",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
        ));
  }

  signInWithGoogle() async {
    try {
      setState(() {
        isGoogleLogin = true;
      });
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      print(googleUser?.email);
      final GoogleSignInAuthentication? googleAuth = await googleUser
          ?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      setState(() {
        isGoogleLogin = false;
      });
      Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
          const HomeScreen()));
      final GoogleSignInAccount? user =
      await GoogleSignIn().signOut();
    } catch (e) {
      setState(() {
        isGoogleLogin = false;
      });
      print(e);
    }
  }
}

Widget field(
    Size size, String hintText, IconData icon, TextEditingController cont) {
  return SizedBox(
    height: size.height / 15,
    width: size.width / 1.1,
    child: TextField(
      controller: cont,
      decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    ),
  );
}
