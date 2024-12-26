import 'package:flutter/material.dart';
import 'package:localisationfutter/screens/Driver/services/driver_auth_service.dart';

class CreateAccountDriver extends StatefulWidget {
  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountDriver> {
  bool isSignUp = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _phoneNumberController = TextEditingController(); // Nouveau champ pour le numéro de téléphone
  String? selectedAmbulance; // Pour stocker la matricule sélectionnée
  List<Map<String, dynamic>> ambulances = []; // Liste des ambulances

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _fetchAmbulances(); // Charger les ambulances au démarrage
  }

  Future<void> _fetchAmbulances() async {
    final fetchedAmbulances = await DriverAuthService().fetchAmbulances();
    if (fetchedAmbulances != null) {
      setState(() {
        ambulances = fetchedAmbulances;
      });
    }
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      if (isSignUp) {
        // Inscription
        final message = await DriverAuthService().register(
          _fullNameController.text,
          _phoneNumberController.text, // Nouveau champ
          _emailController.text,
          _passwordController.text,
          int.parse(selectedAmbulance!), // Convertir l'ID sélectionné en entier
        );

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message ?? "Erreur inconnue.")));
        if (message == "Inscription réussie !") {
          Navigator.pushReplacementNamed(context, '/ViewScreenD');
        }
      } else {
        // Connexion
        final message = await DriverAuthService().login(
          _emailController.text,
          _passwordController.text,
        );

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message ?? "Erreur inconnue.")));
        if (message == "Connexion réussie !") {
          Navigator.pushReplacementNamed(context, '/ViewScreenD');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(isSignUp ? "Create Account" : "Login"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    if (isSignUp) 
                      TextFormField(
                        controller: _fullNameController,
                        decoration: InputDecoration(labelText: 'Full Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                    if (isSignUp) SizedBox(height: 10),
                    if (isSignUp) 
                      TextFormField(
                        controller: _phoneNumberController, // Nouveau champ
                        decoration: InputDecoration(labelText: 'Phone Number'),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          } else if (!RegExp(r'^\+?[0-9]{7,15}$').hasMatch(value)) {
                            return 'Enter a valid phone number';
                          }
                          return null;
                        },
                      ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email address'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        } else if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    if (isSignUp) SizedBox(height: 10),
                    if (isSignUp) 
                      DropdownButtonFormField<String>(
                        value: selectedAmbulance,
                        items: ambulances.map((ambulance) {
                          return DropdownMenuItem<String>(
                            value: ambulance['id'].toString(),
                            child: Text(ambulance['matricule']),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedAmbulance = value;
                          });
                        },
                        decoration: InputDecoration(labelText: "Select Ambulance"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select an ambulance';
                          }
                          return null;
                        },
                      ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: _handleSubmit,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            isSignUp ? 'Sign Up' : 'Login',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isSignUp = !isSignUp;
                        });
                      },
                      child: Text(
                        isSignUp ? 'Already have an account? Login' : 'Don\'t have an account? Sign Up',
                        style: TextStyle(fontSize: 16, color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
