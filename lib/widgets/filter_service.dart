import 'package:food/models.dart';

class FilterService {
  // Filters restaurants and food items based on selected filters
  static List<Restaurant> filterRestaurants(List<Restaurant> restaurants, List<String> selectedFilters) {
    List<Restaurant> filteredRestaurants = [];

    for (var restaurant in restaurants) {
      bool isMatch = true;

      // Check if the restaurant matches selected filters
      if (selectedFilters.contains("Top Rated") && restaurant.rating < 4.7) {
        isMatch = false;
      }
      if (selectedFilters.contains("Discounted") && restaurant.foodItems.every((food) => food.discount == 0)) {
        isMatch = false;
      }
      if (selectedFilters.contains("Veg") && !restaurant.categories.contains(FoodCategory.Veg)) {
        isMatch = false;
      }
      if (selectedFilters.contains("Non-Veg") && !restaurant.categories.contains(FoodCategory.NonVeg)) {
        isMatch = false;
      }

      // If the restaurant matches the filters, add it to the list
      if (isMatch) {
        filteredRestaurants.add(restaurant);
      }
    }

    return filteredRestaurants;
  }

  // Filter food items
  static List<FoodItem> filterFoodItems(List<FoodItem> foodItems, List<String> selectedFilters) {
    List<FoodItem> filteredFoodItems = [];

    for (var food in foodItems) {
      bool isMatch = true;

      if (selectedFilters.contains("Top Rated") && food.rating < 4.7) {
        isMatch = false;
      }
      if (selectedFilters.contains("Discounted") && food.discount == 0) {
        isMatch = false;
      }
      if (selectedFilters.contains("Veg") && !food.categories.contains(FoodCategory.Veg)) {
        isMatch = false;
      }
      if (selectedFilters.contains("Non-Veg") && !food.categories.contains(FoodCategory.NonVeg)) {
        isMatch = false;
      }

      if (isMatch) {
        filteredFoodItems.add(food);
      }
    }

    return filteredFoodItems;
  }
}
