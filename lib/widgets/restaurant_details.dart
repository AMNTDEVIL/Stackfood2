import 'package:flutter/material.dart';
import 'package:food/models.dart' as models;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RestaurantDetailsPage extends StatefulWidget {
  final String name;
  final String image;
  final double rating;
  final List<models.FoodItem>? foodItems;

  RestaurantDetailsPage({
    required this.name,
    required this.image,
    required this.rating,
    this.foodItems,
  });

  @override
  _RestaurantDetailsPageState createState() => _RestaurantDetailsPageState();
}

class _RestaurantDetailsPageState extends State<RestaurantDetailsPage> {
  late List<models.FoodItem> filteredFoodItems;
  String filter = 'All';
  User? user = FirebaseAuth.instance.currentUser; 

  @override
  void initState() {
    super.initState();
    filteredFoodItems = widget.foodItems ?? [];
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> localFavorites = prefs.getStringList('favorites') ?? [];

    if (user != null) {
      // Firestore favorites for logged-in users
      DocumentReference userDoc = FirebaseFirestore.instance.collection('users').doc(user!.uid);
      CollectionReference favorites = userDoc.collection('favorites');
      QuerySnapshot snapshot = await favorites.get();

      for (var doc in snapshot.docs) {
        String name = doc['name'];
        setState(() {
          widget.foodItems?.firstWhere((item) => item.name == name).isFavorite = true;
        });
      }
    }

    // Load from SharedPreferences for non-logged-in users
    setState(() {
      for (var food in widget.foodItems ?? []) {
        if (localFavorites.contains(food.name)) {
          food.isFavorite = true;
        }
      }
    });
  }

  Future<void> toggleFavorite(models.FoodItem foodItem) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> localFavorites = prefs.getStringList('favorites') ?? [];

    if (user != null) {
      // Firestore update for logged-in users
      DocumentReference userDoc = FirebaseFirestore.instance.collection('users').doc(user!.uid);
      CollectionReference favorites = userDoc.collection('favorites');
      String uniqueId = "${foodItem.name}-${foodItem.restaurantName}";

      QuerySnapshot snapshot = await favorites.where('uniqueId', isEqualTo: uniqueId).get();
      if (snapshot.docs.isEmpty) {
        await favorites.add({
          'uniqueId': uniqueId,
          'name': foodItem.name,
          'price': foodItem.price,
          'image': foodItem.image,
          'restaurant': foodItem.restaurantName,
          'addedAt': FieldValue.serverTimestamp(),
        });
      } else {
        await favorites.doc(snapshot.docs.first.id).delete();
      }
    } else {
      // SharedPreferences update for non-logged-in users
      if (foodItem.isFavorite) {
        localFavorites.remove(foodItem.name);
      } else {
        localFavorites.add(foodItem.name);
      }
      await prefs.setStringList('favorites', localFavorites);
    }

    setState(() {
      foodItem.isFavorite = !foodItem.isFavorite;
    });
  }

  void filterFoodItems(String filterOption) {
    setState(() {
      filter = filterOption;
      if (filterOption == 'All') {
        filteredFoodItems = widget.foodItems ?? [];
      } else {
        filteredFoodItems = (widget.foodItems ?? [])
            .where((item) => item.categories.contains(
                models.FoodCategory.values.firstWhere(
                    (category) => category.toString().split('.').last == filterOption)))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark; // Recalculate based on the current theme
    Color backgroundColor2 = isDarkMode ? Color(0xFF212121) : Colors.white;
    return Scaffold(
      body: Stack(
        children: [
          // Restaurant Image at the top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              widget.image,
              width: double.infinity,
              height: 220,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 30, // Adjust the position as needed
            left: 10, // Adjust the position as needed
            child: Container(
              padding: EdgeInsets.all(8), // Padding around the icon
              decoration: BoxDecoration(
                color: Colors.orange, // Orange background
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white, // White icon color
                ),
                onPressed: () {
                  // Add your back navigation logic here
                  Navigator.pop(context);
                },
              ),
            ),
          ),

          // Restaurant Details Card
          Positioned(
            top: 180,
            left: 20,
            right: 20,
            child: Container(
              decoration:  BoxDecoration(
                color: backgroundColor2,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Restaurant Name & Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(widget.image, width: 40, height: 40, fit: BoxFit.cover),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                              Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.orange, size: 18),
                                  Text("${widget.rating}", style: const TextStyle(fontSize: 16)),
                                ],
                              ),
                            ],
                          ),

                        ],
                      ),
                      IconButton(icon: const Icon(Icons.share, color: Colors.orange), onPressed: () {}),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Icon(Icons.delivery_dining, color: Colors.orange),
                          const SizedBox(height: 4),
                          Text("20-30 mins", style: TextStyle(fontSize: 12)),
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
                          Text("4.5", style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Category Filter & Search
          Positioned(
            bottom: 320,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              color: backgroundColor2,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("All Foods", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          IconButton(icon: const Icon(Icons.search, color: Colors.orange), onPressed: () {}),
                          IconButton(icon: const Icon(Icons.filter_list, color: Colors.orange), onPressed: () {}),
                        ],
                      ),
                    ],
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: models.FoodCategory.values.map((category) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ElevatedButton(
                            onPressed: () => filterFoodItems(category.toString().split('.').last),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: filter == category.toString().split('.').last
                                  ? Colors.orange
                                  : Colors.grey[200],
                            ),
                            child: Text(category.toString().split('.').last),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Food List
          Positioned(
            top:420,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: filteredFoodItems.isEmpty
                  ? const Center(child: Text("No food items available.", style: TextStyle(fontSize: 16, color: Colors.grey)))
                  : ListView.builder(
                itemCount: filteredFoodItems.length,
                itemBuilder: (context, index) {
                  final foodItem = filteredFoodItems[index];
                  return GestureDetector(
                    onTap: () => _showFoodDetailsBottomSheet2(context, foodItem),
                    child: ListTile(
                      leading: Image.asset(
                        foodItem.image,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(foodItem.name),
                      subtitle: Text(foodItem.categories.join(', ')),
                      trailing: IconButton(
                        icon: Icon(
                          foodItem.isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: foodItem.isFavorite ? Colors.red : Colors.orange,
                        ),
                        onPressed: () => toggleFavorite(foodItem),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
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
