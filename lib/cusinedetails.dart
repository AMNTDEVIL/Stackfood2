import 'package:flutter/material.dart';
import 'package:food/models.dart' as model;
import 'package:food/widgets/restaurant_details.dart';
import 'package:food/widgets/restaurant_list2.dart'; // Import your model file

class RestaurantCategoryScreen extends StatefulWidget {
  @override
  _RestaurantCategoryScreenState createState() =>
      _RestaurantCategoryScreenState();
}

class _RestaurantCategoryScreenState extends State<RestaurantCategoryScreen> {
  // The category that is currently selected, using FoodCategory enum
  model.FoodCategory selectedCategory = model.FoodCategory.Veg; // Default category

  // List of categories using FoodCategory enum
  List<model.FoodCategory> categories = [
    model.FoodCategory.Veg,
    model.FoodCategory.NonVeg,
    model.FoodCategory.Asian,
    model.FoodCategory.Italian,
    model.FoodCategory.Indian,
    model.FoodCategory.FastFood,
    model.FoodCategory.MiddleEastern,
    model.FoodCategory.Grill,
    model.FoodCategory.Japanese,
    model.FoodCategory.Bengali,
  ];

  @override
  Widget build(BuildContext context) {
    // Filter the restaurants based on the selected category
    List<Restaurant> filteredRestaurants = restaurants.where((restaurant) {
      // Check if the restaurant has the selected category
      return restaurant.categories
          .any((category) => category == selectedCategory);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurants by Category'),
      ),
      body: ListView.builder(
        itemCount: filteredRestaurants.length,
        itemBuilder: (context, index) {
          final restaurant = filteredRestaurants[index];
          return RestaurantCard(restaurant: restaurant);
        },
      ),
    );
  }
}

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;

  RestaurantCard({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        leading: Image.asset(
          restaurant.image,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(restaurant.name),
        subtitle: Text('Rating: ${restaurant.rating}'),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          // Use the restaurant object directly to pass data to the details page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RestaurantDetailsPage(
                name: restaurant.name,
                image: restaurant.image,
                rating: restaurant.rating,
                foodItems: restaurant.foodItems,
              ),
            ),
          );
        },
      ),
    );
  }
}
