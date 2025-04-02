import 'package:flutter/material.dart';

class FoodHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: TextField(
          decoration: InputDecoration(
            hintText: "Are you hungry !!",
            prefixIcon: Icon(Icons.search, color: Colors.white),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // New on StackFood Section
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "New on StackFood",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 150,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    buildHorizontalCard(context, "Mini Kebab", "100+ km", "8+ Item"),
                    buildHorizontalCard(context, "Spicy Delight", "50+ km", "12+ Item"),
                    buildHorizontalCard(context, "Tandoor Express", "70+ km", "15+ Item"),
                  ],
                ),
              ),
              // All Restaurants Section
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "All Restaurants",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Flexible(
                      child: Text(
                        "14 Restaurants near you",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                        overflow: TextOverflow.ellipsis, // Prevents overflow
                      ),
                    ),
                  ],
                ),
              ),
              // Filters
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Wrap(
                  spacing: 10, // Adds space between filter chips
                  runSpacing: 10, // Adjust spacing for multi-line chips
                  children: [
                    buildFilterChip("Top Rated"),
                    buildFilterChip("Discounted"),
                    buildFilterChip("Veg"),
                    buildFilterChip("Non-Veg"),
                  ],
                ),
              ),
              // Restaurant Cards
              buildRestaurantCard(
                image: "assets/cafemonarch.png",
                name: "Café Monarch",
                rating: 5.0,
                deliveryTime: "30-40 min",
                distance: "1879.00 km",
              ),
              buildRestaurantCard(
                image: "assets/hungrypuppets.png",
                name: "Hungry Puppets",
                rating: 4.7,
                deliveryTime: "30-40 min",
                distance: "563.83 km",
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorites"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Menu"),
        ],
      ),
    );
  }

  Widget buildHorizontalCard(BuildContext context, String title, String distance, String items) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6, // Limit the card width
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.orange[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.fastfood, size: 40, color: Colors.orange),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(distance, style: TextStyle(color: Colors.grey)),
          Text(items, style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget buildFilterChip(String label) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.orange[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.orange),
      ),
    );
  }

  Widget buildRestaurantCard({
    required String image,
    required String name,
    required double rating,
    required String deliveryTime,
    required String distance,
  }) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          // Image section with fixed height and width (20% of screen)
          Builder(
            builder: (BuildContext context) {
              return ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.2,  // 20% of screen width
                  height: MediaQuery.of(context).size.height * 0.2, // 20% of screen height
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
          // Text details section
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis, // Prevents text overflow
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.orange, size: 16),
                    SizedBox(width: 5),
                    Text("$rating"),
                    Spacer(),
                    Icon(Icons.access_time, color: Colors.grey, size: 16),
                    SizedBox(width: 5),
                    Text(deliveryTime),
                  ],
                ),
                SizedBox(height: 5),
                Text(distance, style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
