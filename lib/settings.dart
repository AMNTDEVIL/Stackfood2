import 'package:flutter/material.dart';
import 'package:food/chat.dart';
import 'package:food/deliveryman.dart';
import 'package:food/display_profile.dart';
import 'package:food/logout.dart';
import 'package:food/widgets/BottomNavBar.dart';
import 'package:food/widgets/dark_mode_provider.dart'; // Import the provider
import 'language_popup.dart';
import 'privacy_policy.dart';
import 'package:provider/provider.dart';
import 'package:food/open_restaurant.dart';
import 'package:food/helpandsupport.dart';
import 'package:food/coupenpage.dart';
import 'package:food/widgets/myaddress.dart';
import 'package:food/widgets/loyalty_points.dart';
import 'package:food/ReferAndEarn.dart';
import 'package:food/walletPage.dart';
import 'package:food/Refundpolicy.dart';
import 'package:food/termsandconditions.dart';
import 'package:food/cancellation_policy.dart';
import 'package:food/shipping_policy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:food/aboutuspage.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _currentIndex = 4;
  bool isLoggedIn = false; // Initialize as false
  String username = ""; // Initialize as empty
  String accountCreationDate = ""; // Initialize as empty

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load user data when the page is initialized
  }

  // Load user data from SharedPreferences
  void _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      username = prefs.getString('email') ?? "Guest User"; // Use email as username
      String creationTimeString = prefs.getString('creationTime') ?? "";
      if (creationTimeString.isNotEmpty) {
        DateTime creationTime = DateTime.parse(creationTimeString);
        accountCreationDate = "${creationTime.day}/${creationTime.month}/${creationTime.year}"; // Format date
      }
    });
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<DarkModeProvider>(context).isDarkMode;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0,
        title: isLoggedIn
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              username,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "Account created on $accountCreationDate",
              style: TextStyle(fontSize: 12),
            ),
          ],
        )
            : Text("Settings"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            guestUserHeader(),
            sectionTitle("General"),
            menuItem(Icons.person, "Profile", onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            }),
            menuItem(Icons.location_on, "My Address", onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyAddressPage()));
            }),
            menuItem(Icons.language, "Language"),
            switchItem(Icons.dark_mode, "Dark Mode", isDarkMode, (value) {
              Provider.of<DarkModeProvider>(context, listen: false)
                  .toggleDarkMode(value);
            }),
            sectionTitle("Promotional Activity"),
            menuItem(Icons.card_giftcard, "Coupon", onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CouponPage()));
            }),
            menuItem(Icons.star, "Loyalty Points", onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoyaltyPointsScreen()));
            }),
            menuItem(Icons.wallet, "My Wallet", onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => WalletPage()));
            }),
            sectionTitle("Earnings"),
            menuItem(Icons.card_giftcard, "Refer and Earn", onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReferAndEarnScreen()),
              );
            }),
            menuItem(Icons.delivery_dining, "Join as Delivery Man", onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DeliveryManRegistration()),
              );
            }),
            menuItem(Icons.restaurant, "Open Restaurant", onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RestaurantRegistrationPage()),
              );
            }),
            sectionTitle("Help and Support"),
            menuItem(Icons.chat, "Live Chat", onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ConversationListScreen()));
            }),
            menuItem(Icons.help, "Help and Support", onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HelpSupportPage()),
              );
            }),
            menuItem(Icons.info, "About Us",onTap:(){
              Navigator.push(context, MaterialPageRoute(builder:(context) => AboutUsPage()));
            }),
            menuItem(Icons.privacy_tip, "Privacy Policy", onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrivacyPolicyPage()),
              );
            }),
            menuItem(Icons.assignment, "Terms and Conditions", onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TermsAndConditionsPage()),
              );
            }),
            menuItem(Icons.assignment_return, "Refund Policy", onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RefundPolicyPage()),
              );
            }),
            menuItem(Icons.cancel, "Cancellation Policy", onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CancellationPolicyPage()),
              );
            }),
            menuItem(Icons.local_shipping, "Shipping Policy", onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ShippingPolicyPage()),
              );
            }),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.orange),
              title: Text("Logout", style: TextStyle(color: Colors.black)),
              onTap: () => logOut(context),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndexbtmnav: _currentIndex,
        onTapbtmnav: _onTap,
      ),
    );
  }

  Widget guestUserHeader() {
    return Container(
      color: Colors.orange,
      height: MediaQuery.of(context).size.height * 0.06,
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 20, color: Colors.orange),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isLoggedIn ? username : "Guest User",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                isLoggedIn ? "Account created on $accountCreationDate" : "Login to view all features",
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Container(
      color: Colors.orange[50],
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.orange,
        ),
      ),
    );
  }

  Widget menuItem(IconData icon, String title, {Function()? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget switchItem(IconData icon, String title, bool value, Function(bool) onChanged) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.orange,
      ),
    );
  }
}