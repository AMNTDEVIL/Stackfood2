import 'package:flutter/material.dart';
import 'package:food/models.dart' as models;
import 'package:food/widgets/restaurant_list2.dart';  // Import the restaurant list
import 'package:food/widgets/restaurant_details.dart';

class CategoryFoodPage extends StatefulWidget {
  final models.FoodCategory selectedCategory;
  final List<models.FoodItem> allFoodItems;
  final List<Restaurant> allRestaurants;
  CategoryFoodPage({
    required this.selectedCategory,
    required this.allFoodItems,
    required this.allRestaurants,
  });

  @override
  _CategoryFoodPageState createState() => _CategoryFoodPageState();
}

class _CategoryFoodPageState extends State<CategoryFoodPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // 2 tabs: Food Items and Restaurants
  }

  @override
  Widget build(BuildContext context) {
    // Correct reference to the selectedCategory
    models.FoodCategory selectedCategory = widget.selectedCategory;

    // Filter food items based on the selected category
    List<models.FoodItem> filteredFoodItems = widget.allFoodItems
        .where((foodItem) => foodItem.categories.contains(selectedCategory)) // Direct enum comparison
        .toList();

    // Filter restaurants that offer food items from the selected category
    List<Restaurant> filteredRestaurants = restaurants // Use restaurantList
        .where((restaurant) =>
        restaurant.foodItems.any((foodItem) => foodItem.categories.contains(selectedCategory))) // Direct enum comparison
        .toList();


    return Scaffold(
      appBar: AppBar(
        title: Text('${selectedCategory.toString().split('.').last} Food & Restaurants'),
        backgroundColor: Colors.orangeAccent,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: "Food Items"),
            Tab(text: "Restaurants"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Food Items Tab
          filteredFoodItems.isNotEmpty
              ? ListView.builder(
            itemCount: filteredFoodItems.length,
            itemBuilder: (context, index) {
              final foodItem = filteredFoodItems[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: Image.asset(foodItem.image),
                  title: Text(foodItem.name),
                  subtitle: Text('Rating: ${foodItem.rating}'),
                  onTap: (){
                    _showFoodDetailsBottomSheet2(context, foodItem);
                  },
                ),
              );
            },
          )
              : Center(child: Text('No food items available for this category')),

          // Restaurants Tab
          filteredRestaurants.isNotEmpty
              ? ListView.builder(
            itemCount: filteredRestaurants.length,
            itemBuilder: (context, index) {
              final restaurant = filteredRestaurants[index];
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
            },
          )
              : Center(child: Text('No restaurants available for this category')),
        ],
      ),
    );
  }
}
void _showFoodDetailsBottomSheet2(BuildContext context, models.FoodItem foodItem) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Allow scrolling if necessary
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      int quantity = 1;
      double price = foodItem.price ?? 0;
      double totalAmount = price * quantity;

      return StatefulBuilder(
        builder: (context, setState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.5, // Half of the screen height
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Food Image on the left
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        foodItem.image,
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(child: Text('Image not found'));
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Food Name
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          foodItem.name,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Restaurant Name", // Replace with actual restaurant name
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 5),
                        // Rating Stars (Placeholder)
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < foodItem.rating.round()
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.orange,
                              size: 18,
                            );
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Price Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Price:", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("\$${price.toStringAsFixed(2)}", style: const TextStyle(color: Colors.green)),
                  ],
                ),
                const SizedBox(height: 10),

                // Description Section
                Text(
                  foodItem.description,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 10),

                // Categories
                Text(
                  "Categories: ${foodItem.categories.join(", ")}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                // Addons Section
                const Text("Addons:", style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: foodItem.addons.contains("Pepsi"),
                      onChanged: (bool? selected) {
                        setState(() {
                          if (selected!) {
                            foodItem.addons.add("Pepsi");
                          } else {
                            foodItem.addons.remove("Pepsi");
                          }
                          totalAmount = (price * quantity) +
                              (foodItem.addons.contains("Pepsi") ? 2.5 : 0);
                        });
                      },
                    ),
                    const Text("Pepsi (+\$2.5)"),
                    const SizedBox(width: 20),
                    Checkbox(
                      value: foodItem.addons.contains("Extra Meat"),
                      onChanged: (bool? selected) {
                        setState(() {
                          if (selected!) {
                            foodItem.addons.add("Extra Meat");
                          } else {
                            foodItem.addons.remove("Extra Meat");
                          }
                          totalAmount = (price * quantity) +
                              (foodItem.addons.contains("Extra Meat") ? 3.0 : 0);
                        });
                      },
                    ),
                    const Text("Extra Meat (+\$3)"),
                  ],
                ),
                const SizedBox(height: 10),

                // Total Amount Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total:", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("\$${totalAmount.toStringAsFixed(2)}", style: const TextStyle(color: Colors.green)),
                  ],
                ),
                const SizedBox(height: 10),

                // Quantity Selector and Order Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (quantity > 1) {
                              setState(() {
                                quantity--;
                                totalAmount = (price * quantity) +
                                    (foodItem.addons.contains("Pepsi") ? 2.5 : 0) +
                                    (foodItem.addons.contains("Extra Meat") ? 3.0 : 0);
                              });
                            }
                          },
                          icon: const Icon(Icons.remove, color: Colors.red),
                        ),
                        Text(
                          quantity.toString(),
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              quantity++;
                              totalAmount = (price * quantity) +
                                  (foodItem.addons.contains("Pepsi") ? 2.5 : 0) +
                                  (foodItem.addons.contains("Extra Meat") ? 3.0 : 0);
                            });
                          },
                          icon: const Icon(Icons.add, color: Colors.green),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        print("Added to cart: ${foodItem.name}, Quantity: $quantity, Total: \$${totalAmount.toStringAsFixed(2)}");
                        Navigator.pop(context); // Close modal
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text("Order Now"),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

