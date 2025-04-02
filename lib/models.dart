
// Enum for food categories
enum FoodCategory {
  Veg,
  NonVeg,
  Indian,
  Grill,
  Asian,
  Italian,
  FastFood,
  Japanese,
  MiddleEastern,
  Bengali, Vegetarian,
}

class FoodItem {
  final String name;
  final String image;
  final double rating;
  final List<FoodCategory> categories; // Using the FoodCategory enum
  final String description;
  final double price;
  final List<String> sizeOptions;
  final List<String> addons;
  final List<String> allergicIngredients;
  final Map<String, String>? nutritionalDetails;
  final String restaurantName;
  final int? discount;
  bool isFavorite;

  FoodItem({
    required this.name,
    required this.image,
    required this.rating,
    required this.categories,
    this.description = '', // Default empty string
    this.price = 0.0, // Default to 0.0
    required this.sizeOptions,
    required this.addons,
    required this.allergicIngredients,
    this.nutritionalDetails,
    this.restaurantName = '', // Default empty string
    this.discount,
    this.isFavorite=false,
  });
}

// Restaurant class with associated food items and categories
class Restaurant {
  final String name;
  final String logo;
  final String image;
  final double rating;
  final List<FoodCategory> categories; // Required list of food categories
  final List<FoodItem> foodItems;



  Restaurant({
    required this.name,
    required this.logo,
    required this.image,
    required this.rating,
    required this.categories, // Now required to ensure consistency
    required this.foodItems,

  });
}
