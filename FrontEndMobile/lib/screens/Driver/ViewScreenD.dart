import 'package:flutter/material.dart';
import 'package:localisationfutter/screens/Driver/DriverCases.dart';
import 'package:localisationfutter/screens/Driver/DriverLocation.dart';
import 'package:localisationfutter/screens/User/ProfileScreen.dart';// Ajoutez cette ligne pour importer votre écran DriverCases


class ViewScreenD extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Cercle et Nom
            SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey.shade300,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              "Name",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20),

            // Menu
            Expanded(
              child: ListView(
                children: [
                  MenuItem(
                    icon: Icons.home,
                    title: "Home",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DriverCasesScreen()),
                      );
                    },
                  ),
                  MenuItem(
                    icon: Icons.person,
                    title: "Profile",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfileScreen()),
                      );
                    }, // Ajout d'une fonction vide pour éviter l'erreur
                  ),
                  MenuItem(
                    icon: Icons.location_on,
                    title: "Location",
                    onTap: () {
                      Navigator.push(context, 
                      MaterialPageRoute(builder: (context)=> DriverLocationScreen(),
                      )
                      );
                    },
                  ),
                ],
              ),
            ),

            // Image en bas
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Image.asset(
                'assets/group_image.png',
                fit: BoxFit.cover,
                width: double.infinity,
                height: 150,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap; // Paramètre obligatoire pour gérer le clic

  MenuItem({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Exécution de la fonction onTap lors du clic
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          children: [
            Icon(icon, color: Colors.blueGrey, size: 30),
            SizedBox(width: 20),
            Text(
              title,
              style: TextStyle(fontSize: 18, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}