import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddAddressPage extends StatefulWidget {
  @override
  _AddAddressPageState createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  late GoogleMapController mapController;
  LatLng _center = const LatLng(37.42796133580664, -122.085749655962); // Example coordinates (Google HQ)
  Set<Marker> _markers = {};
  String selectedLabel = "Home"; // Default label

  // Text Controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController streetNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _markers.add(
      Marker(
        markerId: MarkerId('address_marker'),
        position: _center,
        infoWindow: InfoWindow(title: 'Your Address'),
      ),
    );
  }

  // Function to handle map creation
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  // Function to save data in SharedPreferences
  void saveLocationData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Storing data
    prefs.setString('name', nameController.text);
    prefs.setString('phone', phoneController.text);
    prefs.setString('streetNumber', streetNumberController.text);
    prefs.setString('label', selectedLabel);  // Save the selected label

    // Optionally, you can also store the coordinates or any other relevant data
    prefs.setDouble('latitude', _center.latitude);
    prefs.setDouble('longitude', _center.longitude);

    // Show a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Location Saved!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Address'),
        backgroundColor: Colors.orange,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Google Map with Marker
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                height: 200,
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: 14.0,
                  ),
                  markers: _markers,
                ),
              ),
            ),
            SizedBox(height: 16),

            // Label As (Icons for Home, Briefcase, App)
            Text(
              'Label As',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.home, size: 40, color: selectedLabel == "Home" ? Colors.orange : Colors.grey),
                  onPressed: () {
                    setState(() {
                      selectedLabel = "Home";
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.work, size: 40, color: selectedLabel == "Work" ? Colors.orange : Colors.grey),
                  onPressed: () {
                    setState(() {
                      selectedLabel = "Work";
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.app_registration, size: 40, color: selectedLabel == "App" ? Colors.orange : Colors.grey),
                  onPressed: () {
                    setState(() {
                      selectedLabel = "App";
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16),

            // Name
            Text(
              'Name *',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Abc',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Phone
            Text(
              'Phone *',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                hintText: '+977 | 9841414141',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Street Number
            Text(
              'Street Number',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: streetNumberController,
              decoration: InputDecoration(
                hintText: 'Enter Street Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Save Location Button
            Center(
              child: ElevatedButton(
                onPressed: saveLocationData,  // Save data when clicked
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Save Location',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
