import 'package:flutter/material.dart';


import 'models.dart'; // Import the models from model.dart

class FoodDetailsPage extends StatelessWidget {
  final FoodItem foodItem;

  // Initialize the food item (this will come from your model)
  FoodDetailsPage({required this.foodItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Food Details')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Show the bottom sheet with food details
            showModalBottomSheet(
              context: context,
              isScrollControlled: true, // Control the sheet's height
              backgroundColor: Colors.black.withOpacity(0.4), // Make the background semi-transparent
              builder: (context) {
                return FoodPopup(foodItem: foodItem);
              },
            );
          },
          child: Text('Show Food Details'),
        ),
      ),
    );
  }
}

class FoodPopup extends StatelessWidget {
  final FoodItem foodItem;

  FoodPopup({required this.foodItem});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Food image
          Image.asset(foodItem.image, height: 150, fit: BoxFit.cover),

          SizedBox(height: 16),

          // Food name and description
          Text(
            foodItem.name,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            foodItem.description,
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 16),

          // Food price
          Text(
            '\$${foodItem.price}',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
          ),

          SizedBox(height: 16),

          // Order now button (bottom right)
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: () {
                // Handle the "Order Now" action
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Order placed for ${foodItem.name}'),
                ));
              },
              child: Text('Order Now'),
            ),
          ),
        ],
      ),
    );
  }
}
