import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:country_code_picker/country_code_picker.dart';

class DeliveryManRegistration extends StatefulWidget {
  @override
  _DeliveryManRegistrationState createState() => _DeliveryManRegistrationState();
}

class _DeliveryManRegistrationState extends State<DeliveryManRegistration> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  String countryCode = "+1";
  bool _isLoading = false;

  // Controllers for text fields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Function to pick an image
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Function to upload image to Firebase Storage
  Future<String?> _uploadImage(File imageFile) async {
    try {
      String fileName = "profile_pictures/${DateTime.now().millisecondsSinceEpoch}.jpg";
      Reference storageReference = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = storageReference.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  // Function to handle registration
  Future<void> _registerDeliveryMan() async {
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("All fields are required"),
        backgroundColor: Colors.red,
      ));
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Passwords do not match"),
        backgroundColor: Colors.red,
      ));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Register user with Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      String? imageUrl;
      if (_image != null) {
        imageUrl = await _uploadImage(_image!);
      }

      // Store user details in Firestore
      await FirebaseFirestore.instance.collection('delivery_men').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'phone': "$countryCode${_phoneController.text.trim()}",
        'email': _emailController.text.trim(),
        'profileImage': imageUrl ?? "",
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Registration successful!"),
        backgroundColor: Colors.green,
      ));

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error: ${e.toString()}"),
        backgroundColor: Colors.red,
      ));
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Delivery Man Registration'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Complete registration process to serve as a delivery man on this platform",
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 16),

              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.orange),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _image == null
                        ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt, color: Colors.grey),
                        Text("Upload Profile Picture", style: TextStyle(color: Colors.grey, fontSize: 12)),
                        Text("jpg, png, gif (max 2MB)", style: TextStyle(color: Colors.grey, fontSize: 10)),
                      ],
                    )
                        : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(_image!, fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              TextFormField(controller: _firstNameController, decoration: InputDecoration(labelText: "First name *", prefixIcon: Icon(Icons.person))),
              SizedBox(height: 10),

              TextFormField(controller: _lastNameController, decoration: InputDecoration(labelText: "Last name *", prefixIcon: Icon(Icons.person))),
              SizedBox(height: 10),

              Row(
                children: [
                  CountryCodePicker(
                    initialSelection: 'US',
                    onChanged: (CountryCode code) {
                      setState(() {
                        countryCode = code.dialCode!;
                      });
                    },
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(labelText: "Phone *"),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),

              TextFormField(controller: _emailController, decoration: InputDecoration(labelText: "E-mail *", prefixIcon: Icon(Icons.email)), keyboardType: TextInputType.emailAddress),
              SizedBox(height: 10),

              TextFormField(controller: _passwordController, decoration: InputDecoration(labelText: "Password *", prefixIcon: Icon(Icons.lock), suffixIcon: Icon(Icons.remove_red_eye)), obscureText: true),
              SizedBox(height: 10),

              TextFormField(controller: _confirmPasswordController, decoration: InputDecoration(labelText: "Confirm Password *", prefixIcon: Icon(Icons.lock), suffixIcon: Icon(Icons.remove_red_eye)), obscureText: true),
              SizedBox(height: 20),

              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _registerDeliveryMan,
                child: Text('Register'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
