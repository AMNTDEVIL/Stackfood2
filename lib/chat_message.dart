import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> messages = [];
  final ImagePicker _picker = ImagePicker();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Predefined responses
  final Map<String, String> autoResponses = {
    "hi": "Hello!",
    "hello": "Hi there!",
    "how are you?": "I'm good! How about you?",
    "what is your name?": "I'm StackFood Chatbot.",
    "bye": "Goodbye! Have a great day!",
  };

  void sendMessage(String message, {String? imagePath, String? filePath}) {
    if (message.isEmpty && imagePath == null && filePath == null) return;

    // Send user message to Firestore
    Map<String, dynamic> messageData = {
      "sender": "user",
      "text": message,
      "timestamp": FieldValue.serverTimestamp(),
    };

    if (imagePath != null) messageData["image"] = imagePath;
    if (filePath != null) messageData["file"] = filePath;

    _firestore.collection("messages").add(messageData);

    // Send bot response after a delay
    Future.delayed(Duration(seconds: 1), () {
      _firestore.collection("messages").add({
        "sender": "bot",
        "text": autoResponses[message.toLowerCase()] ?? "I'm not sure how to respond to that.",
        "timestamp": FieldValue.serverTimestamp(),
      });
    });

    _messageController.clear();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // Upload the image to Firebase Storage
      String imageUrl = await _uploadImage(image);
      sendMessage("Sent an image", imagePath: imageUrl);
    }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      // Upload the file to Firebase Storage
      String fileUrl = await _uploadFile(result.files.single);
      sendMessage("Sent a file", filePath: fileUrl);
    }
  }

  Future<String> _uploadImage(XFile image) async {
    try {
      Reference storageRef = _storage.ref().child("chat_images/${DateTime.now().millisecondsSinceEpoch}.png");
      UploadTask uploadTask = storageRef.putFile(File(image.path));
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return "";
    }
  }

  Future<String> _uploadFile(PlatformFile file) async {
    try {
      Reference storageRef = _storage.ref().child("chat_files/${DateTime.now().millisecondsSinceEpoch}.${file.extension}");
      UploadTask uploadTask = storageRef.putData(file.bytes!);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading file: $e");
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.person, color: Colors.grey[600]),
            ),
            SizedBox(width: 10),
            Text("StackFood"),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _firestore
                  .collection("messages")
                  .orderBy("timestamp")
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  print('Error: ${snapshot.error}');
                  return Center(child: Text('An error occurred while fetching messages.'));
                }

                if (snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No messages found.'));
                }

                messages = snapshot.data!.docs.map((doc) {
                  return doc.data() as Map<String, dynamic>;
                }).toList();

                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    bool isUser = messages[index]["sender"] == "user";
                    return Align(
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isUser ? Colors.orange : Colors.grey[300],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            Text(messages[index]["text"]!),
                            if (messages[index]["image"] != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Image.network(messages[index]["image"]),
                              ),
                            if (messages[index]["file"] != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  "File attached: ${messages[index]["file"]!.split('/').last}",
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.image, color: Colors.orange),
                  onPressed: _pickImage,
                ),
                IconButton(
                  icon: Icon(Icons.attach_file, color: Colors.orange),
                  onPressed: _pickFile,
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                FloatingActionButton(
                  onPressed: () => sendMessage(_messageController.text.trim()),
                  backgroundColor: Colors.orange,
                  child: Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
