import 'package:flutter/material.dart';
import 'package:food/models.dart' as models;
import 'package:food/widgets/food_list.dart' as food_list;
import 'package:food/widgets/restaurant_list2.dart';
import 'package:food/categoryfoodpage.dart';

class CategoryGrid extends StatelessWidget {
  final List<Map<String, String>> categories = [
    {'name': 'Asian', 'icon': '🍣'},
    {'name': 'Biriyani', 'icon': '🍛'},
    {'name': 'Burger', 'icon': '🍔'},
    {'name': 'Cake', 'icon': '🍰'},
    {'name': 'Chinese', 'icon': '🥢'},
    {'name': 'Japanese', 'icon': '🍣'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Category',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          const Divider(color: Colors.grey, thickness: 1), // Grey separator line
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3 columns per row
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 1, // Keeps square-like size for each item
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                String categoryName = categories[index]['name']!;
                String categoryIcon = categories[index]['icon']!;

                return GestureDetector(
                  onTap: () {
                    // Convert category string to FoodCategory enum
                    models.FoodCategory selectedCategoryEnum = models.FoodCategory.values.firstWhere(
                          (categoryEnum) => categoryEnum.toString().split('.').last == categoryName,
                      orElse: () => models.FoodCategory.Veg, // Default to Veg if no match
                    );

                    // Filter food items based on the selected category
                    List<models.FoodItem> filteredFoodItems = food_list.foodItems.where((foodItem) {
                      return foodItem.categories.contains(selectedCategoryEnum);
                    }).toList();

                    // Navigate to CategoryFoodPage with filtered items
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryFoodPage(
                          selectedCategory: selectedCategoryEnum,
                          allFoodItems: filteredFoodItems,
                          allRestaurants: restaurants, // Pass restaurant data
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.orangeAccent,
                          child: Text(
                            categoryIcon,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          categoryName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
