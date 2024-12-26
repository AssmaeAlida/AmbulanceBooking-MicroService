import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Assurez-vous que ce package est correctement importé

class UserCasesScreen extends StatefulWidget {
  const UserCasesScreen({Key? key}) : super(key: key);

  @override
  _UserCasesScreenState createState() => _UserCasesScreenState();
}

class _UserCasesScreenState extends State<UserCasesScreen> {
  void handleCaseSelection(BuildContext context, String caseType) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController nameController = TextEditingController();
        final TextEditingController addressController = TextEditingController();
        final TextEditingController phoneController = TextEditingController();

        return AlertDialog(
          title: Text('Enter your details for $caseType'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                ),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                  ),
                ),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    addressController.text.isNotEmpty &&
                    phoneController.text.isNotEmpty) {
                  final userRequest = {
                    'name': nameController.text,
                    'address': addressController.text,
                    'phone': phoneController.text,
                    'type': caseType,
                    'status': 'PENDING',
                    'date': DateTime.now().toString(),
                  };
                  Navigator.of(context).pop(userRequest); 
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in all fields'),
                    ),
                  );
                }
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void callEmergencyNumber() async {
    const String emergencyNumber = '15';
    final Uri launchUri = Uri(scheme: 'tel', path: emergencyNumber);
    if (await canLaunch(launchUri.toString())) {
      await launch(launchUri.toString());
    } else {
      throw 'Could not launch $launchUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'BOOK AN AMBULANCE',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CaseCard(
                imagePath: 'assets/medical.webp',
                label: 'MEDICAL',
                onTap: () => handleCaseSelection(context, 'Medical'),
              ),
              CaseCard(
                imagePath: 'assets/accident.jpg',
                label: 'ACCIDENT',
                onTap: () => handleCaseSelection(context, 'Accident'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CaseCard(
                imagePath: 'assets/fire.jpg',
                label: 'FIRE',
                onTap: () => handleCaseSelection(context, 'Fire'),
              ),
              CaseCard(
                imagePath: 'assets/autres.png',
                label: 'OTHER',
                onTap: () => handleCaseSelection(context, 'Other'),
              ),
            ],
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: callEmergencyNumber,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent, // Correction ici
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            child: const Text('15 Call'),
          ),
        ],
      ),
    );
  }
}

class CaseCard extends StatelessWidget {
  final String imagePath;
  final String label;
  final VoidCallback onTap;

  const CaseCard({
    Key? key,
    required this.imagePath,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.redAccent, width: 2),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, width: 70, height: 70),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}