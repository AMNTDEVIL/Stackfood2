import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:food/models.dart' as models;
import 'package:food/widgets/BottomNavBar.dart';
import 'package:food/widgets/not_logged_in_display.dart';
import 'package:food/homepage.dart';
import 'package:food/login.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> with SingleTickerProviderStateMixin {
  final user = FirebaseAuth.instance.currentUser;
  int _currentIndex = 1;
  bool _isLoggedIn = false;
  List<models.FoodItem> favoriteFoodItems = [];
  List<models.Restaurant> favoriteRestaurants = [];
  late TabController _tabController;

  // Fetch favorite restaurants
  Future<void> _fetchFavoriteRestaurants() async {
    try {
      if (user == null) {
        print("No authenticated user found.");
        return;
      }

      String userId = user!.uid;
      QuerySnapshot restaurantSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favorites_restaurants')
          .get();

      if (restaurantSnapshot.docs.isEmpty) {
        print("No favorite restaurants found.");
        setState(() {
          favoriteRestaurants = [];
        });
        return;
      }

      List<models.Restaurant> fetchedRestaurants = restaurantSnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>?;

        if (data == null || !data.containsKey('name')) {
          return null;
        }

        return models.Restaurant(
          name: data['name'] ?? "Unknown",
          image: data['image'] ?? "",
          rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
          logo: data['logo'] ?? "",
          categories: (data['categories'] as List?)?.map((e) {
            return models.FoodCategory.values.firstWhere(
                  (category) => category.toString().split('.').last == e,
              orElse: () => models.FoodCategory.Veg,  // Default to Veg if no match is found
            );
          }).toList() ?? [],
          foodItems: [], // You can modify this to load food items if needed
        );
      }).whereType<models.Restaurant>().toList();

      setState(() {
        favoriteRestaurants = fetchedRestaurants;
      });
    } catch (e, stacktrace) {
      print("Error fetching favorite restaurants: $e");
      print(stacktrace);
    }
  }

  // Fetch food items from favorites
  Future<void> _fetchFavorites() async {
    try {
      if (user == null) return;

      String userId = user!.uid;
      QuerySnapshot foodSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .get();

      List<models.FoodItem> fetchedFoodItems = foodSnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>?;

        return models.FoodItem(
          name: data?['name'] ?? "Unknown",
          image: data?['image'] ?? "",
          rating: (data?['rating'] as num?)?.toDouble() ?? 0.0,
          price: data?['price'] ?? 0,
          categories: (data?['categories'] as List?)?.map(
                (e) => models.FoodCategory.values.firstWhere(
                  (c) => c.toString().split('.').last == e,
              orElse: () => models.FoodCategory.Veg,
            ),
          ).toList() ?? [],
          isFavorite: true,
          sizeOptions: [],
          addons: [],
          allergicIngredients: [],
          description: data?['description'] ?? "",
        );
      }).whereType<models.FoodItem>().toList();

      setState(() {
        favoriteFoodItems = fetchedFoodItems;
      });
    } catch (e, stacktrace) {
      print("Error fetching favorites: $e");
      print(stacktrace);
    }
  }

  // Function to toggle favorite status for food items
  Future<void> _toggleFavoriteFoodItem(models.FoodItem foodItem) async {
    try {
      if (user == null) return;

      String userId = user!.uid;
      DocumentReference docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(foodItem.name); // Use food name as document ID or unique ID

      bool isCurrentlyFavorite = favoriteFoodItems.contains(foodItem);
      if (isCurrentlyFavorite) {
        await docRef.delete(); // Remove from Firestore
        setState(() {
          favoriteFoodItems.remove(foodItem); // Remove from list
        });
      } else {
        await docRef.set({
          'name': foodItem.name,
          'image': foodItem.image,
          'rating': foodItem.rating,
          'price': foodItem.price,
          'categories': foodItem.categories.map((e) => e.toString().split('.').last).toList(),
          'description': foodItem.description,
        }); // Add to Firestore
        setState(() {
          favoriteFoodItems.add(foodItem); // Add to list
        });
      }
    } catch (e) {
      print("Error toggling favorite: $e");
    }
  }

  // Toggle favorite restaurant status
  Future<void> _toggleFavoriteRestaurant(models.Restaurant restaurant) async {
    try {
      if (user == null) return;

      String userId = user!.uid;
      DocumentReference docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favorites_restaurants')
          .doc(restaurant.name); // Use restaurant name as document ID

      bool isCurrentlyFavorite = favoriteRestaurants.contains(restaurant);
      if (isCurrentlyFavorite) {
        await docRef.delete(); // Remove from Firestore
        setState(() {
          favoriteRestaurants.remove(restaurant); // Remove from list
        });
      } else {
        await docRef.set({
          'name': restaurant.name,
          'image': restaurant.image,
          'rating': restaurant.rating,
          'categories': restaurant.categories.map((e) => e.toString().split('.').last).toList(),
        }); // Add to Firestore
        setState(() {
          favoriteRestaurants.add(restaurant); // Add to list
        });
      }
    } catch (e) {
      print("Error toggling favorite restaurant: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isLoggedIn = prefs.getBool('isLoggedIn');
    setState(() {
      _isLoggedIn = isLoggedIn ?? false;
    });

    if (_isLoggedIn) {
      await _fetchFavorites();
      await _fetchFavoriteRestaurants();
      setState(() {
        _tabController = TabController(length: 2, vsync: this);
      });
    } else {
      setState(() {
        _tabController = TabController(length: 2, vsync: this);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorites"),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }else{
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage(changeLanguage: (Locale locale) {  },)),
      );
    }
          },
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: "Food Items"),
            Tab(text: "Restaurants"),
          ],
        ),
      ),
      body: _isLoggedIn
          ? TabBarView(
        controller: _tabController,
        children: [
          // Food Items Tab
          favoriteFoodItems.isNotEmpty
              ? ListView.builder(
            itemCount: favoriteFoodItems.length,
            itemBuilder: (context, index) {
              final foodItem = favoriteFoodItems[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: foodItem.image.isNotEmpty
                      ? Image.asset(foodItem.image, width: 50, height: 50, fit: BoxFit.cover)
                      : Icon(Icons.fastfood, size: 50, color: Colors.grey),
                  title: Text(foodItem.name),
                  subtitle: Text("\$${foodItem.price}"),
                  trailing: IconButton(
                    icon: Icon(
                      foodItem.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: foodItem.isFavorite ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      _toggleFavoriteFoodItem(foodItem);
                    },
                  ),
                ),
              );
            },
          )
              : Center(child: Text("No favorite food items added yet.")),

          // Restaurants Tab
          favoriteRestaurants.isNotEmpty
              ? ListView.builder(
            itemCount: favoriteRestaurants.length,
            itemBuilder: (context, index) {
              final restaurant = favoriteRestaurants[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: restaurant.image.isNotEmpty
                      ? Image.asset(restaurant.image, width: 50, height: 50, fit: BoxFit.cover)
                      : Icon(Icons.restaurant, size: 50, color: Colors.grey),
                  title: Text(restaurant.name),
                  subtitle: Text("Rating: ${restaurant.rating}"),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      _toggleFavoriteRestaurant(restaurant);
                    },
                  ),
                ),
              );
            },
          )
              : Center(child: Text("No favorite restaurants added yet.")),
        ],
      )
          : LoginPrompt(
        imagePath: 'assets/fav.png',
        mainText: 'You are not logged in',
        descriptionText: 'Login to see your favorite items',
        buttonText: 'Login to Continue',
        targetPage: LoginPage(),
      ),
    );
  }
}
