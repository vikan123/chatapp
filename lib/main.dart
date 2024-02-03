import 'dart:async';

import 'package:chatapp/Screen/loginscreen.dart';
import 'package:chatapp/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyBZM43gT8VJrAZpTw0dI6S0zgwIHJCVBQE',
          appId: '1:499515476264:android:30ecf8869b1dacdeaf281d',
          messagingSenderId: '499515476264',
          projectId: 'chatapp-c2837',
          storageBucket: 'gs://chatapp-c2837.appspot.com'));
  await FirebaseAppCheck.instance.activate();

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: Provider.of<ThemeProvider>(context).isDarkMode
            ? ThemeData.dark()
            : ThemeData.light(),
        home:const SplashScreen(),
      routes: {
        '/home': (context) => const LoginScreen(), // Replace HomeScreen with your main app screen
      },

    );
  }
}
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate some initialization process, you can replace this with your actual initialization logic
    Timer(
      const Duration(seconds: 3),
          () => Navigator.pushReplacementNamed(context, '/home'),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network("https://www.pngall.com/wp-content/uploads/2016/04/Chat-High-Quality-PNG.png"),
      ),
    );
  }
}

