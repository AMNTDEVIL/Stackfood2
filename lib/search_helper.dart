// // search_helper.dart
// import 'package:food/models.dart' as models;
//
// class SearchHelper {
//   // Function to filter search results based on user input
//   static void filterSearchResults(String query, Function updateFoodItems, Function updateRestaurants) {
//     List<FoodItem> filteredFoodItems = models.foodItems
//         .where((food) =>
//     food.name.toLowerCase().contains(query.toLowerCase()) ||
//         food.restaurantName.toLowerCase().contains(query.toLowerCase()) ||
//         food.categories.any((category) =>
//             category.toString().toLowerCase().contains(query.toLowerCase())))
//         .toList();
//
//     List<Restaurant> filteredRestaurants = models.restaurants
//         .where((restaurant) =>
//     restaurant.name.toLowerCase().contains(query.toLowerCase()) ||
//         restaurant.categories.any((category) =>
//             category.toString().toLowerCase().contains(query.toLowerCase())))
//         .toList();
//
//     // Update filtered food items and restaurants using the provided functions
//     updateFoodItems(filteredFoodItems);
//     updateRestaurants(filteredRestaurants);
//   }
// }
