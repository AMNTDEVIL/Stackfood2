import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CheckoutPage extends StatefulWidget {
  final String foodName;
  final double price;

  CheckoutPage({
    required this.foodName,
    required this.price,
  });

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  double _tipAmount = 0.0;
  String _selectedTip = "Not now";
  String _deliveryOption = "Home Delivery";
  double _totalAmount = 631.00;
  String _deliveryAddress = "Q982+86P, Dhaka, Bangladesh";
  bool _contactAdded = false;
  bool _showOrderSummary = false;

  TextEditingController _contactController = TextEditingController();

  void _placeOrder() async {
    double finalAmount = _totalAmount;
    if (_selectedTip != "Not now") {
      finalAmount += double.tryParse(_selectedTip.substring(1)) ?? 0.0; // Add the tip to the total amount
    }

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final order = {
        'userId': user.uid,
        'userEmail': user.email,
        'foodName': widget.foodName,  // Added foodName to the order
        'deliveryOption': _deliveryOption,
        'deliveryAddress': _deliveryAddress,
        'totalAmount': finalAmount,
        'tip': _selectedTip ?? "No Tip",
        'status': "Pending",
        'createdAt': FieldValue.serverTimestamp(),
      };

      // Save the order to Firestore under 'checkout_order' collection
      await FirebaseFirestore.instance.collection('checkout_order').add(order);

      // Show success message after order is placed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Order placed successfully!")),
      );
    }
  }

  void _updateTotalAmount() {
    double tipAmount = 0.0;
    if (_selectedTip == "Not now") {
      tipAmount = 0.0;
    } else if (_selectedTip == "\$2") {
      tipAmount = 2.0;
    } else if (_selectedTip == "\$5") {
      tipAmount = 5.0;
    } else if (_selectedTip == "\$10") {
      tipAmount = 10.0;
    }
    setState(() {
      _tipAmount = tipAmount;
      _totalAmount = widget.price + _tipAmount;
    });
  }

  Future<String> _getPlusCode(double latitude, double longitude) async {
    final url = Uri.parse('https://plus.codes/api?address=$latitude,$longitude'); // Plus Codes API URL
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse['plus_code']['global_code'] ?? "No Plus Code available";
      } else {
        return "No Plus Code available";
      }
    } catch (e) {
      return "Error fetching Plus Code";
    }
  }

  Future<String> _loadSavedLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double? latitude = prefs.getDouble('latitude');
    double? longitude = prefs.getDouble('longitude');
    String? locationInfo = prefs.getString('location_info');

    if (latitude != null && longitude != null && locationInfo != null) {
      String plusCode = await _getPlusCode(latitude, longitude);
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      String? address = placemarks.isNotEmpty
          ? "${placemarks[0].locality}, ${placemarks[0].country}"
          : "Address not found";

      return "$plusCode, $address";
    } else {
      return 'Choose Your Location'; // Default text if no location is saved
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Checkout")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUnlockFeaturesSection(),
              _buildContainer(_buildDeliveryOptions()),
              _buildContainer(_buildAddressSection()),
              _buildContainer(_buildTipSection()),
              _buildContainer(_buildPaymentMethod()),
              _buildContainer(_buildAdditionalNote()),
              _buildOrderSummary(),
              _buildPlaceOrderButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUnlockFeaturesSection() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Wants to Unlock More Features?"),
              Text("Click to Unlock", style: TextStyle(color: Colors.blue)),
            ],
          ),
          Icon(Icons.info_outline),
        ],
      ),
    );
  }

  Widget _buildContainer(Widget child) {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }

  Widget _buildDeliveryOptions() {
    return Column(
      children: [
        Text("Delivery Option", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Row(
          children: [
            _buildDeliveryOption("Home Delivery"),
            SizedBox(width: 10),
            _buildDeliveryOption("Take Away"),
          ],
        ),
      ],
    );
  }

  Widget _buildDeliveryOption(String option) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _deliveryOption = option),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.orange),
            borderRadius: BorderRadius.circular(10),
            color: _deliveryOption == option ? Colors.orange.withOpacity(0.2) : Colors.white,
          ),
          child: Center(child: Text(option)),
        ),
      ),
    );
  }

  Widget _buildGoogleMap() {
    return FutureBuilder<String>(
      future: _loadSavedLocation(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          String locationData = snapshot.data!;
          List<String> coordinates = locationData.split(',');

          if (coordinates.length == 2) {
            double latitude = double.parse(coordinates[0]);
            double longitude = double.parse(coordinates[1]);

            return Container(
              height: 150,
              width: double.infinity,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(latitude, longitude),
                  zoom: 14,
                ),
                markers: {
                  Marker(
                    markerId: MarkerId('selected_location'),
                    position: LatLng(latitude, longitude),
                  ),
                },
              ),
            );
          } else {
            return Container(
              padding: EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('Invalid location data', style: TextStyle(color: Colors.red)),
            );
          }
        } else {
          return Container(
            padding: EdgeInsets.all(12),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('No location data available', style: TextStyle(color: Colors.red)),
          );
        }
      },
    );
  }

  Widget _buildAddressSection() {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.only(top: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Deliver To", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          _contactAdded
              ? Container(
            padding: EdgeInsets.all(12),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(_deliveryAddress),
          )
              : Column(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text("No Contact Information Added", style: TextStyle(color: Colors.red)),
              ),
              SizedBox(height: 12),
              _buildGoogleMap(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTipSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              Icon(Icons.info_outline),
              SizedBox(width: 5),
              Text("Delivery Man Tips")
            ]),
            Row(children: [
              Checkbox(value: false, onChanged: (val) {}),
              Text("Save for later")
            ]),
          ],
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          _buildTipButton("Not now"),
          _buildTipButton("\$2"),
          _buildTipButton("\$5"),
          _buildTipButton("\$10")
        ]),
      ],
    );
  }

  Widget _buildTipButton(String tip) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTip = tip;
          _updateTotalAmount();
        });
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: _selectedTip == tip ? Colors.orange : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.orange),
        ),
        child: Text(tip),
      ),
    );
  }

  Widget _buildPaymentMethod() {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.payment),
          Text("Payment Method"),
          Icon(Icons.arrow_forward_ios, size: 18),
        ],
      ),
    );
  }

  Widget _buildAdditionalNote() {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        maxLines: 3,
        decoration: InputDecoration(
          hintText: "Any Additional Notes?",
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Total Amount", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("\$${(_totalAmount + _tipAmount).toStringAsFixed(2)}", style: TextStyle(fontSize: 18)),
          ],
        ),
        SizedBox(height: 10),
        ExpansionTile(
          title: Text("Show Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Delivery", style: TextStyle(fontSize: 16)),
                Text("Free", style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Tip", style: TextStyle(fontSize: 16)),
                Text("\$${_tipAmount.toStringAsFixed(2)}", style: TextStyle(fontSize: 16)),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlaceOrderButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _placeOrder,
        child: Text("Place Order"),
      ),
    );
  }
}
