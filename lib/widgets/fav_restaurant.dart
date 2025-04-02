// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:food/models.dart';
//
// class FavoriteRestaurantPage extends StatefulWidget {
//   final String name;
//   final String image;
//   final String distance;
//   final List<FoodItem> foodItems;
//   final double rating;
//
//   const FavoriteRestaurantPage({
//     Key? key,
//     required this.name,
//     required this.image,
//     required this.distance,
//     required this.foodItems,
//     required this.rating, // Pass food items here
//   }) : super(key: key);
//
//   @override
//   _FavoriteRestaurantPageState createState() => _FavoriteRestaurantPageState();
// }
//
// class _FavoriteRestaurantPageState extends State<FavoriteRestaurantPage> {
//   final user = FirebaseAuth.instance.currentUser;
//   bool isFavorite = false;
//   String? favoriteDocId; // Stores the document ID for removal
//
//   @override
//   void initState() {
//     super.initState();
//     _checkIfFavorite();
//   }
//
//   /// **Check if the restaurant exists in favorites**
//   Future<void> _checkIfFavorite() async {
//     if (user == null) return;
//
//     final favoritesRef = FirebaseFirestore.instance
//         .collection('users')
//         .doc(user!.uid)
//         .collection('favorites_restaurants');
//
//     final querySnapshot =
//     await favoritesRef.where('image', isEqualTo: widget.image).get();
//
//     if (querySnapshot.docs.isNotEmpty) {
//       setState(() {
//         isFavorite = true;
//         favoriteDocId = querySnapshot.docs.first.id;
//       });
//     }
//   }
//
//   /// **Add or Remove from favorites (No UI, just logic)**
//   Future<void> _toggleFavorite() async {
//     if (user == null) return;
//
//     final favoritesRef = FirebaseFirestore.instance
//         .collection('users')
//         .doc(user!.uid)
//         .collection('favorites_restaurants');
//
//     if (isFavorite) {
//       // **Remove from favorites**
//       if (favoriteDocId != null) {
//         await favoritesRef.doc(favoriteDocId).delete();
//         setState(() {
//           isFavorite = false;
//           favoriteDocId = null;
//         });
//       }
//     } else {
//       // **Add to favorites**
//       final docRef = await favoritesRef.add({
//         'name': widget.name,
//         'image': widget.image,
//         'distance': widget.distance,
//         'foodItems': widget.foodItems.map((foodItem) => foodItem.toMap()).toList(), // Convert FoodItem objects to Map
//         'rating': widget.rating, // Store rating if needed
//         'timestamp': FieldValue.serverTimestamp(),
//       });
//
//       setState(() {
//         isFavorite = true;
//         favoriteDocId = docRef.id;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // The entire body is now removed (no UI elements at all)
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.name),  // You can still show the name if you want
//         // No favorite icon in the app bar
//       ),
//       body: Container(),  // Empty container (no UI elements)
//       // Trigger favorite addition/removal when this page is used (in some event or when navigating to it)
//       floatingActionButton: FloatingActionButton(
//         onPressed: _toggleFavorite,
//         child: Icon(Icons.favorite), // Floating action button to toggle favorite
//         tooltip: "Add to Favorites",
//       ),
//     );
//   }
// }
