import 'package:flutter/material.dart';
import 'package:food/models.dart' as models; // Ensure you're importing the correct model

class RestaurantDetailsPage2 extends StatefulWidget {
  final models.Restaurant restaurant;

  // Constructor to accept the entire restaurant object
  RestaurantDetailsPage2({required this.restaurant});

  @override
  _RestaurantDetailsPage2State createState() => _RestaurantDetailsPage2State();
}

class _RestaurantDetailsPage2State extends State<RestaurantDetailsPage2> {
  late List<models.FoodItem> filteredFoodItems;
  String filter = 'All';

  // Default food item in case the specific item is not found
  models.FoodItem defaultFoodItem = models.FoodItem(
    name: 'Unknown Item',
    categories: [models.FoodCategory.Asian],
    // Default category (or any category you prefer)
    price: 0.0,
    // Default price
    image: 'assets/default_food.png',
    // Default image path, make sure this file exists
    isFavorite: false,
    rating: 0,
    sizeOptions: [],
    addons: [],
    allergicIngredients: [], // Default favorite status
  );

  @override
  void initState() {
    super.initState();
    filteredFoodItems = widget.restaurant.foodItems;

    // Print restaurant details on page load
    printRestaurantDetails();
  }

  // Method to print restaurant details in the console
  void printRestaurantDetails() {
    final restaurant = widget.restaurant;
    print("Restaurant Name: ${restaurant.name}");
    print("Rating: ${restaurant.rating}");
    print("Categories: ${restaurant.categories.map((category) =>
    category
        .toString()
        .split('.')
        .last).join(', ')}");
    print("Food Items:");
    for (var foodItem in restaurant.foodItems) {
      print("- ${foodItem.name}: \$${foodItem.price}");
    }
  }

  // Filter food items based on category
  void filterFoodItems(String filterOption) {
    setState(() {
      filter = filterOption;
      if (filterOption == 'All') {
        filteredFoodItems = widget.restaurant.foodItems;
      } else {
        filteredFoodItems = widget.restaurant.foodItems
            .where((item) =>
            item.categories.contains(models.FoodCategory.values
                .firstWhere((category) =>
            category
                .toString()
                .split('.')
                .last == filterOption)))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.restaurant.name),
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white, // Icon color (white to contrast with orange background)
          onPressed: () {
            Navigator.pop(context); // Pops the current screen off the stack
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              widget.restaurant.image,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.restaurant.name,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.orange, size: 16),
                              const SizedBox(width: 5),
                              Text(
                                "${widget.restaurant.rating}",
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.share, color: Colors.orange),
                        onPressed: () {
                          // Add share functionality here
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Row for delivery, location, and rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Icon(Icons.delivery_dining, color: Colors.orange),
                          const SizedBox(height: 4),
                          Text("Delivery", style: TextStyle(fontSize: 12)),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(Icons.location_on, color: Colors.orange),
                          const SizedBox(height: 4),
                          Text("Location", style: TextStyle(fontSize: 12)),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(Icons.star_border, color: Colors.orange),
                          const SizedBox(height: 4),
                          Text("Rating", style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: models.FoodCategory.values.map((category) {
                      return ElevatedButton(
                        onPressed: () => filterFoodItems(category.toString().split('.').last),
                        child: Text(category.toString().split('.').last),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: filteredFoodItems.length,
                    itemBuilder: (context, index) {
                      final foodItem = filteredFoodItems[index];
                      return ListTile(
                        leading: Image.asset(foodItem.image, width: 50, height: 50),
                        title: Text(foodItem.name),
                        subtitle: Text(foodItem.categories.join(', ')),
                        trailing: IconButton(
                          icon: Icon(
                            foodItem.isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: foodItem.isFavorite ? Colors.red : Colors.orange,
                          ),
                          onPressed: () {
                            setState(() {
                              foodItem.isFavorite = !foodItem.isFavorite;
                            });
                          },
                        ),
                        onTap: () {
                          // Handle onTap, like showing food details
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
