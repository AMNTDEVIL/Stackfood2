import 'package:flutter/material.dart';

class LoginWithEmail extends StatefulWidget {
  @override
  _LoginWithEmailState createState() => _LoginWithEmailState();
}

class _LoginWithEmailState extends State<LoginWithEmail> {
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login with Email"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _numberController,
              decoration: InputDecoration(
                labelText: "Number",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: "Username",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _handleLogin,
              child: Text("Login"),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLogin() {
    String number = _numberController.text;
    String username = _usernameController.text;

    // You can now use the `number` and `username` for further login steps
    print("Number: $number, Username: $username");

    // Handle login logic (e.g., send to Firebase, API, etc.)
  }
}
