import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'map.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _locationInfo = "Your saved location"; // Sample location
  List<String> carouselImages = [
    'assets/image1.jpg', // Make sure you have the corresponding images in your assets folder
    'assets/image2.jpg',
    'assets/image3.jpg',
  ];
  List<Map<String, String>> categories = [
    {'icon': '🍔', 'name': 'Burgers'},
    {'icon': '🍕', 'name': 'Pizza'},
    {'icon': '🍣', 'name': 'Sushi'},
  ];
  List<Map<String, String>> trends = [
    {'image': 'assets/trend1.jpg', 'discount': '20%'},
    {'image': 'assets/trend2.jpg', 'discount': '30%'},
    {'image': 'assets/trend3.jpg', 'discount': '15%'},
  ];

  // Sample function to load location
  void _loadSavedLocation() {
    setState(() {
      _locationInfo = "New saved location"; // Example of updated location
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main Scaffold content
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 120), // Space for AppBar + Search bar
                // Carousel Slider
                CarouselSlider(
                  items: carouselImages.map((imageUrl) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(imageUrl),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    );
                  }).toList(),
                  options: CarouselOptions(
                    height: 180.0,
                    autoPlay: true,
                    enlargeCenterPage: true,
                  ),
                ), // End Carousel Slider
                const SizedBox(height: 16),

                // Categories Section
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'What\'s on your mind?',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ), // End Categories Section
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: categories.map((category) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.orangeAccent,
                              child: Text(category['icon']!),
                            ),
                            const SizedBox(height: 8),
                            Text(category['name']!),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ), // End Horizontal Scroll for Categories

                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Today\'s Trends',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ), // End "Today's Trends" header
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 3 / 2,
                  ),
                  itemCount: trends.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(trends[index]['image']!),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            color: Colors.orange,
                            child: Text(
                              '${trends[index]['discount']} OFF',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ), // End GridView for Trends
                const SizedBox(height: 16),
              ],
            ),
          ), // End SingleChildScrollView

          // AppBar with PreferredSize
          PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: AppBar(
              backgroundColor: Colors.orange,
              elevation: 0,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Your Location', style: TextStyle(fontSize: 14)),
                  GestureDetector(
                    onTap: () {
                      // Navigate to the MapPage when tapped
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MapPage()),
                      ).then((_) {
                        // Reload saved location after returning from MapPage
                        _loadSavedLocation();
                      });
                    },
                    child: Text(
                      _locationInfo, // Display the saved location
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications),
                  onPressed: () {},
                ),
              ],
            ),
          ), // End PreferredSize (AppBar)

          // Overlapping Search Bar
          Positioned(
            top: 50, // Adjust to position below the AppBar
            left: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(80),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search your favorite food...',
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(80),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ), // End Search Bar Positioned
        ],
      ),
    ); // End Scaffold
  }
}

// Sample MapPage for Navigation
