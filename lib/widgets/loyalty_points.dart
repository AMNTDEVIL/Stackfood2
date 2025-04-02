import 'package:flutter/material.dart';

class LoyaltyPointsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the height of the screen
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Loyalty Points'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch the columns
          children: [
            // Convertible Points Container with Trophy Icon, Text, and Value ("0")
            Container(
              height: screenHeight * 0.2, // 20% of the screen height
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blue.shade50,
              ),
              child: Center( // Centering the content inside the container
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Center row horizontally
                  children: [
                    Icon(
                      Icons.emoji_events, // Trophy icon
                      size: 40,
                      color: Colors.yellow.shade800, // Trophy icon color
                    ),
                    SizedBox(width: 8), // Space between icon and text
                    Column( // Added Column to stack Text and Value
                      mainAxisAlignment: MainAxisAlignment.center, // Centering text vertically
                      children: [
                        Text(
                          'Convertible Points',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4), // Space between the text and the value
                        Text(
                          '0', // The value for convertible points
                          style: TextStyle(fontSize: 24, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16), // Space between sections

            // Point History Section
            Text(
              'Point History',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'No transaction yet!',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 16), // Space between sections

            // Centered Icon (Icons.history)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
                  children: [
                    Icon(
                      Icons.history,
                      size: 100, // Setting the size of the icon to 100x100
                      color: Colors.grey, // Adjust icon color as needed
                    ),
                    SizedBox(height: 8),
                    Text(
                      'No transaction yet!',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16), // Space before the button

            // Convert to Wallet Money Button with Orange Background
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0), // Add padding to make button smaller
              child: ElevatedButton(
                onPressed: () {
                  // Add functionality to convert points to wallet money
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange, // Set background color to orange

                ),
                child: Text('Convert to Wallet Money'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
