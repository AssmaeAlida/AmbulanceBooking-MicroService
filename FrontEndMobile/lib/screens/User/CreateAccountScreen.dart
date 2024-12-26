import 'package:flutter/material.dart';
import './services/auth_service.dart';

class CreateAccountScreen extends StatefulWidget {
  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  bool isSignUp = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final AuthService _authService = AuthService();

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      if (isSignUp) {
        final message = await _authService.register(
          _firstNameController.text,
          _lastNameController.text,
          _emailController.text,
          _passwordController.text,
          _phoneController.text,
        );
        _showMessage(message);
      } else {
        final message = await _authService.login(
          _emailController.text,
          _passwordController.text,
        );
        _showMessage(message);
      }
    }
  }

  void _showMessage(String? message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Message'),
        content: Text(message ?? 'Une erreur est survenue'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (message == "Connexion réussie !" || message == "Inscription réussie !") {
                Navigator.pushReplacementNamed(context, '/ViewScreen');
              }
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
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
            Stack(
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/ambulance.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          onPressed: () => setState(() => isSignUp = true),
                          child: Text(
                            "Create Account",
                            style: TextStyle(
                              color: isSignUp ? Colors.red : Colors.grey,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => setState(() => isSignUp = false),
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: !isSignUp ? Colors.red : Colors.grey,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    isSignUp ? buildSignUpForm() : buildLoginForm(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSignUpForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: _firstNameController,
          decoration: InputDecoration(labelText: 'First Name'),
          validator: (value) => value == null || value.isEmpty ? 'Please enter your first name' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: _lastNameController,
          decoration: InputDecoration(labelText: 'Last Name'),
          validator: (value) => value == null || value.isEmpty ? 'Please enter your last name' : null,
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
          controller: _phoneController,
          decoration: InputDecoration(labelText: 'Phone Number'),
          validator: (value) => value == null || value.isEmpty ? 'Please enter your phone number' : null,
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
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _handleSubmit,
          child: Text('Sign Up'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: EdgeInsets.symmetric(vertical: 15),
            textStyle: TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }

  Widget buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(labelText: 'Email address'),
          validator: (value) => value == null || value.isEmpty ? 'Please enter your email' : null,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: _passwordController,
          decoration: InputDecoration(labelText: 'Password'),
          obscureText: true,
          validator: (value) => value == null || value.isEmpty ? 'Please enter your password' : null,
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _handleSubmit,
          child: Text('Login'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: EdgeInsets.symmetric(vertical: 15),
            textStyle: TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }
}