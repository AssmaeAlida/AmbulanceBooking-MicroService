import 'package:flutter/material.dart';
import 'package:localisationfutter/screens/Driver/ViewScreenD.dart';
import 'dart:async';
import 'package:localisationfutter/screens/SelectScreen.dart';
import 'package:localisationfutter/screens/User/CreateAccountScreen.dart';
import 'package:localisationfutter/screens/ViewScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: IntroScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/SelectScreen':(context) => SelectScreen(),
        '/ViewScreenD': (context) => ViewScreenD(),
        '/ViewScreen': (context) => ViewScreen(),
      },
    );
  }
}

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToSelectScreen();
  }

  _navigateToSelectScreen() async {
    await Future.delayed(Duration(seconds: 3));
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/SelectScreen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(  // Utilisation du widget Center pour centrer tout le contenu
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,  // Centrer verticalement
          crossAxisAlignment: CrossAxisAlignment.center,  // Centrer horizontalement
          children: [
            Image.asset(
              'assets/hopital.jpg',
              height: 200,
            ),
            SizedBox(height: 20),
            Text(
              "Welcome To Ambulance Tracker",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 185, 200, 226),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
