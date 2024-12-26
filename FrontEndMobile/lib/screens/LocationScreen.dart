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
        await _updateLocationOnServer(256, location); // Remplacez `255` par l'ID réel du patient
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Localisation actuelle'),
        backgroundColor: Colors.red,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _currentPosition!, // Position initiale sur la carte
                zoom: 16.0,
              ),
              markers: _currentLocationMarker != null
                  ? {_currentLocationMarker!}
                  : {},
              onTap: (LatLng location) {
                // Met à jour la localisation sur la carte lors du tap
                setState(() {
                  _currentPosition = location;
                  _currentLocationMarker = Marker(
                    markerId: MarkerId('tapped_location'),
                    position: location,
                    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                    infoWindow: InfoWindow(title: 'Nouvelle position'),
                  );
                });
                // Mettre à jour la localisation sur le serveur après le tap
                _updateLocationOnServer(255, location); // Remplacez `255` par l'ID du patient
              },
            ),
    );
  }
}
