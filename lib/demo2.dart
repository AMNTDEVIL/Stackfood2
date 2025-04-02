import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FoodAppHome(),
    );
  }
}

class FoodAppHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Row(
          children: [
            Icon(Icons.search, color: Colors.white),
            SizedBox(width: 10),
            Text("Are you hungry !!", style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Popular Restaurants Section
            sectionTitle("Popular Restaurants"),
            restaurantList(),

            // Referral Banner
            referralBanner(),

            // Popular Foods Nearby Section
            sectionTitle("Popular Foods Nearby"),
            popularFoodsList(),
          ],
        ),
      ),
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Icon(Icons.arrow_forward, color: Colors.orange),
        ],
      ),
    );
  }

  Widget restaurantList() {
    return SizedBox(
      height: 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          restaurantCard(
            image: 'assets/images/restaurant1.jpg',
            name: "Hungry Puppets",
            details: "Bengali, Indian, Pizza, Pasta, Snacks",
            rating: "4.7",
            distance: "563.83 km",
            time: "30-40 min",
          ),
          restaurantCard(
            image: 'assets/images/restaurant2.jpg',
            name: "Cafe Bistro",
            details: "Burgers, Coffee, Sandwiches",
            rating: "4.5",
            distance: "450.00 km",
            time: "20-30 min",
          ),
        ],
      ),
    );
  }

  Widget restaurantCard({required String image, required String name, required String details, required String rating, required String distance, required String time}) {
    return Container(
      width: 300,
      margin: EdgeInsets.only(left: 16, right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black.withOpacity(0.6),
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  Text(details, style: TextStyle(color: Colors.white, fontSize: 12)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("⭐ $rating", style: TextStyle(color: Colors.white)),
                      Text(distance, style: TextStyle(color: Colors.white)),
                      Text(time, style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget referralBanner() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: AssetImage('assets/images/referral_banner.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget popularFoodsList() {
    return SizedBox(
      height: 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          foodCard(image: 'assets/images/dessert1.jpg', name: "Brownie Delight", discount: "3.0% OFF"),
          foodCard(image: 'assets/images/dessert2.jpg', name: "Choco Cake", discount: "5.0% OFF"),
          foodCard(image: 'assets/images/drink.jpg', name: "Lemonade", discount: "10.0% OFF"),
        ],
      ),
    );
  }

  Widget foodCard({required String image, required String name, required String discount}) {
    return Container(
      width: 150,
      margin: EdgeInsets.only(left: 16, right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              color: Colors.orange,
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(discount, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomNavigationBar() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorites"),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.grey,
    );
  }
}
