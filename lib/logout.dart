import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

Future<void> logOut(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Clear all saved data in SharedPreferences
  await prefs.clear();

  // Optionally, navigate back to the login screen
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => LoginPage()), // Change this to your login page
  );

  // Show a confirmation message
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("Logged out successfully")),
  );
}
