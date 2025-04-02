// import 'package:flutter/material.dart';
// import 'package:food/models.dart' as models;
// import 'package:food/widgets/restaurant_details.dart';
//
// // ✅ Declare restaurantList globally
// List<models.Restaurant> restaurantList = [
//   models.Restaurant(
//     name: "Mini Kebab",
//     image: "assets/minikebab.png",
//     rating: 4.5,
//     foodItems: [],
//   ),
//   models.Restaurant(
//     name: "Red Cliff",
//     image: "assets/redcliff.png",
//     rating: 4.7,
//     foodItems: [],
//   ),
//   models.Restaurant(
//     name: "Hungry Puppets",
//     image: "assets/hungrypuppets.png",
//     rating: 4.6,
//     foodItems: [],
//   ),
//   models.Restaurant(
//     name: "Café Monarch",
//     image: "assets/cafemonarch.png",
//     rating: 5.0,
//     foodItems: [],
//   ),
//   models.Restaurant(
//     name: "The Capital Grill",
//     image: "assets/capitalgrill.png",
//     rating: 4.8,
//     foodItems: [],
//   ),
// ];
//
// class RestaurantPage3 extends StatelessWidget {
//   final List<models.Restaurant> restaurants;
//
//   const RestaurantPage3({Key? key, required this.restaurants}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     double screenHeight = MediaQuery.of(context).size.height;
//
//     return Scaffold(
//       appBar: AppBar(title: Text("Restaurants"), backgroundColor: Colors.orange),
//       body: restaurants.isEmpty
//           ? Center(child: Text("No restaurants available"))
//           : ListView.builder(
//         itemCount: restaurants.length,
//         itemBuilder: (context, index) {
//           final restaurant = restaurants[index];
//
//           return Column(
//             children: [
//               Container(
//                 width: double.infinity, // Full width
//                 height: screenHeight * 0.13, // Slightly smaller height
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(10),
//                   boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
//                 ),
//                 child: Row(
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => RestaurantDetailsPage(
//                               name: restaurant.name,
//                               image: restaurant.image,
//                               rating: restaurant.rating,
//                               foodItems: restaurant.foodItems,
//                             ),
//                           ),
//                         );
//                       },
//                       child: Container(
//                         width: screenHeight * 0.13, // Match image height
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           image: DecorationImage(
//                             image: AssetImage(restaurant.image),
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: Padding(
//                         padding: EdgeInsets.all(12),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(restaurant.name,
//                                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                             SizedBox(height: 6),
//                             Text("Rating: ${restaurant.rating}",
//                                 style: TextStyle(color: Colors.grey)),
//                             Text("Items: ${restaurant.foodItems.length}+",
//                                 style: TextStyle(color: Colors.grey)),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 10), // More space between items
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
