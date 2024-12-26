import 'dart:convert';
import 'package:http/http.dart' as http;

class LocationService {
  final String baseUrl = "http://10.0.2.2:8088/patients";

  Future<String?> updateLocation(String patientId, double latitude, double longitude) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$patientId/location'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "latitude": latitude,
        "longitude": longitude,
      }),
    );

    if (response.statusCode == 200) {
      return "Localisation mise à jour avec succès.";
    } else {
      return jsonDecode(response.body)['message'];
    }
  }
}
