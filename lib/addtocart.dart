import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food/widgets/food_list.dart';
import 'models.dart';

class CartScreen extends StatefulWidget {
  final String userId;

  CartScreen({required this.userId});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _extraPackaging = false;
  bool _hasCutlery = false;
  bool _showUnavailableModal = false;

  double get extraPackagingPrice => _extraPackaging ? 2.0 : 0.0; // Price for extra packaging
  double get cutleryPrice => _hasCutlery ? 1.0 : 0.0; // Price for cutlery

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Cart"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('cart')
            .doc(widget.userId)
            .collection('items')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("Your cart is empty"));
          }

          var cartItems = snapshot.data!.docs;
          double subtotal = 0;

          // Calculate the subtotal for all cart items
          for (var item in cartItems) {
            subtotal += item['price'] * item['quantity'];
          }

          // Include extra options in the subtotal
          subtotal += extraPackagingPrice;
          subtotal += cutleryPrice;

          return Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Column(
                      children: cartItems.map((item) => CartItem(item: item)).toList(),
                    ),
                    SizedBox(height: 20),

                    // "You May Also Like!" Section
                    RecommendedFoodCarousel(userId: widget.userId),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Extra Packaging Option
                          Row(
                            children: [
                              Checkbox(
                                value: _extraPackaging,
                                onChanged: (value) {
                                  setState(() {
                                    _extraPackaging = value!;
                                  });
                                },
                              ),
                              Text('Extra Packaging (\$2)'),
                            ],
                          ),
                          // Cutlery Option
                          Row(
                            children: [
                              Text('Add Cutlery (\$1)'),
                              Switch(
                                value: _hasCutlery,
                                onChanged: (value) {
                                  setState(() {
                                    _hasCutlery = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Unavailable Products Section
                    if (_showUnavailableModal)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text('If any product is not available'),
                            SizedBox(height: 10),
                            TextField(
                              decoration: InputDecoration(hintText: 'Product Name'),
                            ),
                            SizedBox(height: 10),
                            TextField(
                              decoration: InputDecoration(hintText: 'Quantity'),
                            ),
                            SizedBox(height: 10),
                            TextField(
                              decoration: InputDecoration(hintText: 'Price'),
                            ),
                            SizedBox(height: 10),
                            TextField(
                              decoration: InputDecoration(hintText: 'Reason'),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                // Apply functionality
                              },
                              child: Text('Apply'),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              // Display the Cart Summary (Total)
              CartSummary(subtotal: subtotal),
            ],
          );
        },
      ),
    );
  }
}

class CartItem extends StatelessWidget {
  final QueryDocumentSnapshot item;

  CartItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Image.asset(item['image'], width: 60, height: 60, fit: BoxFit.cover),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['name'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text("\$${item['price']}", style: TextStyle(fontSize: 14, color: Colors.orange)),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove_circle, color: Colors.red),
                  onPressed: () => updateQuantity(item.id, item['quantity'] - 1),
                ),
                Text("${item['quantity']}", style: TextStyle(fontSize: 16)),
                IconButton(
                  icon: Icon(Icons.add_circle, color: Colors.green),
                  onPressed: () => updateQuantity(item.id, item['quantity'] + 1),
                ),
              ],
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => deleteItem(item.id),
            ),
          ],
        ),
      ),
    );
  }

  void updateQuantity(String itemId, int newQuantity) {
    if (newQuantity <= 0) {
      deleteItem(itemId);
    } else {
      FirebaseFirestore.instance.collection('cart').doc(itemId).update({'quantity': newQuantity});
    }
  }

  void deleteItem(String itemId) {
    FirebaseFirestore.instance.collection('cart').doc(itemId).delete();
  }
}

class CartSummary extends StatelessWidget {
  final double subtotal;

  CartSummary({required this.subtotal});

  @override
  Widget build(BuildContext context) {
    double freeDeliveryThreshold = 3000;
    double remainingForFreeDelivery = (freeDeliveryThreshold - subtotal).clamp(0, freeDeliveryThreshold);

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(
        children: [
          if (remainingForFreeDelivery > 0)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.local_shipping, color: Colors.orange),
                SizedBox(width: 5),
                Text("\$${remainingForFreeDelivery.toStringAsFixed(2)} more for free delivery", style: TextStyle(color: Colors.orange)),
              ],
            ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Subtotal", style: TextStyle(fontSize: 16)),
              Text("\$${subtotal.toStringAsFixed(2)}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, minimumSize: Size(double.infinity, 50)),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Confirm Delivery Details", style: TextStyle(fontSize: 18, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class RecommendedFoodCarousel extends StatelessWidget {
  final String userId;

  RecommendedFoodCarousel({required this.userId});

  @override
  Widget build(BuildContext context) {
    List<FoodItem> limitedFoodItems = foodItems.take(2).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text('You May Also Like!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        CarouselSlider(
          options: CarouselOptions(height: 140, enlargeCenterPage: true, enableInfiniteScroll: true, viewportFraction: 0.7),
          items: limitedFoodItems.map((food) => FoodCard(food: food, userId: userId)).toList(),
        ),
      ],
    );
  }
}

class FoodCard extends StatelessWidget {
  final FoodItem food;
  final String userId;

  FoodCard({required this.food, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Ensures it wraps its children properly
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(food.image, width: 80, height: 80, fit: BoxFit.cover),
          ),
          SizedBox(width: 10),
          Expanded( // Ensures text doesn't overflow
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(food.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text("\$${food.price}", style: TextStyle(fontSize: 14, color: Colors.orange)),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.add_circle, color: Colors.green),
            onPressed: () {
              addFoodToCart(userId, food);
            },
          ),
        ],
      ),
    );
  }

  void addFoodToCart(String userId, FoodItem food) {
    FirebaseFirestore.instance.collection('cart').doc(userId).collection('items').add({
      'name': food.name,
      'price': food.price,
      'quantity': 1,
      'image': food.image,
    });
  }
}
