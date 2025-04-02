import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:geocoding/geocoding.dart';
import 'package:file_picker/file_picker.dart';

class RestaurantRegistrationPage extends StatefulWidget {
  @override
  _RestaurantRegistrationPageState createState() =>
      _RestaurantRegistrationPageState();
}

class _RestaurantRegistrationPageState
    extends State<RestaurantRegistrationPage> {
  int selectedTabIndex = 0;
  TextEditingController restaurantNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController vatTaxController = TextEditingController();
  File? restaurantLogo;
  File? restaurantCover;
  String selectedZone = 'All over the World';
  String selectedCuisine = '';
  String selectedTime = '-- : -- minute';
  LatLng restaurantLocation = LatLng(27.7172, 85.3240); // Default location (Kathmandu)

  final List<String> languages = [
    "English",
    "Bengali - বাংলা",
    "Arabic - العربية",
    "Spanish - español"
  ];
  final List<String> zones = ["All over the World"];
  final List<String> cuisines = ["Italian", "Chinese", "Indian", "Mexican", "Thai"];

  void _pickImage(bool isLogo) async {
    // Open the file picker dialog
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      setState(() {
        if (isLogo) {
          restaurantLogo = File(result.files.single.path!); // Set the logo file
        } else {
          restaurantCover = File(result.files.single.path!); // Set the cover file
        }
      });
    }
  }

  void _selectTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        selectedTime = '${picked.hour}:${picked.minute} minute';
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {}

  void _onMapTapped(LatLng position) async {
    setState(() {
      restaurantLocation = position;
    });

    // Get address from latitude and longitude using reverse geocoding
    List<Placemark> placemarks = await placemarkFromCoordinates(
      restaurantLocation.latitude,
      restaurantLocation.longitude,
    );
    if (placemarks.isNotEmpty) {
      setState(() {
        addressController.text = '${placemarks[0].name}, ${placemarks[0].locality}, ${placemarks[0].country}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Restaurant Registration"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Provide restaurant information to proceed next",
                style: TextStyle(color: Colors.grey)),

            // Language Selection Tabs
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(languages.length, (index) {
                  return GestureDetector(
                    onTap: () => setState(() => selectedTabIndex = index),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                      child: Text(
                        languages[index],
                        style: TextStyle(
                          fontWeight: selectedTabIndex == index
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: selectedTabIndex == index
                              ? Colors.orange
                              : Colors.black54,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            Text("Restaurant Info", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Restaurant Name Input
                  TextField(
                    controller: restaurantNameController,
                    decoration: InputDecoration(
                      labelText: "Restaurant Name (${languages[selectedTabIndex]}) *",
                      prefixIcon: Icon(Icons.restaurant),
                    ),
                  ),
                  SizedBox(height: 15),

                  // Restaurant Logo & Cover Upload
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildUploadBox("Upload Restaurant Logo", restaurantLogo, true),
                      _buildUploadBox("Upload Restaurant Cover", restaurantCover, false),
                    ],
                  ),
                  SizedBox(height: 15),
                ],
              ),
            ),
            Text("Location Info", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            // Google Map
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Zone Selection Dropdown
                  DropdownButtonFormField<String>(
                    value: selectedZone,
                    decoration: InputDecoration(labelText: "Select Zone"),
                    items: zones.map((String zone) {
                      return DropdownMenuItem(value: zone, child: Text(zone));
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedZone = newValue!;
                      });
                    },
                  ),
                  SizedBox(height: 15),
                  // Google Map
                  Container(
                    height: 200,
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                    child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(target: restaurantLocation, zoom: 15),
                      markers: {
                        Marker(
                          markerId: MarkerId('restaurant'),
                          position: restaurantLocation,
                        ),
                      },
                      onTap: _onMapTapped,
                    ),
                  ),
                  SizedBox(height: 20),

                  // Address Input (readonly)
                  TextField(
                    controller: addressController,
                    decoration: InputDecoration(labelText: "Restaurant Address *"),
                    readOnly: true, // Make the address non-writable
                  ),
                  SizedBox(height: 15),
                ],
              ),
            ),
            Text("Restaurant Preferences", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cuisine Selection Dropdown
                  DropdownButtonFormField<String>(
                    value: selectedCuisine.isNotEmpty ? selectedCuisine : null,
                    decoration: InputDecoration(labelText: "Cuisines"),
                    items: cuisines.map((String cuisine) {
                      return DropdownMenuItem(value: cuisine, child: Text(cuisine));
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCuisine = newValue!;
                      });
                    },
                  ),
                  SizedBox(height: 15),

                  // Vat/Tax Input
                  TextField(
                    controller: vatTaxController,
                    decoration: InputDecoration(
                        labelText: "Vat/Tax *", prefixIcon: Icon(Icons.monetization_on)),
                  ),
                  SizedBox(height: 15),

                  // Time Selection
                  GestureDetector(
                    onTap: _selectTime,
                    child: AbsorbPointer(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: "Select Time",
                          hintText: selectedTime,
                          suffixIcon: Icon(Icons.access_time),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                ],
              ),
            ),

            // Next Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                onPressed: () {},
                child: Text("Next", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadBox(String title, File? imageFile, bool isLogo) {
    return GestureDetector(
      onTap: () => _pickImage(isLogo),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.42,
        height: 120,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.orange),
          borderRadius: BorderRadius.circular(10),
        ),
        child: imageFile != null
            ? Image.file(imageFile!, fit: BoxFit.cover)
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt, color: Colors.grey),
            SizedBox(height: 5),
            Text(title, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
