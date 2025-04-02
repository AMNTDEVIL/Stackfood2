import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:food/widgets/restaurant_list2.dart';

class NearbyLocationPage extends StatefulWidget {
  @override
  _NearbyLocationPageState createState() => _NearbyLocationPageState();
}

class _NearbyLocationPageState extends State<NearbyLocationPage> {
  LatLng? userLocation;
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    _loadUserLocation();
  }

  Future<void> _loadUserLocation() async {
    final prefs = await SharedPreferences.getInstance();
    double? lat = prefs.getDouble('latitude');
    double? lng = prefs.getDouble('longitude');

    if (lat != null && lng != null) {
      setState(() {
        userLocation = LatLng(lat, lng);
        markers.add(
          Marker(
            markerId: MarkerId('user_location'),
            position: userLocation!,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            infoWindow: InfoWindow(title: 'Your Location'),
          ),
        );

        // Add restaurant markers based on the restaurants list
        for (var restaurant in restaurants) {
          if (restaurant.latitude != null && restaurant.longitude != null) {
            markers.add(
              Marker(
                markerId: MarkerId(restaurant.name),
                position: LatLng(restaurant.latitude!, restaurant.longitude!),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                infoWindow: InfoWindow(title: restaurant.name),
              ),
            );
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Nearby Locations")),
      body: userLocation == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
        initialCameraPosition: CameraPosition(
          target: userLocation!,
          zoom: 15,
        ),
        markers: markers,
        myLocationEnabled: true,
        zoomControlsEnabled: false,
      ),
    );
  }
}
