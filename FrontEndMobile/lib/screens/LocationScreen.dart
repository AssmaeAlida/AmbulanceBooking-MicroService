import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  late GoogleMapController mapController;

  LatLng? _currentPosition;
  bool _isLoading = true;
  Marker? _currentLocationMarker;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  /// Méthode pour récupérer la localisation actuelle
  Future<void> _getLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Vérifier si les services de localisation sont activés
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Les services de localisation sont désactivés.');
      }

      // Vérifier les permissions
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Les permissions de localisation sont refusées.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
            'Les permissions de localisation sont refusées de façon permanente.');
      }

      // Obtenir la position actuelle
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      LatLng location = LatLng(position.latitude, position.longitude);

      print('Position actuelle: $location');

      setState(() {
        _currentPosition = location;
        _isLoading = false;
        _currentLocationMarker = Marker(
          markerId: MarkerId('current_location'),
          position: location,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: InfoWindow(title: 'Votre position actuelle'),
        );
      });

      // Mettre à jour la localisation sur le serveur
      try {
        await _updateLocationOnServer(255, location); // Remplacez `255` par l'ID réel du patient
      } catch (e) {
        print("Erreur lors de la mise à jour sur le serveur : $e");
      }
    } catch (e) {
      print("Erreur lors de la récupération de la position : $e");
      setState(() {
        _isLoading = false; // Sortir de l'état de chargement même en cas d'erreur
      });
    }
  }

  /// Méthode pour mettre à jour la localisation sur le serveur
  Future<void> _updateLocationOnServer(int patientId, LatLng location) async {
    final uri = Uri.parse(
        'http://10.0.2.2:8083/patients/$patientId/location?latitude=${location.latitude}&longitude=${location.longitude}'); // Utilisation des paramètres dans l'URL

    print("Début de la mise à jour de la localisation...");
    print("URI construit : $uri");

    final response = await http.put(uri);  // Aucune nécessité de corps de requête, tout est dans l'URL

    if (response.statusCode == 200) {
      print("Localisation mise à jour avec succès : ${response.body}");
    } else {
      throw Exception("Erreur lors de la mise à jour : ${response.statusCode}");
    }
  }



  /// Méthode appelée lors de la création de la carte
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }


  /// Méthode pour récupérer les conducteurs proches
/// Méthode pour récupérer les conducteurs proches
Future<List<Marker>> _getNearbyDrivers() async {
  final uri = Uri.parse(
      'http://10.0.2.2:8088/drivers/nearby?latitude=${_currentPosition!.latitude}&longitude=${_currentPosition!.longitude}&radius=10');

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final List<dynamic> drivers = json.decode(response.body);
    return drivers.map((driver) {
      return Marker(
        markerId: MarkerId(driver['id'].toString()),
        position: LatLng(driver['latitude'], driver['longitude']),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(title: driver['name']),
        onTap: () {
          _showReservationDialog(context, driver);
        },
      );
    }).toList();
  } else {
    throw Exception("Erreur lors de la récupération des conducteurs.");
  }
}

void _showReservationDialog(BuildContext context, dynamic driver) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Réserver une ambulance'),
        content: Text('Voulez-vous réserver le conducteur ${driver['id']}?'),
        actions: <Widget>[
          TextButton(
            child: Text('Annuler'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Réserver'),
            onPressed: () {
              _sendReservation(driver['id']);
              Navigator.of(context).pop();
              _showConfirmationSnackBar();
            },
          ),
        ],
      );
    },
  );
}

void _showConfirmationSnackBar() {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Demande de réservation envoyée!'),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 2),
    ),
  );
}

// ...existing code...

void _sendReservation(int driverId) async {
  try {
    final uri = Uri.parse('http://10.0.2.2:8088/reservations/create');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'patientId': 255,
        'ambulanceId': driverId, // Changed from driverId to ambulanceId
        'status': 'PENDING'
      }),
    );

    if (response.statusCode == 200) {
      print("Réservation envoyée avec succès !");
      _showConfirmationSnackBar();
    } else {
      throw Exception("Erreur lors de la réservation : ${response.statusCode}");
    }
  } catch (e) {
    print("Erreur d'envoi de réservation: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Erreur lors de l\'envoi de la réservation'),
        backgroundColor: Colors.red,
      ),
    );
  }
}



//////////////
 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Localisation actuelle'),
      backgroundColor: Colors.red,
    ),
    body: _isLoading
        ? Center(child: CircularProgressIndicator())
        : FutureBuilder<List<Marker>>(
            future: _getNearbyDrivers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Erreur : ${snapshot.error}'));
              } else {
                return GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _currentPosition!,
                    zoom: 16.0,
                  ),
                  markers: {
                    if (_currentLocationMarker != null)
                      _currentLocationMarker!,
                    ...snapshot.data!,
                  },
                );
              }
            },
          ),
  );
}

}
