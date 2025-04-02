import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:device_apps/device_apps.dart'; // Package to access installed apps

class ReferAndEarnScreen extends StatelessWidget {
  // Function to generate a random referral code
  String generateReferralCode() {
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    String referralCode = '';

    for (int i = 0; i < 10; i++) {
      referralCode += characters[random.nextInt(characters.length)];
    }

    return referralCode;
  }

  // Function to get installed apps
  Future<List<Application>> _getInstalledApps() async {
    return await DeviceApps.getInstalledApplications(includeSystemApps: false);
  }

  // Function to directly share with available apps
  Future<void> _shareReferralCode(BuildContext context, String referralCode) async {
    // Get installed apps
    List<Application> installedApps = await _getInstalledApps();

    // Filter out apps you want to support (you can add more conditions if needed)
    List<Application> shareableApps = installedApps.where((app) {
      return app.packageName == 'com.whatsapp' || app.packageName == 'com.facebook.katana'; // Add your conditions here
    }).toList();

    if (shareableApps.isNotEmpty) {
      // Choose the first shareable app (for example, WhatsApp or Facebook)
      String message = 'Join us using my referral code: $referralCode';
      Share.share(message);
    } else {
      // If no app is found, you can show a fallback action
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No shareable apps found')));
    }
  }

  @override
  Widget build(BuildContext context) {
    String referralCode = generateReferralCode();

    return Scaffold(
      appBar: AppBar(
        title: Text('Refer & Earn'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            // Display the image only once
            Center(
              child: Image.asset(
                'assets/refer&earn.png',  // Display the image
                width: 150,  // Width of 150
                height: 150,  // Height of 150
              ),
            ),
            SizedBox(height: 16),
            Divider(),
            SizedBox(height: 16),
            Text(
              'Invite friends & businesses',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Copy your code, share it with your friends',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 16),
            Text(
              'Your personal code',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    referralCode,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: referralCode));
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Copied to clipboard')));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    child: Text('Copy'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () => _shareReferralCode(context, referralCode),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                child: Text('Or share'),
              ),
            ),
            SizedBox(height: 16),
            Divider(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
