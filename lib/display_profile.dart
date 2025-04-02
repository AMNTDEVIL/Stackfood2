import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Add this for date formatting

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _username = '';
  String _email = '';
  String _phone = '';
  String _referCode = '';
  String _createdAt = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Load user data from Firestore
  void _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (snapshot.exists) {
        setState(() {
          _username = snapshot['username'] ?? '';
          _email = snapshot['email'] ?? '';
          _phone = snapshot['phone'] ?? '';
          _referCode = snapshot['referCode'] ?? '';

          // Format the createdAt timestamp
          Timestamp timestamp = snapshot['createdAt'] ?? Timestamp.now();
          _createdAt = DateFormat('MMMM d, yyyy at h:mm a').format(timestamp.toDate());
        });
      } else {
        // Handle case where user data doesn't exist
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User data not found!')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture
            Center(child: CircleAvatar(radius: 50, backgroundColor: Colors.orange, child: Icon(Icons.person, size: 50))),
            const SizedBox(height: 20),

            // Username Display
            Text(
              'Username: $_username',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Email Display
            Text(
              'Email: $_email',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),

            // Phone Number Display
            Text(
              'Phone Number: $_phone',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),

            // Referral Code Display
            Text(
              'Referral Code: $_referCode',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),

            // Created At Display
            Text(
              'Account Created At: $_createdAt',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
