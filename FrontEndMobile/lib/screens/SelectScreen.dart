import 'package:flutter/material.dart';
import 'package:localisationfutter/screens/User/CreateAccountScreen.dart';
import 'package:localisationfutter/screens/Driver/CreateAccountDriver.dart' ;

class SelectScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Select Your Identity",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              
              SizedBox(height: 50),
              GestureDetector(
                onTap: () {
                  // Redirection vers CreateAccountScreen pour Local User
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateAccountScreen()),
                  );
                },
                child: IdentityCard(
                  imagePath: 'assets/user.png',
                  label: 'Local User',
                ),
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateAccountDriver()),
                  );
                },
                child: IdentityCard(
                  imagePath: 'assets/ambulance.jpg',
                  label: 'Ambulance Driver',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IdentityCard extends StatelessWidget {
  final String imagePath;
  final String label;

  const IdentityCard({Key? key, required this.imagePath, required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: Colors.grey[200],
          backgroundImage: AssetImage(imagePath),
        ),
        SizedBox(height: 15),
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}