import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food/models.dart' as models;

class PlaceOrderPage extends StatefulWidget {
  final models.FoodItem foodItem;
  final int quantity;
  final double totalAmount;
  final List<String>? addons; // Allow null or empty addons

  PlaceOrderPage({
    required this.foodItem,
    required this.quantity,
    required this.totalAmount,
    this.addons, // Make it nullable
  });

  @override
  _PlaceOrderPageState createState() => _PlaceOrderPageState();
}

class _PlaceOrderPageState extends State<PlaceOrderPage> {
  @override
  void initState() {
    super.initState();
    _placeOrder(); // Automatically place the order when the page is loaded
  }

  // Function to store order in Firestore
  void _placeOrder() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Create order object
        final order = {
          'foodItem': widget.foodItem.name,
          'foodImage': widget.foodItem.image,
          'quantity': widget.quantity,
          'totalAmount': widget.totalAmount,
          'addons': widget.addons ?? [], // Store selected addons
          'userId': user.uid,
          'userEmail': user.email,
          'status': "Pending", // Default status
          'createdAt': FieldValue.serverTimestamp(),
        };

        // Add order to Firestore under 'add_to_cart' collection
        await FirebaseFirestore.instance.collection('orders').add(order);

        // Navigate back or to a different page (e.g., Home or Cart Page)
        Navigator.pop(context); // Close the current page
      } else {
        // Handle case where user is not logged in
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("You must be logged in to add to cart.")),
        );
      }
    } catch (e) {
      // Show error message with details
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add to cart. Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Return an empty container since we don't want to display anything
    return Scaffold(
      body: Container(),
    );
  }
}