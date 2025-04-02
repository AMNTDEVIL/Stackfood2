import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: Column(
        children: [
          Divider(
            color: Colors.grey.shade300,
            thickness: 1,
          ),
          // The content below the divider
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to StackFood!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'At StackFood, we believe that food should not just be a meal, but an experience. We bring you a wide variety of delicious dishes, ranging from local favorites to international delicacies. Our mission is to offer fresh, high-quality ingredients paired with exceptional customer service. We are committed to bringing people together through food, making every meal a memorable occasion.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.6,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'We pride ourselves on our diverse menu that caters to all tastes and preferences. Whether you’re in the mood for a quick bite, a healthy salad, or an indulgent treat, StackFood has something for everyone. We ensure that all our dishes are crafted with love and the finest ingredients, so you can enjoy a meal that’s as good for the soul as it is for your taste buds.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.6,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'At StackFood, sustainability is at the heart of everything we do. We strive to minimize our environmental impact by using eco-friendly packaging and supporting local farmers. Our goal is to create a food culture that values both taste and responsibility. Join us on our journey to make the world a better place, one meal at a time.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
