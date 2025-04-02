import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food/models.dart';

class AddToCartPage extends StatelessWidget {
  final FoodItem foodItem;
  final int quantity;

  AddToCartPage({required this.foodItem, required this.quantity});

  Future<void> addToCart(FoodItem foodItem, int quantity, BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Reference to the user's cart collection
      CollectionReference cart = FirebaseFirestore.instance.collection('cart').doc(user.uid).collection('items');

      try {
        // Generate a unique ID for the item (to avoid duplicates)
        String uniqueId = "${foodItem.name}-${foodItem.restaurantName}";

        // Calculate the price based on the selected size and addons
        double totalPrice = foodItem.price ?? 0;
        if (foodItem.addons.contains("Pepsi")) {
          totalPrice += 2.5; // Example: Add extra charge for Pepsi
        }
        if (foodItem.addons.contains("Extra Meat")) {
          totalPrice += 3.0; // Example: Add extra charge for Extra Meat
        }

        // Include selected size (you can modify this depending on your UI)
        String selectedSize = foodItem.sizeOptions.isNotEmpty ? foodItem.sizeOptions.first : 'Regular';

        // Check if the item is already in the cart
        QuerySnapshot snapshot = await cart.where('uniqueId', isEqualTo: uniqueId).get();

        if (snapshot.docs.isEmpty) {
          // Add to cart if not already present
          await cart.add({
            'uniqueId': uniqueId,
            'uid': user.uid,
            'name': foodItem.name,
            'price': totalPrice,
            'image': foodItem.image,
            'restaurant': foodItem.restaurantName,
            'quantity': quantity,
            'addons': foodItem.addons, // Store the selected addons
            'size': selectedSize, // Store the selected size
            'addedAt': FieldValue.serverTimestamp(),
          });

          print('Food item added to cart: ${foodItem.name}');
        } else {
          print('Item already in the cart.');
        }

        // Immediately navigate back to the previous screen
        Navigator.pop(context); // Close the bottom sheet or the current page

      } catch (e) {
        print('Failed to add food item to cart: $e');
      }
    } else {
      print('User not logged in');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Call addToCart and then pop the page
    addToCart(foodItem, quantity, context);

    // Show a loading indicator while adding to the cart
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // Show loading indicator
      ),
    );
  }
}
