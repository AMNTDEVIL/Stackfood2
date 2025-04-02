import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'map.dart'; // Import the map screen
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SetLocationScreen extends StatelessWidget {
  const SetLocationScreen({Key? key}) : super(key: key);

  // Method to fetch and store the current location
  Future<void> _useCurrentLocation(BuildContext context) async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled.')),
      );
      return;
    }

    // Check for location permissions
    LocationPermission permission = await Geolocator.checkPermission();
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

    // Fetch the current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Convert coordinates to a readable address
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    String address = placemarks.isNotEmpty
        ? "${placemarks[0].street}, ${placemarks[0].locality}, ${placemarks[0].country}"
        : "Unknown Location";

    // Get Plus Code (optional, similar to MapPage)
    String plusCode = await _getPlusCode(LatLng(position.latitude, position.longitude));

    // Combine address and Plus Code for location info
    String locationInfo = "$address ($plusCode)";

    // Save the location to SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('latitude', position.latitude);
    prefs.setDouble('longitude', position.longitude);
    prefs.setString('location_info', locationInfo);

    // Show a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Location saved: $locationInfo')),
    );

    // Navigate back to the previous screen with the location data
    Navigator.pop(context, LatLng(position.latitude, position.longitude));
  }

  // Method to fetch Plus Code
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Navigate back when the back icon is pressed
          },
        ),
        title: const Text(
          'Set Location',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            // Illustration
            Image.asset(
              'assets/location_image.png', // Replace with your asset image
              height: 200,
            ),
            const Spacer(),
            // Title
            const Text(
              'FIND RESTAURANTS AND FOODS NEAR YOU',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // Subtitle
            const Text(
              'By allowing location access, you can search for restaurants and foods near you and receive more accurate delivery.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const Spacer(),
            // "Use Current Location" Button
            ElevatedButton.icon(
              onPressed: () async {
                await _useCurrentLocation(context); // Fetch and store current location
              },
              icon: const Icon(Icons.location_searching, color: Colors.white),
              label: const Text('Use Current Location'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // "Set From Map" Button
            OutlinedButton.icon(
              onPressed: () {
                // Navigate to the Map screen when pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapPage()),
                );
              },
              icon: const Icon(Icons.map, color: Colors.orange),
              label: const Text('Set From Map'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                side: const BorderSide(color: Colors.orange),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}