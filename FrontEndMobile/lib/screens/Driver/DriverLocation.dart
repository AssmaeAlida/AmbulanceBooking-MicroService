import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class DriverLocationScreen extends StatefulWidget {
  @override
  _DriverLocationScreenState createState() => _DriverLocationScreenState();
}

class _DriverLocationScreenState extends State<DriverLocationScreen> {
  late GoogleMapController mapController;

  LatLng? _currentPosition;
  bool _isLoading = true;
  Marker? _driverLocationMarker;

  @override
  void initState() {
    super.initState();
    _getDriverLocation();
  }

  Future<void> _getDriverLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Vérifier si les services de localisation sont activés
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Les services de localisation sont désactivés.');
    }

    // Vérifier les permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Les permissions de localisation sont refusées.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Les permissions de localisation sont refusées de façon permanente.');
    }

    // Obtenir la position actuelle du conducteur
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    LatLng location = LatLng(position.latitude, position.longitude);

    print('Position actuelle du conducteur: $location');
    
    setState(() {
      _currentPosition = location;
      _isLoading = false;
      _driverLocationMarker = Marker(
        markerId: MarkerId('driver_location'),
        position: location,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(title: 'Position du conducteur'),
      );
    });

    // Mettre à jour la localisation du conducteur sur le serveur
    try {
      await _updateDriverLocationOnServer(105, location); // Remplacer `103` par l'ID réel du conducteur
    } catch (e) {
      print("Erreur lors de la mise à jour sur le serveur : $e");
    }
  }

  /// Méthode pour mettre à jour la localisation du conducteur sur le serveur
  Future<void> _updateDriverLocationOnServer(int driverId, LatLng location) async {
    final uri = Uri.parse(
        'http://10.0.2.2:8088/drivers/$driverId/location?latitude=${location.latitude}&longitude=${location.longitude}');
    
    print("Début de la mise à jour de la localisation du conducteur...");
    print("URI construit : $uri");

    final response = await http.put(
      uri,
    );

    if (response.statusCode == 200) {
      print("Localisation du conducteur mise à jour avec succès : ${response.body}");
    } else {
      throw Exception("Erreur lors de la mise à jour : ${response.statusCode}");
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Position du conducteur'),
        backgroundColor: Colors.green,
      ),
      body: _isLoading
          ? Center(child: const CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _currentPosition!,
                zoom: 16.0,
              ),
              markers: _driverLocationMarker != null
                  ? {_driverLocationMarker!}
                  : {},
            ),
    );
  }
}
