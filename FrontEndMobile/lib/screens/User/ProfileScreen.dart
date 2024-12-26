import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image;
  String _name = "";
  String _dob = "";
  String _cin = "";

  final ImagePicker _picker = ImagePicker();

  // Fonction pour prendre une photo
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _processImage(pickedFile.path);
    }
  }

  // Fonction pour traiter l'image avec Tesseract OCR
  Future<void> _processImage(String path) async {
    try {
      String extractedText = await FlutterTesseractOcr.extractText(path);
      print("Texte extrait: $extractedText");  // Debugging line to show OCR output
      // Traitement des données extraites
      setState(() {
        _name = _extractName(extractedText);
        _dob = _extractDOB(extractedText);
        _cin = _extractCIN(extractedText);
      });
    } catch (e) {
      print("Erreur lors de l'extraction du texte : $e");
    }
  }

  String _extractName(String text) {
    // Modify regex to account for different formats (capital letters, spaces, etc.)
    RegExp nameRegEx = RegExp(r"([A-Z][a-z]+ [A-Z][a-z]+)");  // Adjust for proper name formatting
    final match = nameRegEx.firstMatch(text);
    return match != null ? match.group(0)! : "Inconnu";
  }

  String _extractDOB(String text) {
    // Regex to capture common date formats (DD/MM/YYYY)
    RegExp dobRegEx = RegExp(r"\d{2}/\d{2}/\d{4}");
    final match = dobRegEx.firstMatch(text);
    return match != null ? match.group(0)! : "Inconnu";
  }

  String _extractCIN(String text) {
    // Regex for 13-digit CIN
    RegExp cinRegEx = RegExp(r"\d{13}");
    final match = cinRegEx.firstMatch(text);
    return match != null ? match.group(0)! : "Inconnu";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Screen"),
        backgroundColor: Colors.redAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            _image != null
                ? CircleAvatar(
                    radius: 60,
                    backgroundImage: FileImage(_image!),
                  )
                : CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[200],
                    child: Icon(Icons.person, size: 60, color: Colors.grey),
                  ),
            SizedBox(height: 20),
            Text(
              _name.isEmpty ? "Nom et Prénom" : _name,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              _dob.isEmpty ? "Date de naissance" : "Date de naissance: $_dob",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              _cin.isEmpty ? "CIN" : "CIN: $_cin",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: Icon(Icons.camera_alt),
              label: Text("Prendre une photo"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            ),
            SizedBox(height: 20),
            _image != null
                ? Column(
                    children: [
                      Text("Votre CNIC", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      SizedBox(height: 10),
                      Image.file(_image!, height: 200, width: 300),
                    ],
                  )
                : SizedBox.shrink(),
            SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.logout),
              label: Text("LOGOUT"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            ),
          ],
        ),
      ),
    );
  }
}
