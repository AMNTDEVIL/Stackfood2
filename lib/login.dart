import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'orders.dart'; // Assuming this is where MyOrdersPage is located.

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isChecked = false;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Method for Google Sign-In
  Future<void> _googleLogin() async {
    try {
      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // The user canceled the login
        return;
      }

      // Obtain the authentication details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential for Firebase authentication
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google user credentials
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      // Store login state and user details in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('email', userCredential.user?.email ?? '');
      prefs.setBool('isLoggedIn', true);
      prefs.setString('userId', userCredential.user?.uid ?? '');
      prefs.setString('username', userCredential.user?.displayName ?? ''); // Store username (if available)

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyOrdersPage()),
      );

      // Show success message
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Logged in with Google")));
    } catch (e) {
      print("Google Sign-In Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Google Sign-In failed: ${e.toString()}"))
      );
    }
  }

  Future<void> _emailLogin() async {
    try {
      if (!_formKey.currentState!.validate()) return;

      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      if (userCredential.user != null) {
        // Store login state and user details in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('email', userCredential.user?.email ?? '');
        prefs.setBool('isLoggedIn', true);
        prefs.setString('userId', userCredential.user?.uid ?? '');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyOrdersPage()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login failed: ${e.toString()}"))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset("assets/logo2.png", width: 100, height: 100),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Login", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                ),
                SizedBox(height: 5),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 5),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked = value!;
                            });
                          },
                        ),
                        Text("Remember Me"),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        // Implement Forgot Password logic here
                      },
                      child: Text("Forgot Password?"),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Text("* I agree with all the "),
                    TextButton(
                      onPressed: () {
                        // Implement Terms and Conditions logic here
                      },
                      child: Text("Terms & Conditions", style: TextStyle(color: Colors.orange)),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                ElevatedButton(
                  onPressed: _emailLogin, // Trigger normal login
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  ),
                  child: Text("Login", style: TextStyle(color: Colors.white)),
                ),
                SizedBox(height: 10),
                Text("or"),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    // Implement OTP Sign-in logic
                  },
                  child: Text(
                    "Sign in with OTP",
                    style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Expanded(child: Divider(thickness: 1)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text("or continue with"),
                    ),
                    Expanded(child: Divider(thickness: 1)),
                  ],
                ),
                SizedBox(height: 10),
                // Google Sign-In Button
                GestureDetector(
                  onTap: _googleLogin, // Trigger Google login
                  child: Image.asset("assets/googlelogo.png", width: 50, height: 50),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}