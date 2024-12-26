import 'dart:convert';
import 'package:http/http.dart' as http;

class DriverAuthService {
  final String baseUrl = "http://10.0.2.2:8088/drivers";

  Future<String?> register(String fullName, String phoneNumber, String email, String password, int ambulanceId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "fullName": fullName,
          "phoneNumber": phoneNumber,
          "email": email,
          "password": password,
          "ambulanceId": ambulanceId,
        }),
      );

      if (response.statusCode == 200) {
        return "Inscription réussie !";
      } else {
        final responseBody = jsonDecode(response.body);
        return responseBody['message'] ?? "Une erreur est survenue lors de l'inscription.";
      }
    } catch (e) {
      return "Erreur de connexion : ${e.toString()}";
    }
  }

  Future<String?> login(String email, String password) async {
    try {
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
        final responseBody = jsonDecode(response.body);
        return responseBody['message'] ?? "Une erreur est survenue lors de la connexion.";
      }
    } catch (e) {
      return "Erreur de connexion : ${e.toString()}";
    }
  }

  Future<List<Map<String, dynamic>>?> fetchAmbulances() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8088/ambulances/all'),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      print("Erreur de connexion : ${e.toString()}");
      return null;
    }
  }
}
