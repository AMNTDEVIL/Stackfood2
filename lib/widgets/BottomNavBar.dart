import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food/addtocart.dart';
import 'package:food/favorites.dart';
import 'package:food/orders.dart';
import 'package:food/settings.dart';
import 'package:food/homepage.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndexbtmnav;
  final Function(int) onTapbtmnav;

  const BottomNavBar({
    Key? key,
    required this.currentIndexbtmnav,
    required this.onTapbtmnav,
  }) : super(key: key);

  Future<String?> _getUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80, // Adjust the height for accommodating the "pop-out" button
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: BottomNavigationBar(
              currentIndex: currentIndexbtmnav,
              selectedItemColor: Colors.orange,
              unselectedItemColor: Colors.grey,
              backgroundColor: Colors.white,
              onTap: (index) {
                onTapbtmnav(index);

                if (index == 0 && currentIndexbtmnav != 0) {
                  Navigator.pushReplacementNamed(context, '/home');
                } else if (index == 1 && currentIndexbtmnav != 1) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => FavoritesPage()),
                  );
                } else if (index == 2) {
                  _navigateToCart(context); // Refactored to handle navigation
                } else if (index == 3 && currentIndexbtmnav != 3) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MyOrdersPage()),
                  );
                } else if (index == 4 && currentIndexbtmnav != 4) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsPage()),
                  );
                }
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
                BottomNavigationBarItem(
                  icon: SizedBox(), // Placeholder for the popped-out button
                  label: '',
                ),
                BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Orders'),
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
              ],
            ),
          ),
          Positioned(
            top: -20, // Adjust the "pop-out" position
            left: MediaQuery.of(context).size.width * 0.5 - 28, // Center align
            child: GestureDetector(
              onTap: () {
                _navigateToCart(context); // Refactored to handle navigation
              },
              child: Container(
                height: 56,
                width: 56,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      spreadRadius: 2,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(Icons.shopping_cart, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // A method to handle navigation to the CartScreen
  Future<void> _navigateToCart(BuildContext context) async {
    String? userId = await _getUserId();
    if (userId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CartScreen(userId: userId)),
      );
    } else {
      // Handle the case when userId is null (e.g., user is not logged in)
      // Optionally show an error message or redirect to login page
      print('User not logged in');
    }
  }
}
