// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:food/add_to_card_back.dart';
// import 'package:food/add_to_fav.dart';
// import 'package:food/addtocart.dart';
// import 'package:food/categoryfoodpage.dart' as categoryfoodpage;
// import 'package:food/categoryfoodpage.dart';
// import 'package:food/cusinedetails.dart';
// import 'package:food/favorites.dart';
// import 'package:food/models.dart' as models;
// import 'package:food/orders.dart';
// import 'package:food/place_order.dart';
// import 'package:food/whats%20on%20your%20mind.dart';
// import 'package:food/widgets/BottomNavBar.dart';
// import 'package:food/widgets/food_list.dart' as food_list;
// import 'package:food/widgets/restaurant_list2.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart'as gmap;
// import 'settings.dart';
// import 'widgets/restaurant_details.dart' as rest_de;
// import 'package:food/checkout.dart';
// import 'map.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:food/NearbyLocationPage.dart';
// import 'package:food/locationpage.dart';
// import 'package:food/widgets/fav_restaurant.dart';
//
// class HomePage extends StatefulWidget {
//
//   final Function(Locale) changeLanguage;
//   const HomePage({Key? key, required this.changeLanguage}) : super(key: key);
//
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
//
// class _HomePageState extends State<HomePage> {
//   List<models.FoodItem> favoriteFoods = []; // List to store favorite foods
//
//   // Method to update favorite foods
//   void updateFavorite(models.FoodItem foodItem) {
//     setState(() {
//       favoriteFoods.add(foodItem);
//     });
//     print("Food item added: $foodItem");
//   }
//
//   gmap.LatLng currentLocation = gmap.LatLng(
//       27.7172, 85.3240); // Default location
//   String _locationInfo = 'Choose Your Location'; // Default text
//
//
//   Future<void> onFoodItemTapped(BuildContext context,
//       String image,
//       String name,
//       double price,
//       bool hasDiscount) async {
//     // Get the shared preferences instance
//     final prefs = await SharedPreferences.getInstance();
//
//     // Store the food item's details in SharedPreferences
//     await prefs.setString('favorite_food_name', name);
//     await prefs.setString('favorite_food_image', image);
//     await prefs.setDouble('favorite_food_price', price);
//     await prefs.setBool('favorite_food_discount', hasDiscount);
//
//     // Navigate to the favorites page
//     Navigator.pushNamed(context,
//         '/favorites'); // Make sure '/favorites' is the correct route to your favorites page
//   }
//
//   List<String> selectedFilters = [];
//
//   // Handle BottomNavBar tap
//   void _onTapNav(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//   }
//
//   Locale _locale = Locale('en', '');
//
//   // video player
//   @override
//   void initState() {
//     super.initState();
//     _loadSavedLocation(); // Keep the location loading logic without video player initialization
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   List<String> selectedFilters2 = []; // Track selected filters
//
//   void toggleFilter(String filter) {
//     setState(() {
//       if (selectedFilters.contains(filter)) {
//         selectedFilters.remove(filter); // Deselect if already selected
//       } else {
//         selectedFilters.add(filter); // Select the filter
//       }
//     });
//   }
//
//
//   // Location variables
//
//   Set<gmap.Marker> _markers = {};
//
//   late final CarouselController _controller = CarouselController();
//   final PageController _pageController = PageController();
//
//   // Function to change the locale
//   void _changeLanguage(Locale locale) {
//     setState(() {
//       _locale = locale;
//     });
//   }
//
//   List<String> restaurantNames = [
//     'The Royal Dine',
//     'Food Street',
//     'Hungry Puppets',
//
//   ];
//   final List<String> carouselImages = [
//     'assets/burger.png',
//     'assets/tandori.png',
//     'assets/cake.png',
//     'assets/biryani.png',
//     'assets/sushi.png',
//   ];
//   int _currentIndex = 0;
//
//   //
//   // Function to update the current index when page is changed
//   void _onPageChanged(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//   }
//
//   final List<Map<String, String>> categories = [
//     {'name': 'Asian', 'icon': '🍣'},
//     {'name': 'Biriyani', 'icon': '🍛'},
//     {'name': 'Burger', 'icon': '🍔'},
//     {'name': 'Cake', 'icon': '🍰'},
//     {'name': 'Chinese', 'icon': '🥢'},
//     {'name': 'Japanese', 'icon': '🍣'},
//   ];
//
//   final List<Map<String, String>> trends = [
//     {'image': 'assets/trend1.png', 'discount': '10.0%'},
//     {'image': 'assets/trend2.png', 'discount': '30.0%'},
//   ];
//   final List<Map<String, String>> saleItems = [
//     {
//       'image': 'assets/discount_image2.png',
//       'text': 'Summer Blowout Sale\n50% OFF',
//       'name': 'Café Monarch',
//     },
//     {
//       'image': 'assets/discount_image3.png',
//       'text': 'Winter Clearance\n70% OFF',
//       'name': 'Hungry Puppets',
//     },
//   ];
//   int _selectedIndex = 0;
//
//
//   final defaultFoodItem = models.FoodItem(
//     name: 'Unknown Item',
//     image: 'assets/default_food.png',
//     categories: [models.FoodCategory.Veg],
//     // A default category
//     rating: 0.0,
//     sizeOptions: [''],
//     addons: [''],
//     allergicIngredients: [''],
//   );
//
//   // Handle BottomNavigationBar item tap
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//
//     // Navigate to SettingsPage when the menu item (index 3) is tapped
//     if (index == 3) {
//       // Navigate to SettingsPage
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => SettingsPage(),
//         ),
//       );
//     }
//   }
//
//   Future<String> _getPlusCode(double latitude, double longitude) async {
//     final url = Uri.parse(
//         'https://plus.codes/api?address=$latitude,$longitude'); // Plus Codes API URL
//
//     try {
//       var response = await http.get(url);
//       if (response.statusCode == 200) {
//         final jsonResponse = json.decode(response.body);
//         return jsonResponse['plus_code']['global_code'] ??
//             "No Plus Code available";
//       } else {
//         return "No Plus Code available";
//       }
//     } catch (e) {
//       return "Error fetching Plus Code";
//     }
//   }
//
//   Future<String> _loadSavedLocation() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     double? latitude = prefs.getDouble('latitude');
//     double? longitude = prefs.getDouble('longitude');
//     String? locationInfo = prefs.getString('location_info');
//
//     if (latitude != null && longitude != null && locationInfo != null) {
//       String plusCode = await _getPlusCode(latitude, longitude);
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//           latitude, longitude);
//       String? address = placemarks.isNotEmpty
//           ? "${placemarks[0].locality}, ${placemarks[0].country}"
//           : "Address not found";
//
//       return "$plusCode, $address";
//     } else {
//       return 'Choose Your Location'; // Default text if no location is saved
//     }
//   }
//
//   // Function to update saved location
//   Future<void> _updateLocation(gmap.LatLng location,
//       String locationInfo) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setDouble('latitude', location.latitude);
//     prefs.setDouble('longitude', location.longitude);
//     prefs.setString('location_info', locationInfo);
//
//     setState(() {
//       currentLocation = currentLocation;
//       _locationInfo = locationInfo;
//       _markers.clear();
//       _markers.add(
//         gmap.Marker(
//           markerId: gmap.MarkerId('saved_location'),
//           infoWindow: gmap.InfoWindow(title: 'Saved Location'),
//         ),
//       );
//     });
//   }
//
// // Helper function to find a restaurant by image
//   Restaurant? findRestaurantByImage(String image) {
//     for (var rest in restaurants) {
//       if (rest.foodItems.any((foodItem) => foodItem.image == image)) {
//         return rest;
//       }
//     }
//     return null; // Return null if no restaurant is found
//   }
//
//   void validateCarouselImages() {
//     for (var image in carouselImages) {
//       if (findRestaurantByImage(image) == null) {
//         throw Exception('No restaurant found for image: $image');
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final List<Widget> _pages = [
//       Center(child: Text('Home')),
//       FavoritesPage(),
//       Center(child: Text('Cart')),
//       MyOrdersPage(), // OrdersPage for index 3
//       SettingsPage() // SettingsPage for index 4
//     ];
//     return Scaffold(
//       body: Stack(
//           appBar:AppBar(title: Text('StackFood')),
//           children: [
//       SingleChildScrollView(
//       child: Column(
//       children: [
//           const SizedBox(height: 140),
//       // Carousel Slider to show the images
// //                 CarouselSlider(
// //                   items: carouselImages.map((carouselImage) {
// //                     // Find the restaurant that corresponds to this image
// //                     Restaurant? restaurant = findRestaurantByImage(
// //                         carouselImage);
// //
// //                     return GestureDetector(
// //                       onTap: () {
// //                         if (restaurant != null) {
// //                           Navigator.push(
// //                             context,
// //                             MaterialPageRoute(
// //                               builder: (context) =>
// //                                   rest_de.RestaurantDetailsPage(
// //                                     name: restaurant.name,
// //                                     image: restaurant.image,
// //                                     rating: restaurant.rating,
// //                                     foodItems: restaurant.foodItems,
// //                                   ),
// //                             ),
// //                           );
// //                         } else {
// //                           // Handle the case where no restaurant is found (optional)
// //                           ScaffoldMessenger.of(context).showSnackBar(
// //                             SnackBar(
// //                               content: Text(
// //                                   'No restaurant found for this image.'),
// //                             ),
// //                           );
// //                         }
// //                       },
// //                       child: Container(
// //                         margin: const EdgeInsets.symmetric(horizontal: 8.0),
// //                         decoration: BoxDecoration(
// //                           borderRadius: BorderRadius.circular(10),
// //                           image: DecorationImage(
// //                             image: AssetImage(carouselImage),
// //                             fit: BoxFit.cover,
// //                           ),
// //                         ),
// //                       ),
// //                     );
// //                   }).toList(),
// //                   options: CarouselOptions(
// //                     height: 180.0,
// //                     autoPlay: true,
// //                     enlargeCenterPage: true,
// //                     onPageChanged: (index, reason) {
// //                       setState(() {
// //                         _currentIndex = index;
// //                       });
// //                     },
// //                   ),
// //                 ),
// //
// //
// //                 const SizedBox(height: 16),
// //
// // // Indicator Row for active page
// //                 Row(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: List.generate(carouselImages.length, (index) {
// //                     bool isActive = index ==
// //                         _currentIndex; // Check if this index is active
// //
// //                     return Container(
// //                       width: isActive ? 30 : 5,
// //                       height: 24,
// //                       margin: const EdgeInsets.symmetric(horizontal: 4),
// //                       decoration: BoxDecoration(
// //                         color: Colors.orange,
// //                         shape: isActive ? BoxShape.rectangle : BoxShape.circle,
// //                         borderRadius: isActive
// //                             ? const BorderRadius.only(
// //                           topLeft: Radius.circular(6),
// //                           topRight: Radius.circular(6),
// //                         )
// //                             : null,
// //                       ),
// //                       child: isActive
// //                           ? Center(
// //                         child: Text(
// //                           '${index + 1} / 5',
// //                           // Ensure proper spacing and formatting
// //                           style: const TextStyle(
// //                             color: Colors.white,
// //                             fontWeight: FontWeight.bold,
// //                             fontSize: 12,
// //                           ),
// //                         ),
// //                       )
// //                           : null, // No text for inactive dots
// //                     );
// //                   }),
// //                 ),
// //
// //                 SizedBox(
// //                   height: 10, // Adjust the height as needed
// //                   child: Container(),
// //                 ),
//
//       // Column(
//       //   children: [
//       //     Padding(
//       //       padding: const EdgeInsets.only(
//       //           top: 5.0, left: 16.0, right: 16.0),
//       //       child: Row(
//       //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       //         // This will place the text on the left and the arrow on the right
//       //         children: [
//       //           // "What's on Your Mind" Text
//       //           Text(
//       //             "Whats On YOur mInd!!",
//       //             style: TextStyle(fontSize: 18,
//       //                 fontWeight: FontWeight.bold),
//       //           ),
//       //
//       //           // Right Arrow Icon in Circle
//       //           Container(
//       //             decoration: BoxDecoration(
//       //               shape: BoxShape.circle,
//       //               color: Colors
//       //                   .orange, // Circle with orange background
//       //             ),
//       //             child: IconButton(
//       //               icon: Icon(
//       //                 Icons.arrow_forward, // Right arrow icon
//       //                 color: Colors.white, // White icon color
//       //               ),
//       //               onPressed: () {
//       //                 Navigator.push(context, MaterialPageRoute(
//       //                     builder: (context) => CategoryGrid()));
//       //               },
//       //             ),
//       //           ),
//       //         ],
//       //       ),
//       //     ),
//       //     const SizedBox(height: 8), // Space before categories
//
//       //     // Your categories list
//       //     SingleChildScrollView(
//       //       scrollDirection: Axis.horizontal,
//       //       child: Row(
//       //         children: categories.map((categoryData) {
//       //           String categoryName = categoryData['name']!;
//       //           return Padding(
//       //             padding: const EdgeInsets.symmetric(
//       //                 horizontal: 8.0),
//       //             child: GestureDetector(
//       //               onTap: () {
//       //                 models
//       //                     .FoodCategory selectedCategoryEnum = models
//       //                     .FoodCategory.values.firstWhere(
//       //                       (categoryEnum) =>
//       //                   categoryEnum
//       //                       .toString()
//       //                       .split('.')
//       //                       .last == categoryName,
//       //                   orElse: () => models.FoodCategory.Veg,
//       //                 );
//       //
//       //                 List<models
//       //                     .FoodItem> filteredFoodItems = food_list
//       //                     .foodItems.where((foodItem) {
//       //                   return foodItem.categories.contains(
//       //                       selectedCategoryEnum);
//       //                 }).toList();
//       //
//       //                 Navigator.push(
//       //                   context,
//       //                   MaterialPageRoute(
//       //                     builder: (context) =>
//       //                         CategoryFoodPage(
//       //                           selectedCategory: selectedCategoryEnum,
//       //                           allFoodItems: filteredFoodItems,
//       //                           allRestaurants: restaurants,
//       //                         ),
//       //                   ),
//       //                 );
//       //               },
//       //               child: Column(
//       //                 children: [
//       //                   CircleAvatar(
//       //                     radius: 30,
//       //                     backgroundColor: Colors.orangeAccent,
//       //                     child: Text(categoryData['icon']!,
//       //                         style: const TextStyle(fontSize: 24)),
//       //                   ),
//       //                   const SizedBox(height: 8),
//       //                   Text(
//       //                     categoryName,
//       //                     style: const TextStyle(
//       //                         fontWeight: FontWeight.bold),
//       //                   ),
//       //                 ],
//       //               ),
//       //             ),
//       //           );
//       //         }).toList(),
//       //       ),
//       //     ),
//       //   ],
//       // ),
//       //
//       // const SizedBox(height: 10),
//       // const SizedBox(height: 10),
//
//       // Column(
//       //   children: [
//       //     todaysTrendWidget(),
//       //   ],
//       // ),
//       // // Find Nearby Section
//       // Container(
//       //   padding: const EdgeInsets.all(16.0),
//       //   margin: const EdgeInsets.symmetric(horizontal: 16.0),
//       //   decoration: BoxDecoration(
//       //     color: Colors.orange.shade100.withOpacity(0.9),
//       //     // Opaque background
//       //     borderRadius: BorderRadius.circular(10),
//       //   ),
//       //   child: Row(
//       //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       //     children: [
//       //       Column(
//       //         crossAxisAlignment: CrossAxisAlignment.start,
//       //         children: const [
//       //           Text(
//       //             'Find Nearby',
//       //             style: TextStyle(
//       //               fontSize: 18,
//       //               fontWeight: FontWeight.bold,
//       //             ),
//       //           ),
//       //           Text('Restaurant Near from You',
//       //               style: TextStyle(color: Colors.grey)),
//       //         ],
//       //       ),
//       //       ElevatedButton(
//       //         style: ElevatedButton.styleFrom(
//       //           backgroundColor: Colors.orange,
//       //           shape: RoundedRectangleBorder(
//       //             borderRadius: BorderRadius.circular(20),
//       //           ),
//       //         ),
//       //         onPressed: () {
//       //           Navigator.push(
//       //               context, MaterialPageRoute(
//       //               builder: (context) => NearbyLocationPage())
//       //           );
//       //         },
//       //         child: const Text('See Location'),
//       //       ),
//       //     ],
//       //   ),
//       // ),
//       // const SizedBox(height: 16),
//
//
//       // //buildHightlightedSection
//       // _buildHighlightedSection(),
//
//       // Container(
//       //   padding: const EdgeInsets.all(20.0),
//       //   decoration: BoxDecoration(
//       //     color: Colors.orange[50],
//       //     // Set background color if needed
//       //     borderRadius: BorderRadius.circular(10),
//       //     // Optional: Add rounded corners
//       //     boxShadow: [ // Optional: Add shadow for better aesthetics
//       //       BoxShadow(
//       //         color: Colors.grey.withOpacity(0.2),
//       //         spreadRadius: 1,
//       //         blurRadius: 5,
//       //         offset: Offset(0, 3),
//       //       ),
//       //     ],
//       //   ),
//       //   child: Column(
//       //     crossAxisAlignment: CrossAxisAlignment.start,
//       //     children: [
//       //       const Text(
//       //         'Best Reviewed Food',
//       //         style: TextStyle(
//       //             fontSize: 18, fontWeight: FontWeight.bold),
//       //       ),
//       //       const SizedBox(height: 5),
//       //       // Add space between title and list
//       //       SingleChildScrollView(
//       //         scrollDirection: Axis.horizontal,
//       //         child: Row(
//       //           children: allFoodItems.entries.map((entry) {
//       //             return _buildFoodCard(
//       //               imagePath: entry.value.image,
//       //               // Image of the food
//       //               foodName: entry.value.name,
//       //               // Name of the food
//       //               rating: entry.value.rating,
//       //               // Rating of the food
//       //               foodItem: entry.value,
//       //               // FoodItem object itself
//       //               // price: entry.value.price,
//       //               // hasDiscount: true,
//       //               // restaurantName: entry.value.RestaurantsName,
//       //               // discount: entry.value.discount,
//       //               context: context,
//       //               // Context to navigate
//       //             );
//       //           }).toList(),
//       //         ),
//       //       ),
//       //     ],
//       //   ),
//       // ),
//       //
//       // // Dine-in View Restaurant Section
//       // Padding(
//       //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       //   child: Container(
//       //     decoration: BoxDecoration(
//       //       color: Colors.orange[100],
//       //       borderRadius: BorderRadius.circular(8),
//       //     ),
//       //     padding: EdgeInsets.all(16),
//       //     child: Row(
//       //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       //       children: [
//       //         Row(
//       //           children: [
//       //             Icon(Icons.restaurant, size: 40,
//       //                 color: Colors.orange),
//       //             SizedBox(width: 8),
//       //             Text(
//       //               "Want to Dine In?",
//       //               style: TextStyle(fontSize: 16),
//       //             ),
//       //           ],
//       //         ),
//       //         ElevatedButton(
//       //           onPressed: () {},
//       //           child: Text("View Restaurants"),
//       //           style: ElevatedButton.styleFrom(
//       //             backgroundColor: Colors.orange,
//       //           ),
//       //         ),
//       //       ],
//       //     ),
//       //   ),
//       // ),
//       // const SizedBox(height: 16),
//       // // Cuisine Section
//       // Container(
//       //   color: Colors.orange,
//       //   // Entire container is orange
//       //   padding: const EdgeInsets.all(16.0),
//       //   // Padding for the container
//       //   child: Column(
//       //     crossAxisAlignment: CrossAxisAlignment.start,
//       //     children: [
//       //       // Cuisine Header
//       //       Text(
//       //         'Cuisine',
//       //         style: TextStyle(
//       //           fontSize: 18,
//       //           fontWeight: FontWeight.bold,
//       //           color: Colors.white, // White text for better contrast
//       //         ),
//       //       ),
//       //       const SizedBox(height: 16),
//       //       // Spacing between header and items
//       //       // Cuisine Items in a vertical layout
//       //       Row(
//       //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       //         children: [
//       //           _buildCuisineCard('assets/asian.png', 'Asian'),
//       //           _buildCuisineCard('assets/indian.png', 'Indian'),
//       //           _buildCuisineCard('assets/chinese.png', 'Chinese'),
//       //         ],
//       //
//       //       ),
//       //       Row(
//       //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       //         children: [
//       //           _buildCuisineCard('assets/sushi.png', 'Japanese'),
//       //           _buildCuisineCard('assets/burger.png', 'American'),
//       //           _buildCuisineCard('assets/spanish.png', 'Spanish'),
//       //         ],
//       //       ),
//       //
//       //     ],
//       //   ),
//       // ),
//       // // Popular Restaurants Section
//       // sectionTitle("Popular Restaurants"),
//       // _restaurantList(context: context),
//
//       // // Referral Banner
//       // referralBanner(),
//       //
//       // // Popular Foods Nearby Section
//       // sectionTitle("Popular Foods Nearby"),
//       // popularFoodsList(context),
//       //
//       // // New on StackFood Section
//       // Container(
//       //   color: Colors.orange[100],
//       //   height: 250, // Increase height if necessary
//       //   child: Column(
//       //     crossAxisAlignment: CrossAxisAlignment.start,
//       //     children: [
//       //       Padding(
//       //         padding: const EdgeInsets.all(10.0),
//       //         child: Row(
//       //           mainAxisAlignment: MainAxisAlignment.start,
//       //           children: [
//       //             Text(
//       //               "New on StackFood",
//       //               style: TextStyle(
//       //                   fontSize: 18,
//       //                   fontWeight: FontWeight.bold,
//       //                   color: Colors.orange),
//       //             ),
//       //             Spacer(),
//       //             Container(
//       //               decoration: BoxDecoration(
//       //                 shape: BoxShape.circle,
//       //                 color: Colors.white,
//       //               ),
//       //               child: IconButton(
//       //                 icon: Icon(
//       //                   Icons.arrow_forward,
//       //                   color: Colors.orange,
//       //                 ),
//       //                 onPressed: () {
//       //                   // Navigate if needed
//       //                 },
//       //               ),
//       //             ),
//       //           ],
//       //         ),
//       //       ),
//       //       // Wrapping the ListView in a SingleChildScrollView to prevent overflow
//       //       Expanded(
//       //         child: SingleChildScrollView(
//       //           child: SizedBox(
//       //             child: ListView(
//       //               scrollDirection: Axis.horizontal,
//       //               children: [
//       //                 buildHorizontalCard(
//       //                     context, "Mini Kebab", "100+ km", "8+ Item",
//       //                     "assets/minikebab.png"),
//       //                 buildHorizontalCard(
//       //                     context, "Red Cliff", "50+ km", "12+ Item",
//       //                     "assets/redcliff.png"),
//       //                 buildHorizontalCard(
//       //                     context, "Hungry Puppets", "70+ km",
//       //                     "15+ Item", "assets/hungrypuppets.png"),
//       //                 buildHorizontalCard(
//       //                     context, "Café Monarch", "30+ km",
//       //                     "10+ Item", "assets/cafemonarch.png"),
//       //                 buildHorizontalCard(
//       //                     context, "Tasty Takeaways", "45+ km",
//       //                     "9+ Item", "assets/tastytakeaways.png"),
//       //                 buildHorizontalCard(
//       //                     context, "The Capital Grill", "60+ km",
//       //                     "14+ Item", "assets/capitalgrill.png"),
//       //                 buildHorizontalCard(
//       //                     context, "Sushi World", "35+ km", "5+ Item",
//       //                     "assets/sushi.png"),
//       //                 buildHorizontalCard(
//       //                     context, "Foodie's Delight", "55+ km",
//       //                     "11+ Item", "assets/foodie'sdelight.png"),
//       //               ],
//       //             ),
//       //           ),
//       //         ),
//       //       ),
//       //     ],
//       //   ),
//       // ),
//       //
//       // const SizedBox(height: 20,),
//
//       // Padding(padding: EdgeInsets.symmetric(horizontal: 10.0),
//       //   child: Image.asset('assets/discount_image1.png', width: 800,
//       //     height: 200,
//       //     fit: BoxFit.cover,),
//       //
//       // ),
//       //
//       // Container(
//       //   decoration: BoxDecoration(
//       //     color: Colors.white60,
//       //     border: Border(
//       //       top: BorderSide(
//       //         color: Colors.grey.shade100,
//       //         width: 1.0,
//       //       ),
//       //     ),
//       //   ),
//       //   child: Padding(
//       //     padding: const EdgeInsets.all(10.0),
//       //     child: Column(
//       //       crossAxisAlignment: CrossAxisAlignment.start,
//       //       children: [
//       //         // All Restaurants Section
//       //         Row(
//       //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       //           children: [
//       //             Text(
//       //               "All Restaurants",
//       //               style: TextStyle(
//       //                   fontSize: 18, fontWeight: FontWeight.bold),
//       //             ),
//       //             Flexible(
//       //               child: Text(
//       //                 "14 Restaurants near you",
//       //                 style: TextStyle(
//       //                     color: Colors.grey, fontSize: 14),
//       //                 overflow: TextOverflow
//       //                     .ellipsis, // Prevents overflow
//       //               ),
//       //             ),
//       //           ],
//       //         ),
//       //         SizedBox(height: 10),
//       //         // Spacing between sections
//       //
//       //         // Filters Section
//       //         Padding(
//       //           padding: const EdgeInsets.symmetric(horizontal: 10.0),
//       //           child: Wrap(
//       //             alignment: WrapAlignment.start,
//       //             spacing: 4, // Space between filter chips
//       //             runSpacing: 4, // Space for multi-line chips
//       //             children: [
//       //               buildIconChip(
//       //                 Icon(
//       //                   Icons.filter_1_outlined,
//       //                   color: Colors.orange,
//       //                 ),
//       //               ),
//       //               buildFilterChip("Top Rated"),
//       //               buildFilterChip("Discounted"),
//       //               buildFilterChip("Veg"),
//       //               buildFilterChip("Non-Veg"),
//       //             ],
//       //
//       //           ),
//       //         ),
//       //         SizedBox(height: 20),
//       //         // Spacing between filters and cards
//
//       // //                   // Restaurant Cards
//       // //                   ListView.builder(
//       // //                     shrinkWrap: true,
//       // //                     // Allow ListView to take only necessary space
//       // //                     physics: NeverScrollableScrollPhysics(),
//       // //                     // Disable scrolling since it's in SingleChildScrollView
//       // //                     itemCount: restaurants.length,
//       // //                     itemBuilder: (context, index) {
//       // //                       return buildRestaurantCard(
//       // //
//       // //                         context: context,
//       // //                         restaurant: restaurants[index],
//       // //                       );
//       // //                     },
//       // //                   ),
//       // //
//       // //                 ],
//       // //               ),
//       // //             ),
//       // //           ),
//       // //
//       // //         ],),
//       // //     ),
//       // //     ),
//       // //     Container(
//       // //
//       // //       height: 100,
//       // //       color: Colors.orange,
//       // //       child: Padding(
//       // //         padding: const EdgeInsets.symmetric(horizontal: 16),
//       // //         child: Row(
//       // //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       // //           crossAxisAlignment: CrossAxisAlignment.center,
//       // //           children: [
//       // //             Column(
//       // //               mainAxisAlignment: MainAxisAlignment.center,
//       // //               crossAxisAlignment: CrossAxisAlignment.start,
//       // //               children: [
//       // //                 const Text(
//       // //                   'Your Location',
//       // //                   style: TextStyle(fontSize: 14, color: Colors.white),
//       // //                 ),
//       // //                 GestureDetector(
//       // //                   onTap: () async {
//       // //                     // Navigate to the MapPage when the text is tapped
//       // //                     final gmap.LatLng? selectedLocation = await Navigator
//       // //                         .push(
//       // //                       context,
//       // //                       MaterialPageRoute(
//       // //                           builder: (
//       // //                               context) => const SetLocationScreen()),
//       // //                     );
//       // //
//       // //                     if (selectedLocation != null) {
//       // //                       // Save the selected location in SharedPreferences
//       // //                       SharedPreferences prefs = await SharedPreferences
//       // //                           .getInstance();
//       // //                       prefs.setDouble(
//       // //                           'latitude', selectedLocation.latitude);
//       // //                       prefs.setDouble(
//       // //                           'longitude', selectedLocation.longitude);
//       // //
//       // //                       // Fetch the Plus Code and the full address of the selected location
//       // //                       String locationInfo = await _getPlusCode(
//       // //                           selectedLocation.latitude,
//       // //                           selectedLocation.longitude);
//       // //
//       // //                       prefs.setString('location_info',
//       // //                           locationInfo); // Save formatted location info
//       // //
//       // //                       // Update the location text or perform any other necessary updates
//       // //                     }
//       // //                   },
//       // //                   child: FutureBuilder<String>(
//       // //                     future: _loadSavedLocation(), // Load saved location
//       // //                     builder: (context, snapshot) {
//       // //                       if (snapshot.connectionState ==
//       // //                           ConnectionState.waiting) {
//       // //                         return const Text(
//       // //                           'Choose Your Location',
//       // //                           style: TextStyle(
//       // //                               fontSize: 12, color: Colors.white),
//       // //                         );
//       // //                       }
//       // //
//       // //                       if (snapshot.hasData) {
//       // //                         return Text(
//       // //                           snapshot.data!,
//       // //                           // Display the formatted location from SharedPreferences
//       // //                           style: const TextStyle(
//       // //                               fontSize: 12, color: Colors.white),
//       // //                         );
//       // //                       } else {
//       // //                         return const Text(
//       // //                           'Choose Your Location',
//       // //                           style: TextStyle(
//       // //                               fontSize: 12, color: Colors.white),
//       // //                         );
//       // //                       }
//       // //                     },
//       // //                   ),
//       // //                 ),
//       // //
//       // //               ],
//       // //             ),
//       // //             IconButton(
//       // //               icon: const Icon(Icons.notifications, color: Colors.white),
//       // //               onPressed: () {},
//       // //             ),
//       // //           ],
//       // //         ),
//       // //       ),
//       // //     ),
//       // //     Positioned(
//       // //       top: 70,
//       // //       left: 16,
//       // //       right: 16,
//       // //       child: Container(
//       // //         decoration: BoxDecoration(
//       // //           color: Colors.white,
//       // //           borderRadius: BorderRadius.circular(80),
//       // //           boxShadow: [
//       // //             BoxShadow(
//       // //               color: Colors.black.withOpacity(0.1),
//       // //               blurRadius: 6,
//       // //               offset: const Offset(0, 3),
//       // //             ),
//       // //           ],
//       // //         ),
//       // //         child: TextField(
//       // //           decoration: InputDecoration(
//       // //             hintText: 'Are you hungry?',
//       // //             hintStyle: TextStyle(color: Colors.orange),
//       // //             filled: true,
//       // //             fillColor: Colors.white,
//       // //             prefixIcon: const Icon(Icons.search),
//       // //             border: OutlineInputBorder(
//       // //               borderRadius: BorderRadius.circular(80),
//       // //               borderSide: BorderSide.none,
//       // //             ),
//       // //           ),
//       // //         ),
//       // //       ),
//       // //     ),
//       // //   ],
//       // // ),
//       // bottomNavigationBar: BottomNavBar(
//       //   currentIndexbtmnav: _selectedIndex,
//       //   onTapbtmnav: _onTapNav,
//       // ),
//
//     );
//   }
//
//   Widget sectionTitle(String title) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(title,
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//           Icon(Icons.arrow_forward, color: Colors.orange),
//         ],
//       ),
//     );
//   }
//
//   Widget searchBar({
//     String hintText = 'Search your favorite food...',
//     EdgeInsetsGeometry padding = const EdgeInsets.symmetric(
//         horizontal: 12.0, vertical: 8.0),
//   }) {
//     return Positioned(
//       top: -10.0,
//       left: 0,
//       right: 0,
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 16.0),
//         padding: padding,
//         color: Colors.white,
//         width: MediaQuery
//             .of(context)
//             .size
//             .width * 0.75,
//         // Adjust width to make it smaller (75% of the screen width)
//         child: TextField(
//           decoration: InputDecoration(
//             hintText: hintText,
//             filled: true,
//             fillColor: Colors.white,
//             prefixIcon: const Icon(Icons.search),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(80),
//               borderSide: BorderSide.none,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _restaurantList({required BuildContext context}) {
//     // Reference to the list of restaurants from your data
//     List<models.Restaurant> restaurants = [
//       models.Restaurant(
//         name: 'The Royal Dine',
//         image: 'assets/restaurant.png',
//         rating: 4.8,
//         categories: [models.FoodCategory.Veg, models.FoodCategory.Italian],
//         foodItems: [
//           allFoodItems['Pizza'] ?? defaultFoodItem,
//           allFoodItems['Tandoori Chicken'] ?? defaultFoodItem,
//           allFoodItems['Biryani'] ?? defaultFoodItem,
//         ],
//         logo: 'assets/restaurantlogo/theroyaldinelogo.png',
//       ),
//       models.Restaurant(
//         name: 'Food Street',
//         image: 'assets/restaurant.png',
//         rating: 4.6,
//         categories: [models.FoodCategory.FastFood, models.FoodCategory.Veg],
//         foodItems: [
//           allFoodItems['Veg Burger'] ?? defaultFoodItem,
//           allFoodItems['Chicken Wings'] ?? defaultFoodItem,
//           allFoodItems['Sushi'] ?? defaultFoodItem,
//         ],
//         logo: 'assets/restaurantlogo/foodstreetlogo.png',
//       ),
//       models.Restaurant(
//         name: 'Hungry Puppets',
//         image: 'assets/hungrypuppets.png',
//         rating: 4.7,
//         categories: [models.FoodCategory.FastFood],
//         foodItems: [
//           allFoodItems['Veg Burger'] ?? defaultFoodItem,
//           allFoodItems['Tandoori Chicken'] ?? defaultFoodItem,
//           allFoodItems['Pizza'] ?? defaultFoodItem,
//         ],
//         logo: 'assets/restaurantlogo/hungrypuppetslogo.png',
//       ),
//     ];
//
//     return SizedBox(
//       height: 200,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: restaurants.length,
//         itemBuilder: (context, index) {
//           final restaurant = restaurants[index];
//
//           return restaurantCard(
//             image: restaurant.image,
//             name: restaurant.name,
//             rating: restaurant.rating,
//             categories: restaurant.categories,
//             foodItems: restaurant.foodItems,
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) =>
//                       rest_de.RestaurantDetailsPage(
//                         name: restaurant.name,
//                         image: restaurant.image,
//                         rating: restaurant.rating,
//                         foodItems: restaurant.foodItems,
//                       ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
//
//   Widget referralBanner() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Container(
//         height: 120,
//         decoration: BoxDecoration(
//           color: Colors.orangeAccent,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         padding: const EdgeInsets.all(16),
//         child: Row(
//           children: [
//             Icon(Icons.discount, color: Colors.white, size: 40),
//             const SizedBox(width: 10),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: const [
//                 Text(
//                   "Refer & Earn",
//                   style: TextStyle(fontSize: 18, color: Colors.white),
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   "Get 10% off on your next order",
//                   style: TextStyle(fontSize: 14, color: Colors.white),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
// // Today's Trend Widget
//   void _showFoodDetailsBottomSheet2(BuildContext context, models.FoodItem foodItem) {
//     List<String> selectedAddons = foodItem.addons;
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true, // Allow scrolling if necessary
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         int quantity = 1;
//         double price = foodItem.price ?? 0;
//         double totalAmount = price * quantity;
//
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return Container(
//               padding: const EdgeInsets.all(16.0),
//               decoration: const BoxDecoration(
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Expanded( // Wrap SingleChildScrollView with Expanded
//                     child: SingleChildScrollView(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // Your Row and other content here...
//                           Row(
//                             children: [
//                               ClipRRect(
//                                 borderRadius: BorderRadius.circular(15),
//                                 child: Image.asset(
//                                   foodItem.image,
//                                   height: 60,
//                                   width: 60,
//                                   fit: BoxFit.cover,
//                                   errorBuilder: (context, error, stackTrace) {
//                                     return const Center(child: Text('Image not found'));
//                                   },
//                                 ),
//                               ),
//                               const SizedBox(width: 10),
//                               // Food Name
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     foodItem.name,
//                                     style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                                   ),
//                                   Text(
//                                     "Restaurant Name", // Replace with actual restaurant name
//                                     style: const TextStyle(fontSize: 14, color: Colors.grey),
//                                   ),
//                                   const SizedBox(height: 5),
//                                   // Rating Stars (Placeholder)
//                                   Row(
//                                     children: List.generate(5, (index) {
//                                       return Icon(
//                                         index < foodItem.rating.round()
//                                             ? Icons.star
//                                             : Icons.star_border,
//                                         color: Colors.orange,
//                                         size: 18,
//                                       );
//                                     }),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 10),
//
//                           // Price Section
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               const Text("Price:", style: TextStyle(fontWeight: FontWeight.bold)),
//                               Text("\$${price.toStringAsFixed(2)}", style: const TextStyle(color: Colors.green)),
//                             ],
//                           ),
//                           const SizedBox(height: 10),
//
//                           // Description Section
//                           Text(
//                             foodItem.description,
//                             style: const TextStyle(color: Colors.grey),
//                           ),
//                           const SizedBox(height: 10),
//
//                           // Categories
//                           Text(
//                             "Categories: ${foodItem.categories.join(", ")}",
//                             style: const TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           const SizedBox(height: 10),
//
//                           // Addons Section
//                           const Text("Addons:", style: TextStyle(fontWeight: FontWeight.bold)),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               Checkbox(
//                                 value: foodItem.addons.contains("Pepsi"),
//                                 onChanged: (bool? selected) {
//                                   setState(() {
//                                     if (selected!) {
//                                       foodItem.addons.add("Pepsi");
//                                     } else {
//                                       foodItem.addons.remove("Pepsi");
//                                     }
//                                     totalAmount = (price * quantity) +
//                                         (foodItem.addons.contains("Pepsi") ? 2.5 : 0);
//                                   });
//                                 },
//                               ),
//                               const Text("Pepsi (+\$2.5)"),
//                               const SizedBox(width: 20),
//                               Checkbox(
//                                 value: foodItem.addons.contains("Extra Meat"),
//                                 onChanged: (bool? selected) {
//                                   setState(() {
//                                     if (selected!) {
//                                       foodItem.addons.add("Extra Meat");
//                                     } else {
//                                       foodItem.addons.remove("Extra Meat");
//                                     }
//                                     totalAmount = (price * quantity) +
//                                         (foodItem.addons.contains("Extra Meat") ? 3.0 : 0);
//                                   });
//                                 },
//                               ),
//                               const Text("Extra Meat (+\$3)"),
//                             ],
//                           ),
//                           const SizedBox(height: 10),
//
//                           // Total Amount Section
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               const Text("Total:", style: TextStyle(fontWeight: FontWeight.bold)),
//                               Text("\$${totalAmount.toStringAsFixed(2)}", style: const TextStyle(color: Colors.green)),
//                             ],
//                           ),
//                           const SizedBox(height: 10),
//
//                           // Quantity Selector and Order Button
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Row(
//                                 children: [
//                                   IconButton(
//                                     onPressed: () {
//                                       if (quantity > 1) {
//                                         setState(() {
//                                           quantity--;
//                                           totalAmount = (price * quantity) +
//                                               (foodItem.addons.contains("Pepsi") ? 2.5 : 0) +
//                                               (foodItem.addons.contains("Extra Meat") ? 3.0 : 0);
//                                         });
//                                       }
//                                     },
//                                     icon: const Icon(Icons.remove, color: Colors.red),
//                                   ),
//                                   Text(
//                                     quantity.toString(),
//                                     style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                                   ),
//                                   IconButton(
//                                     onPressed: () {
//                                       setState(() {
//                                         quantity++;
//                                         totalAmount = (price * quantity) +
//                                             (foodItem.addons.contains("Pepsi") ? 2.5 : 0) +
//                                             (foodItem.addons.contains("Extra Meat") ? 3.0 : 0);
//                                       });
//                                     },
//                                     icon: const Icon(Icons.add, color: Colors.green),
//                                   ),
//                                 ],
//                               ),
//                               ElevatedButton(
//                                 onPressed: () {
//                                   // Save order details and navigate to the place order screen
//                                   print("Added to cart: ${foodItem.name}, Quantity: $quantity, Total: \$${totalAmount.toStringAsFixed(2)}");
//
//                                   // Push to PlaceOrderPage
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => CheckoutPage(),
//                                     ),
//                                   );
//                                 },
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.orange,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                 ),
//                                 child: const Text("Order Now"),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   Widget todaysTrendWidget() {
//     return StatefulBuilder(
//       builder: (context, setState) {
//         ScrollController _scrollController = ScrollController();
//         double _progress = 0.0;
//
//         // Scroll listener to update progress as user scrolls
//         _scrollController.addListener(() {
//           double maxScroll = _scrollController.position.maxScrollExtent;
//           double currentScroll = _scrollController.position.pixels;
//           setState(() {
//             // Avoid division by zero if maxScroll is 0
//             _progress = (maxScroll == 0) ? 0.0 : currentScroll / maxScroll;
//           });
//         });
//
//         // Check if the device is in dark mode
//         bool isDarkMode = Theme
//             .of(context)
//             .brightness == Brightness.dark;
//
//         return Container(
//           height: 500, // Increased height for the container
//           padding: const EdgeInsets.all(16.0),
//           color: isDarkMode
//               ? Colors.black.withOpacity(
//               0.5) // Dark mode dark(50) (50% opacity black)
//               : Colors.orange[50], // Light background for light mode
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // "Today's Trend" section
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Text(
//                       "Today's Trend",
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: isDarkMode ? Colors.white : Colors
//                             .orange, // Text color based on theme
//                       ),
//                     ),
//                   ),
//                   Container(
//                     decoration: const BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.orange,
//                     ),
//                   ),
//                 ],
//               ),
//               Text(
//                 "Here's what you might like to taste",
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.normal,
//                   color: isDarkMode ? Colors.white : Colors.orange,
//                 ),
//               ),
//               // Horizontal list of popular foods (limit to 6 images)
//               SizedBox(
//                 height: 200,
//                 child: ListView.builder(
//                   controller: _scrollController,
//                   scrollDirection: Axis.horizontal,
//                   itemCount: 6, // Limit the number of images to 6
//                   itemBuilder: (context, index) {
//                     var foodItem = food_list.foodItems[index];
//                     return popularFoodCard(
//                       image: foodItem.image,
//                       name: foodItem.name,
//                       price: '\$${(foodItem.rating * 2).toStringAsFixed(2)}',
//                       hasDiscount: foodItem.rating > 4.7,
//                       ResName: "Hungry Puppets",
//                       foodItem: foodItem,
//                       context: context,
//                     );
//                   },
//                 ),
//               ),
//               const SizedBox(height: 10),
//               // Progress bar below the list (only 30% of screen width)
//               Container(
//                 width: MediaQuery
//                     .of(context)
//                     .size
//                     .width * 0.3, // 30% of screen width
//                 child: LinearProgressIndicator(
//                   value: _progress,
//                   backgroundColor: Colors.grey.shade300,
//                   // Inactive progress bar color
//                   valueColor: AlwaysStoppedAnimation<Color>(
//                       Colors.orange), // Orange progress color
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget popularFoodsList(BuildContext context) {
//     return SizedBox(
//       height: 200,
//       child: ListView(
//         scrollDirection: Axis.horizontal,
//         children: food_list.foodItems.map((foodItem) {
//           return popularFoodCard(
//             image: foodItem.image,
//             name: foodItem.name,
//             price: '\$${(foodItem.rating * 2).toStringAsFixed(2)}',
//             // Example price calculation
//             hasDiscount: foodItem.rating > 4.7,
//             ResName: "Hungry Puppets",
//             foodItem: foodItem,
//             context: context, // Directly pass the foodItem
//           );
//         }).toList(),
//       ),
//     );
//   }
//
//   Widget popularFoodCard({
//     List<models.FoodItem>? favoriteFoods,
//     Function(models.FoodItem)? updateFavorite,
//     required String image,
//     required String name,
//     required String price,
//     required bool hasDiscount,
//     required String ResName,
//     required models.FoodItem foodItem,
//     required BuildContext context, // Pass context to handle navigation
//   }) {
//     // Default to empty list and no-op updateFavorite function if not provided
//     favoriteFoods ??= []; // Default to empty list if null
//     updateFavorite ??= (models.FoodItem item) {}; // Default to a no-op function
//
//     return GestureDetector(
//       onTap: () {
//         _showFoodDetailsBottomSheet2(context, foodItem);
//       },
//       child: Container(
//         margin: const EdgeInsets.all(8.0),
//         width: 250,
//         height: 500,
//         child: Stack(
//           children: [
//             Column(
//               children: [
//                 Container(
//                   height: 120,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     image: DecorationImage(
//                       image: AssetImage(image),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   child: Stack(
//                     children: [
//                       // Discount Badge (Top-left)
//                       if (hasDiscount)
//                         Positioned(
//                           top: 8,
//                           left: 8,
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 6,
//                                 vertical: 4),
//                             decoration: BoxDecoration(
//                               color: Colors.orange,
//                               borderRadius: BorderRadius.circular(4),
//                             ),
//                             child: const Text(
//                               '10% Off',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                       // Add to Favorites Icon (Top-right)
//                       Positioned(
//                         top: 8,
//                         right: 8,
//                         child: GestureDetector(
//                           onTap: () {
//                             // Navigate to add_to_fav.dart and pass foodItem
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) =>
//                                     AddToFavPage(foodItem: foodItem),
//                               ),
//                             );
//                             print("$name added to favorites!");
//                           },
//                           child: CircleAvatar(
//                             radius: 16,
//                             backgroundColor: Colors.white.withOpacity(0.8),
//                             child: const Icon(
//                                 Icons.favorite_border, color: Colors.red),
//                           ),
//                         ),
//                       ),
//                       // Add Icon (Bottom-left)
//                       Positioned(
//                         bottom: 8,
//                         right: 8,
//                         child: GestureDetector(
//                           onTap: () {
//                             print("$name added!");
//                           },
//                           child: CircleAvatar(
//                             radius: 16,
//                             backgroundColor: Colors.white.withOpacity(0.8),
//                             child: const Icon(Icons.add, color: Colors.green),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   color: Colors.white,
//                   padding: const EdgeInsets.all(8.0),
//                   width: double.infinity,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         name,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//                       Text(
//                         price,
//                         style: const TextStyle(
//                           color: Colors.black54,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _showFoodDetailsBottomSheet(BuildContext context,
//       models.FoodItem foodItem) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true, // No scrolling
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         int quantity = 1;
//         // Convert the price to double using tryParse to safely handle conversion
//         double price = foodItem.price ?? 0;
//         double totalAmount = price * quantity;
//
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return Container(
//               height: MediaQuery
//                   .of(context)
//                   .size
//                   .height * 0.8, // 80% of the screen height
//               padding: const EdgeInsets.all(16.0),
//               decoration: const BoxDecoration(
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Food Image
//                   Center(
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(15),
//                       child: Image.asset(
//                         foodItem.image,
//                         height: 150,
//                         width: 150,
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, error, stackTrace) {
//                           return const Center(child: Text('Image not found'));
//                         },
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//
//                   // Food Name
//                   Text(
//                     foodItem.name,
//                     style: const TextStyle(
//                         fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//
//                   // Food Description
//                   if (foodItem.description.isNotEmpty)
//                     Padding(
//                       padding: const EdgeInsets.only(top: 5.0),
//                       child: Text(
//                         foodItem.description,
//                         style: const TextStyle(color: Colors.grey),
//                       ),
//                     ),
//
//                   const SizedBox(height: 10),
//
//                   // Nutrition Details
//                   if (foodItem.nutritionalDetails != null &&
//                       foodItem.nutritionalDetails!.isNotEmpty)
//                     Padding(
//                       padding: const EdgeInsets.only(top: 5.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text("Nutrition Facts", style: TextStyle(
//                               fontWeight: FontWeight.bold)),
//                           Text("Calories: ${foodItem
//                               .nutritionalDetails?['calories'] ?? 'N/A'}"),
//                           Text("Carbs: ${foodItem
//                               .nutritionalDetails?['carbs'] ?? 'N/A'}"),
//                           Text("Protein: ${foodItem
//                               .nutritionalDetails?['protein'] ?? 'N/A'}"),
//                           Text("Fat: ${foodItem.nutritionalDetails?['fat'] ??
//                               'N/A'}"),
//                         ],
//                       ),
//                     ),
//
//                   const SizedBox(height: 10),
//
//                   // Size Selection (assuming sizeOptions available)
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text("Size:",
//                           style: TextStyle(fontWeight: FontWeight.bold)),
//                       Row(
//                         children: foodItem.sizeOptions.map((size) {
//                           return Row(
//                             children: [
//                               Radio<String>(
//                                 value: size,
//                                 groupValue: foodItem.sizeOptions.first,
//                                 // Replace with actual selected size
//                                 onChanged: (String? value) {
//                                   setState(() {
//                                     double totalAmount = (foodItem.price ?? 0) *
//                                         quantity;
//                                   });
//                                 },
//                               ),
//                               Text(size),
//                             ],
//                           );
//                         }).toList(),
//                       ),
//                     ],
//                   ),
//
//                   const SizedBox(height: 10),
//
//                   // Addons Section
//                   const Text(
//                       "Addons:", style: TextStyle(fontWeight: FontWeight.bold)),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Checkbox(
//                         value: foodItem.addons.contains("Pepsi"),
//                         onChanged: (bool? selected) {
//                           setState(() {
//                             if (selected!) {
//                               foodItem.addons.add("Pepsi");
//                             } else {
//                               foodItem.addons.remove("Pepsi");
//                             }
//                             totalAmount = (foodItem.price ?? 0) * quantity +
//                                 (foodItem.addons.contains("Pepsi") ? 2.5 : 0);
//                           });
//                         },
//                       ),
//                       const Text("Pepsi (+\$2.5)"),
//                       const SizedBox(width: 20),
//                       Checkbox(
//                         value: foodItem.addons.contains("Extra Meat"),
//                         onChanged: (bool? selected) {
//                           setState(() {
//                             if (selected!) {
//                               foodItem.addons.add("Extra Meat");
//                             } else {
//                               foodItem.addons.remove("Extra Meat");
//                             }
//                             totalAmount = (foodItem.price) * quantity +
//                                 (foodItem.addons.contains("Extra Meat")
//                                     ? 3.0
//                                     : 0);
//                           });
//                         },
//                       ),
//                       const Text("Extra Meat (+\$3)"),
//                     ],
//                   ),
//
//                   const SizedBox(height: 10),
//
//                   // Total Amount
//                   Padding(
//                     padding: const EdgeInsets.only(top: 5.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text("Total:", style: TextStyle(
//                             fontWeight: FontWeight.bold)),
//                         Text("\$${totalAmount.toStringAsFixed(2)}",
//                             style: const TextStyle(color: Colors.green)),
//                       ],
//                     ),
//                   ),
//
//                   const SizedBox(height: 10),
//
//                   // Quantity Selector
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           IconButton(
//                             onPressed: () {
//                               if (quantity > 1) {
//                                 setState(() {
//                                   quantity--;
//                                   totalAmount =
//                                       (foodItem.price ?? 0) * quantity +
//                                           (foodItem.addons.contains("Pepsi")
//                                               ? 2.5
//                                               : 0) +
//                                           (foodItem.addons.contains(
//                                               "Extra Meat") ? 3.0 : 0);
//                                 });
//                               }
//                             },
//                             icon: const Icon(Icons.remove, color: Colors.red),
//                           ),
//                           Text(
//                             quantity.toString(),
//                             style: const TextStyle(
//                                 fontSize: 18, fontWeight: FontWeight.bold),
//                           ),
//                           IconButton(
//                             onPressed: () {
//                               setState(() {
//                                 quantity++;
//                                 totalAmount = (double.tryParse(
//                                     foodItem.price as String) ?? 0 * quantity) +
//                                     (foodItem.addons.contains("Pepsi")
//                                         ? 2.5
//                                         : 0) +
//                                     (foodItem.addons.contains("Extra Meat")
//                                         ? 3.0
//                                         : 0);
//                               });
//                             },
//                             icon: const Icon(Icons.add, color: Colors.green),
//                           ),
//                         ],
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           String uid = FirebaseAuth.instance.currentUser!.uid;
//                           Navigator.push(context, MaterialPageRoute(
//                               builder: (context) =>
//                                   AddToCartPage(
//                                       foodItem: foodItem, quantity: quantity)));
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.orange,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                         child: const Text("Add to Cart"),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   Widget _buildFoodCard({
//     required String imagePath,
//     required String foodName,
//     required double rating,
//     required models.FoodItem foodItem,
//     required BuildContext context,
//   }) {
//     return GestureDetector(
//       onTap: () {
//         _showFoodDetailsBottomSheet(context, foodItem);
//       },
//       child: Container(
//         width: 250,
//         height: 320,
//         margin: const EdgeInsets.only(left: 16.0),
//         padding: const EdgeInsets.all(8.0),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(10),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.shade200,
//               blurRadius: 5,
//               spreadRadius: 2,
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // Image Container with Icons
//             Stack(
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(10),
//                   child: Image.asset(
//                     imagePath,
//                     height: 150,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                     errorBuilder: (context, error, stackTrace) {
//                       return const Center(child: Text('Image not found'));
//                     },
//                   ),
//                 ),
//                 // Favorite Icon (Top Right)
//                 Positioned(
//                   top: 8,
//                   right: 8,
//                   child: GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               AddToFavPage(foodItem: foodItem),
//                         ),
//                       );
//                       print("$foodName added to favorites!");
//                     },
//                     child: CircleAvatar(
//                       radius: 16,
//                       backgroundColor: Colors.white.withOpacity(0.8),
//                       child: const Icon(
//                           Icons.favorite_border, color: Colors.red),
//                     ),
//                   ),
//                 ),
//                 // Add Icon (Bottom Right)
//                 Positioned(
//                   bottom: 8,
//                   right: 8,
//                   child: GestureDetector(
//                     onTap: () {
//                       print("$foodName added to cart!");
//                       // You can implement add to cart logic here
//                     },
//                     child: CircleAvatar(
//                       radius: 16,
//                       backgroundColor: Colors.white.withOpacity(0.8),
//                       child: const Icon(Icons.add, color: Colors.green),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             // Food Name
//             Text(
//               foodName,
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 4),
//             // Rating Row
//             Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Icon(Icons.star, size: 16, color: Colors.orange),
//                 const SizedBox(width: 4),
//                 Text(
//                   rating.toString(),
//                   style: const TextStyle(fontSize: 14, color: Colors.grey),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Widget _buildFoodCard({
//   //   required String imagePath,
//   //   required String foodName,
//   //   required double rating,
//   //   required FoodItem foodItem,
//   //   required BuildContext context,
//   // }) {
//   //   return GestureDetector(
//   //     onTap: () {
//   //       _showFoodDetailsBottomSheet(context, foodItem);
//   //     },
//   //     child: Container(
//   //       width: 120,
//   //       margin: const EdgeInsets.only(left: 16.0),
//   //       padding: const EdgeInsets.all(8.0),
//   //       decoration: BoxDecoration(
//   //         color: Colors.white,
//   //         borderRadius: BorderRadius.circular(10),
//   //         boxShadow: [
//   //           BoxShadow(
//   //             color: Colors.grey.shade200,
//   //             blurRadius: 5,
//   //             spreadRadius: 2,
//   //           ),
//   //         ],
//   //       ),
//   //       child: Column(
//   //         crossAxisAlignment: CrossAxisAlignment.center,
//   //         children: [
//   //           Image.asset(
//   //             imagePath,
//   //             height: 150,
//   //             width: 150,
//   //             fit: BoxFit.cover,
//   //             errorBuilder: (context, error, stackTrace) {
//   //               return const Center(child: Text('Image not found'));
//   //             },
//   //           ),
//   //           const SizedBox(height: 8),
//   //           Text(
//   //             foodName,
//   //             style: const TextStyle(
//   //               fontSize: 16,
//   //               fontWeight: FontWeight.bold,
//   //             ),
//   //             textAlign: TextAlign.center,
//   //           ),
//   //           const SizedBox(height: 4),
//   //           Row(
//   //             mainAxisSize: MainAxisSize.min,
//   //             children: [
//   //               const Icon(Icons.star, size: 16, color: Colors.orange),
//   //               const SizedBox(width: 4),
//   //               Text(
//   //                 rating.toString(),
//   //                 style: const TextStyle(fontSize: 14, color: Colors.grey),
//   //               ),
//   //             ],
//   //           ),
//   //         ],
//   //       ),
//   //     ),
//   //   );
//   // }
//
//   Widget _buildCuisineCard(String imagePath, String cuisine) {
//     return GestureDetector(
//       onTap: () {
//         // Navigate to the CuisineDetails screen when the card is tapped
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) =>
//                 RestaurantCategoryScreen(), // Pass the cuisine name
//           ),
//         );
//       },
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 16.0), // Spacing between items
//         padding: const EdgeInsets.all(16.0),
//         decoration: BoxDecoration(
//           color: Colors.orange[100],
//           // Light orange background for the container
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Stack(
//           alignment: Alignment.bottomCenter,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Container(
//                   width: 80,
//                   height: 80,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Colors.white,
//                     // Background color for the image container
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.1),
//                         blurRadius: 8,
//                         spreadRadius: 2,
//                       ),
//                     ],
//                   ),
//                   child: ClipOval(
//                     child: Image.asset(
//                       imagePath,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 // Cuisine name with white background
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 8.0, vertical: 4.0),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(4.0),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.1),
//                         blurRadius: 4,
//                         spreadRadius: 1,
//                       ),
//                     ],
//                   ),
//                   child: Text(
//                     cuisine,
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget restaurantCard({
//     required String image,
//     required String name,
//     required double rating,
//     required List<models.FoodCategory> categories,
//     required List<models.FoodItem> foodItems,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap, // Handle tap event
//       child: Container(
//         margin: const EdgeInsets.all(8.0),
//         width: 250,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           image: DecorationImage(
//             image: AssetImage(image),
//             fit: BoxFit.cover,
//             colorFilter: ColorFilter.mode(
//               Colors.black.withOpacity(0.3),
//               BlendMode.darken,
//             ),
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.end,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 name,
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 '⭐ $rating',
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 14,
//                 ),
//               ),
//               const SizedBox(height: 6),
//               Text(
//                 categories.map((category) => category.name).join(', '),
//                 style: const TextStyle(
//                   fontSize: 12,
//                   color: Colors.white70,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHighlightedSection() {
//     List<Map<String, String>> saleItems = [
//       {
//         'image': 'assets/discount_image1.png',
//         'text': 'Summer Blowout Sale\n50% OFF',
//         'name': 'Hungry Puppets',
//       },
//       {
//         'image': 'assets/discount_image2.png',
//         'text': 'Winter Clearance Sale\n70% OFF',
//         'name': 'Café Monarch',
//       },
//       {
//         'image': 'assets/discount_image3.png',
//         'text': 'Buy One Get One Free\nLimited Time Offer',
//         'name': 'Mini Kebab',
//       },
//       // Add more items here
//     ];
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16.0),
//           child: Text('Highlights for you',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//         ),
//         const Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16.0),
//           child: Text('See our most popular restaurant and foods',
//               style: TextStyle(color: Colors.grey)),
//         ),
//         const SizedBox(height: 40),
// // Carousel Slider Section
//         CarouselSlider(
//           items: saleItems.map((item) {
//             return GestureDetector(
//               onTap: () {
//                 // Navigate to the RestaurantDetailsPage when an item is tapped
//                 String restaurantName = item['name']!;
//                 String restaurantImage = item['image']!;
//                 double restaurantRating = 4.5; // You can set a static rating or get it dynamically
//                 Restaurant restaurant = item['name'] as Restaurant;
//                 // Pass the foodItems list from food_list.dart
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) =>
//                         rest_de.RestaurantDetailsPage(
//                           name: restaurantName,
//                           image: restaurantImage,
//                           rating: restaurantRating,
//                           foodItems: restaurant.foodItems,
//                         ),
//                   ),
//                 );
//               },
//               child: Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 8.0),
//                 padding: const EdgeInsets.all(16.0),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.9),
//                   borderRadius: BorderRadius.circular(10),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.shade200,
//                       blurRadius: 5,
//                       spreadRadius: 2,
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Image.asset(
//                       item['image']!,
//                       height: 150,
//                       width: double.infinity,
//                       fit: BoxFit.cover,
//                       errorBuilder: (context, error, stackTrace) {
//                         return const Center(child: Text('Image not found'));
//                       },
//                     ),
//                     const SizedBox(height: 10),
//                     Text(
//                       item['text']!,
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }).toList(),
//           options: CarouselOptions(
//             height: 300,
//             autoPlay: true,
//             enlargeCenterPage: true,
//             aspectRatio: 16 / 9,
//             viewportFraction: 0.8,
//             enableInfiniteScroll: true,
//             autoPlayInterval: const Duration(seconds: 3),
//           ),
//         ),
//
//
//       ],
//     );
//   }
//

//   Widget buildIconChip(Icon icon) {
//     return Chip(label: icon, backgroundColor: Colors.white,);
//   }
//
//   Widget buildFilterChip(String label) {
//     return Chip(
//       label: Text(label, style: TextStyle(
//           color: Colors.grey, fontWeight: FontWeight.normal, fontSize: 10),),
//       backgroundColor: Colors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(9),
//         side: BorderSide(color: Colors.grey),
//       ),
//     );
//   }
//
//   Widget buildRestaurantCard({
//     required BuildContext context,
//     required Restaurant restaurant,
//   }) {
//     bool isDarkMode = Theme
//         .of(context)
//         .brightness == Brightness.dark;
//
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) =>
//                 rest_de.RestaurantDetailsPage(
//                   name: restaurant.name,
//                   image: restaurant.image,
//                   rating: restaurant.rating,
//                   foodItems: restaurant.foodItems,
//                 ),
//           ),
//         );
//       },
//       child: Card(
//         margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//         elevation: 2,
//         color: isDarkMode ? Colors.grey[900] : Colors.white,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         child: Stack(
//           alignment: Alignment.center,
//           children: [
//             Column(
//               children: [
//                 ClipRRect(
//                   borderRadius: const BorderRadius.vertical(
//                       top: Radius.circular(10)),
//                   child: Container(
//                     width: MediaQuery
//                         .of(context)
//                         .size
//                         .width * 0.9,
//                     height: MediaQuery
//                         .of(context)
//                         .size
//                         .height * 0.2,
//                     decoration: BoxDecoration(
//                       image: DecorationImage(
//                         image: AssetImage(restaurant.image),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: isDarkMode ? Colors.black54 : Colors.white,
//                     borderRadius: const BorderRadius.vertical(
//                         bottom: Radius.circular(10)),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         restaurant.name,
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: isDarkMode ? Colors.white : Colors.black,
//                         ),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       const SizedBox(height: 5),
//                       Row(
//                         children: [
//                           const Icon(
//                               Icons.star, color: Colors.orange, size: 16),
//                           const SizedBox(width: 5),
//                           Text(
//                             "${restaurant.rating}",
//                             style: TextStyle(color: isDarkMode
//                                 ? Colors.white
//                                 : Colors.black),
//                           ),
//                           const Spacer(),
//                           const Icon(
//                               Icons.access_time, color: Colors.grey, size: 16),
//                           const SizedBox(width: 5),
//                           Text(
//                             "30-40 min",
//                             style: TextStyle(color: isDarkMode
//                                 ? Colors.white70
//                                 : Colors.black54),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 5),
//                       Text(
//                         "563.83 km",
//                         style: TextStyle(
//                             color: isDarkMode ? Colors.white70 : Colors.grey),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             Positioned(
//               top: MediaQuery
//                   .of(context)
//                   .size
//                   .height * 0.18 -20,
//               child: Container(
//                 width: 70,
//                 height: 80,
//                 decoration: BoxDecoration(
//                   color: isDarkMode ? Colors.black87 : Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black26,
//                       blurRadius: 5,
//                       spreadRadius: 2,
//                     ),
//                   ],
//                 ),
//                 padding: const EdgeInsets.all(5),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(10),
//                   child: Image.asset(
//                     restaurant.logo,
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// void showFoodPopup(BuildContext context, models.FoodItem foodItem) {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: Colors.transparent,
//     builder: (context) {
//       return Container(
//         height: MediaQuery.of(context).size.height / 2, // Half of the screen
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(20),
//             topRight: Radius.circular(20),
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Food Image
//               Image.asset(
//                 foodItem.image, // Image from the FoodItem object
//                 width: 60,
//                 height: 60,
//                 fit: BoxFit.cover,
//               ),
//               SizedBox(width: 16),
//               // Food details
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     foodItem.name, // Food Name from FoodItem object
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   // Assuming description can be a static or dynamic text
//                   Text(
//                     'Delicious and freshly made with love!', // Use a description or modify
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey,
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     'Rating: ${foodItem.rating}', // Rating from FoodItem
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//               Spacer(),
//               // Order button
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 16.0),
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.orange,
//                     minimumSize: Size(120, 40),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                   ),
//                   onPressed: () {
//                     // Order button action
//                     print('Order button pressed for ${foodItem.name}');
//                   },
//                   child: Text('Order'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }
//
