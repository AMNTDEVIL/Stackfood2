import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:food/add_new_address.dart'; // Make sure to import your AddAddressPage

class MyAddressPage extends StatefulWidget {
  @override
  _MyAddressPageState createState() => _MyAddressPageState();
}

class _MyAddressPageState extends State<MyAddressPage> {
  List<Map<String, String>> _addresses = []; // List to store addresses

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  // Function to load addresses from SharedPreferences
  _loadAddresses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve stored data
    String? name = prefs.getString('name');
    String? phone = prefs.getString('phone');
    String? streetNumber = prefs.getString('streetNumber');
    String? label = prefs.getString('label');
    double? latitude = prefs.getDouble('latitude');
    double? longitude = prefs.getDouble('longitude');

    // If address exists, add it to the list
    if (name != null && phone != null && streetNumber != null && label != null) {
      setState(() {
        _addresses.add({
          'name': name,
          'phone': phone,
          'streetNumber': streetNumber,
          'label': label,
          'latitude': latitude?.toString() ?? '',
          'longitude': longitude?.toString() ?? '',
        });
      });
    }
  }

  // Function to delete an address
  void _deleteAddress(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('name');
    prefs.remove('phone');
    prefs.remove('streetNumber');
    prefs.remove('label');
    prefs.remove('latitude');
    prefs.remove('longitude');

    setState(() {
      _addresses.removeAt(index); // Remove from list
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Address deleted!')),
    );
  }

  // Function to edit an address
  void _editAddress(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddAddressPage(), // Implement address editing in AddAddressPage
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
        title: Text('My Address', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Background Image (Replace with your image asset)
          Positioned.fill(
            child: Image.asset(
              'assets/city_background.png', // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: _addresses.isEmpty
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon for no address
                Image.asset(
                  'assets/no_address_icon.png', // Replace with your icon path
                  width: 80,
                  height: 80,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 10),
                Text(
                  'No Address Found',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Please add your address for your\nbetter experience',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddAddressPage()),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add),
                      SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AddAddressPage()),
                          );
                        },
                        child: Text(
                          'Add Address',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ],
            )
                : ListView.builder(
              itemCount: _addresses.length,
              itemBuilder: (context, index) {
                var address = _addresses[index];
                String label = address['label'] ?? '';
                String location = 'M8FC+CKH, Lalitpur 44600, Nepal'; // Mock location format

                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    leading: Icon(
                      label == "Home" ? Icons.home : Icons.location_on,
                      color: label == "Home" ? Colors.orange : Colors.blue,
                    ),
                    title: Text(
                      label == "Home" ? 'Home' : 'Other Address',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      location,
                      style: TextStyle(color: Colors.grey),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editAddress(index),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteAddress(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
