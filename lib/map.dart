import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController _mapController;
  LatLng _currentLocation = LatLng(27.7172, 85.3240); // Default location (Kathmandu, Nepal)
  Set<Marker> _markers = {};
  TextEditingController _searchController = TextEditingController();
  String _locationInfo = "Search Location";

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadSavedLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled.')),
      );
      return;
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied.')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Location permissions are permanently denied. Please enable them in settings.'),
        ),
      );
      return;
    }

    // Get current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
      _locationInfo = "Lat: ${_currentLocation.latitude}, Long: ${_currentLocation.longitude}";

      // Clear old markers before adding the new current location marker
      _markers.clear();

      _markers.add(
        Marker(
          markerId: MarkerId('current_location'),
          position: _currentLocation,
          infoWindow: InfoWindow(title: 'Current Location'),
        ),
      );
    });
    _mapController.moveCamera(CameraUpdate.newLatLngZoom(_currentLocation, 14));
  }

  Future<void> _updateLocationInfo(LatLng location) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      location.latitude,
      location.longitude,
    );

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];

      // Get Plus Code using the geocoding API
      String plusCode = await _getPlusCode(location);

      setState(() {
        _locationInfo = "$plusCode, ${place.locality}, ${place.country}";
        _searchController.text = _locationInfo; // Update the search field text
      });
    }
  }

  Future<String> _getPlusCode(LatLng location) async {
    final url = Uri.parse(
        'https://plus.codes/api?address=${location.latitude},${location.longitude}');

    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        // Extract Plus Code from the response (assuming JSON response)
        final jsonResponse = json.decode(response.body);
        return jsonResponse['plus_code']['global_code'] ?? "No Plus Code available";
      } else {
        return "No Plus Code available";
      }
    } catch (e) {
      return "Error fetching Plus Code";
    }
  }

  // Save the selected location to SharedPreferences
  Future<void> _saveLocationToCache(LatLng location, String locationInfo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('latitude', location.latitude);
    prefs.setDouble('longitude', location.longitude);
    prefs.setString('location_info', locationInfo);
  }

  // Load the saved location from SharedPreferences
  Future<void> _loadSavedLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double? latitude = prefs.getDouble('latitude');
    double? longitude = prefs.getDouble('longitude');
    String? locationInfo = prefs.getString('location_info');

    if (latitude != null && longitude != null && locationInfo != null) {
      setState(() {
        _currentLocation = LatLng(latitude, longitude);
        _locationInfo = locationInfo;

        // Ensure the markers are not duplicated
        _markers.clear();
        _markers.add(
          Marker(
            markerId: MarkerId('saved_location'),
            position: _currentLocation,
            infoWindow: InfoWindow(title: 'Saved Location'),
          ),
        );
      });
      _mapController.moveCamera(CameraUpdate.newLatLngZoom(_currentLocation, 14));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            initialCameraPosition: CameraPosition(
              target: _currentLocation,
              zoom: 14,
            ),
            markers: _markers,
            onTap: (LatLng point) {
              setState(() {
                _markers.clear();
                _markers.add(
                  Marker(
                    markerId: MarkerId('selected_location'),
                    position: point,
                    infoWindow: InfoWindow(title: 'Selected Location'),
                  ),
                );
              });
              _updateLocationInfo(point);
            },
          ),
          // Search Bar
          Positioned(
            top: MediaQuery.of(context).size.height * 0.06,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search Location",
                  prefixIcon: Icon(Icons.location_on),
                  suffixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                ),
                readOnly: true, // Make it read-only since we're updating it programmatically
              ),
            ),
          ),
          // GPS Icon Button
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.12,
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.my_location),
              onPressed: () async {
                await _getCurrentLocation();
              },
              color: Colors.orange,
              iconSize: 30,
            ),
          ),
          // Pick Location Button
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.02,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: () {
                // Save selected location to cache
                _saveLocationToCache(_currentLocation, _locationInfo);

                // Pass the selected location back to the previous page (HomePage)
                Navigator.pop(context, _currentLocation);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Location Info: ${_locationInfo}'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                minimumSize: const Size(double.infinity, 60), // Makes the button long
              ),
              child: const Text(
                "Pick Location",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Location>> geocode(String query) async {
    try {
      return await locationFromAddress(query);
    } catch (e) {
      print(e);
      return [];
    }
  }
}
