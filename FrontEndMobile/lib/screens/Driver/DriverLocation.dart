import 'dart:async';
import 'dart:convert';
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
  Marker? _patientLocationMarker;
  Set<Polyline> _polylines = {};
  Timer? _reservationTimer;

  @override
  void initState() {
    super.initState();
    _getDriverLocation();
    _listenForReservations();
  }

  @override
  void dispose() {
    _reservationTimer?.cancel();
    super.dispose();
  }

  Future<void> _getDriverLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Services de localisation désactivés');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Permissions de localisation refusées');
        }
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      LatLng location = LatLng(position.latitude, position.longitude);

      setState(() {
        _currentPosition = location;
        _isLoading = false;
        _driverLocationMarker = Marker(
          markerId: MarkerId('driver_location'),
          position: location,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: InfoWindow(title: 'Ma position'),
        );
      });

      await _updateDriverLocationOnServer(105, location);
    } catch (e) {
      print("Erreur de localisation: $e");
      setState(() => _isLoading = false);
    }
  }


  void _listenForReservations() {
    _reservationTimer?.cancel(); // Cancel existing timer if any
    _reservationTimer = Timer.periodic(Duration(seconds: 3), (timer) async {
      if (!mounted) return; // Check if widget is still mounted

      try {
        final uri = Uri.parse('http://10.0.2.2:8088/reservations/driver/105/pending');
        final response = await http.get(uri);

        if (response.statusCode == 200) {
          final List<dynamic> reservations = json.decode(response.body);
          if (reservations.isNotEmpty) {
            final reservation = reservations[0];
            _showReservationDialog({
              'reservationId': reservation['id'],
              'latitude': reservation['patientLatitude'],
              'longitude': reservation['patientLongitude'],
            });
          }
        } else {
          print('Error: ${response.statusCode}');
          print('Response: ${response.body}');
        }
      } catch (e) {
        print('Exception in _listenForReservations: $e');
      }
    });
  }

  void _showReservationDialog(Map<String, dynamic> reservation) {
    if (!mounted) return;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Nouvelle réservation'),
          content: Text('Un patient demande une ambulance.\nVoulez-vous accepter?'),
          actions: [
            TextButton(
              child: Text('Refuser'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Accepter'),
              onPressed: () {
                Navigator.of(context).pop();
                _acceptReservation(
                  reservation['reservationId'],
                  LatLng(
                    reservation['latitude'],
                    reservation['longitude'],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }


  Future<void> _acceptReservation(int reservationId, LatLng patientLocation) async {
    try {
      final uri = Uri.parse('http://10.0.2.2:8088/reservations/$reservationId/accept');
      final response = await http.put(uri);

      if (response.statusCode == 200) {
        setState(() {
          _patientLocationMarker = Marker(
            markerId: MarkerId('patient_location'),
            position: patientLocation,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            infoWindow: InfoWindow(title: 'Patient'),
          );
        });

        await _drawRouteToPatient(patientLocation);
      }
    } catch (e) {
      print("Erreur d'acceptation: $e");
    }
  }

  Future<void> _drawRouteToPatient(LatLng patientLocation) async {
    if (_currentPosition != null) {
      try {
        List<LatLng> routePoints = await _getRoute(_currentPosition!, patientLocation);
        setState(() {
          _polylines.add(
            Polyline(
              polylineId: PolylineId('route'),
              points: routePoints,
              color: Colors.blue,
              width: 5,
            ),
          );
        });

        LatLngBounds bounds = _getBounds([_currentPosition!, patientLocation]);
        mapController.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, 50),
        );
      } catch (e) {
        print("Erreur de tracé d'itinéraire: $e");
      }
    }
  }

  Future<List<LatLng>> _getRoute(LatLng start, LatLng end) async {
    final uri = Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}&key=YOUR_API_KEY');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final points = data['routes'][0]['overview_polyline']['points'];
      return _decodePolyline(points);
    } else {
      throw Exception("Erreur de récupération d'itinéraire");
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  LatLngBounds _getBounds(List<LatLng> points) {
    double minLat = points[0].latitude;
    double maxLat = points[0].latitude;
    double minLng = points[0].longitude;
    double maxLng = points[0].longitude;

    for (LatLng point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  Future<void> _updateDriverLocationOnServer(int driverId, LatLng location) async {
    final uri = Uri.parse(
        'http://10.0.2.2:8088/drivers/$driverId/location?latitude=${location.latitude}&longitude=${location.longitude}');
    
    try {
      final response = await http.put(uri);
      if (response.statusCode != 200) {
        throw Exception("Erreur de mise à jour: ${response.statusCode}");
      }
    } catch (e) {
      print("Erreur de mise à jour sur le serveur: $e");
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
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _currentPosition ?? LatLng(0, 0),
                zoom: 16.0,
              ),
              markers: {
                if (_driverLocationMarker != null) _driverLocationMarker!,
                if (_patientLocationMarker != null) _patientLocationMarker!,
              },
              polylines: _polylines,
            ),
    );
  }
}