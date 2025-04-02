import 'package:flutter/material.dart';
import 'package:food/widgets/restaurant_list2.dart';
import 'widgets/restaurant_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void _addToFavorites(Restaurant restaurant) {
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    // Prepare foodItems data
    List<Map<String, dynamic>> foodItemsData = restaurant.foodItems.map((foodItem) {
      return {
        'name': foodItem.name,
        'image': foodItem.image,
        'rating': foodItem.rating,
        'description': foodItem.description,
        'price': foodItem.price,
        // Add any other properties of foodItem you want to store
      };
    }).toList();

    // Store restaurant and foodItems data in Firestore
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites_restaurants')
        .add({
      'name': restaurant.name,
      'logo': restaurant.logo,
      'rating': restaurant.rating,
      'foodItems': foodItemsData, // Store foodItems as a list of maps
    })
        .then((value) {
      print("Restaurant and food items added to favorites");
    })
        .catchError((error) {
      print("Failed to add restaurant to favorites: $error");
    });
  } else {
    print("No user logged in.");
  }
}

class RestaurantListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurants'),
      ),
      body: ListView.builder(
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          final restaurant = restaurants[index];

          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              leading: Image.asset(
                restaurant.logo,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text(
                restaurant.name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Start from \$0', style: TextStyle(fontSize: 14, color: Colors.grey)),
                  SizedBox(height: 5),
                  Text('⭐ ${restaurant.rating}', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 5),
                  Row(
                    children: restaurant.foodItems
                        .take(4) // Limit to 4 items
                        .map((foodItem) => Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: CircleAvatar(
                        radius: 15,
                        backgroundImage: AssetImage(foodItem.image),
                      ),
                    ))
                        .toList(),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.favorite_border), // Favorite icon
                onPressed: () {
                  _addToFavorites(restaurant); // Call the method to add to favorites
                },
              ),
              onTap: () {
                // Navigate to RestaurantDetailsScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RestaurantDetailsPage(
                      name: restaurant.name,        // Passing restaurant name
                      image: restaurant.logo,       // Passing restaurant image
                      rating: restaurant.rating,    // Passing restaurant rating
                      foodItems: restaurant.foodItems, // Passing list of food items
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
