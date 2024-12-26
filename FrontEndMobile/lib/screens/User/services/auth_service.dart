import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // URL de la Gateway
  final String baseUrl = "http://10.0.2.2:8088/api/auth";

  // Méthode pour l'inscription
  Future<String?> register(String firstName, String lastName, String email, String password, String phoneNumber) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "password": password,
        "phoneNumber": phoneNumber,
      }),
    );

    if (response.statusCode == 200) {
      return "Inscription réussie !";
    } else {
      return jsonDecode(response.body)['message'];
    }
  }

  // Méthode pour la connexion
  Future<String?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      return "Connexion réussie !";
    } else {
      return jsonDecode(response.body)['message'];
    }
  }
}
