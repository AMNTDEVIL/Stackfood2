import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'models.dart'; // Import your FoodItem model

class AddToFavPage extends StatelessWidget {
  final FoodItem foodItem;

  AddToFavPage({required this.foodItem});

  Future<void> addToFavorites(FoodItem foodItem, BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Generate a unique ID to prevent duplicates
        String uniqueId = "${foodItem.name}-${foodItem.restaurantName}";

        // Create a reference to the user's favorites subcollection
        DocumentReference userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
        CollectionReference favorites = userDoc.collection('favorites');

        // Check if the item already exists
        QuerySnapshot snapshot = await favorites.where('uniqueId', isEqualTo: uniqueId).get();

        print('Number of documents found: ${snapshot.docs.length}'); // Debug log

        if (snapshot.docs.isEmpty) {
          // Add to favorites if not already present
          await favorites.add({
            'uniqueId': uniqueId,
            'uid': user.uid,
            'name': foodItem.name,
            'price': foodItem.price,
            'image': foodItem.image,
            'restaurant': foodItem.restaurantName,
            'addedAt': FieldValue.serverTimestamp(),
          });

          print('Food item added to favorites: ${foodItem.name}');
        } else {
          print('Item already in favorites.');
        }

        // Navigate back after adding
        Navigator.pop(context);
      } catch (e) {
        print('Failed to add food item to favorites: $e');
      }
    } else {
      print('User not logged in');
    }
  }


  @override
  Widget build(BuildContext context) {
    // Call addToFavorites immediately when this page is shown
    Future.delayed(Duration.zero, () {
      addToFavorites(foodItem, context);
    });

    return Scaffold(
      body: Center(child: CircularProgressIndicator()), // Show loading while adding
    );
  }
}
