import 'package:flutter/material.dart';
import 'package:food/widgets/BottomNavBar.dart'; // Custom bottom nav bar widget
import 'package:shared_preferences/shared_preferences.dart'; // For SharedPreferences
import 'package:url_launcher/url_launcher.dart'; // For the email functionality
import 'package:country_picker/country_picker.dart'; // For the country picker
import 'package:flutter_svg/flutter_svg.dart'; // For displaying SVG images

class MyOrdersPage extends StatefulWidget {
  @override
  _MyOrdersPageState createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isLoggedIn = false;
  int _currentIndex = 2; // Default selected index for bottom navigation

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _checkLoginStatus();
  }

  // Function to check if the user is logged in using SharedPreferences
  void _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool loggedIn = prefs.getBool('isLoggedIn') ?? false;
    setState(() {
      isLoggedIn = loggedIn;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('My Orders', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.orange,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.orange,
          tabs: [
            Tab(text: 'Running'),
            Tab(text: 'Subscription'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: isLoggedIn
          ? TabBarView(
        controller: _tabController,
        children: [
          _buildOrderTab(context, 'Running'),
          _buildOrderTab(context, 'Subscription'),
          _buildOrderTab(context, 'History'),
        ],
      )
          : _buildNotLoggedInContent(),
      bottomNavigationBar: BottomNavBar(
        currentIndexbtmnav: _currentIndex,
        onTapbtmnav: _onTap,
      ),
    );
  }

  // Widget to build content for each tab
  Widget _buildOrderTab(BuildContext context, String tabName) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/no_order.png', // Replace with your image asset path
            width: 100,
            height: 100,
            color: Colors.grey[400],
          ),
          SizedBox(height: 10),
          Text('No order yet!', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  // Widget to build content when user is not logged in
  Widget _buildNotLoggedInContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/login_prompt.png', // Replace with your image asset path
            width: 100,
            height: 100,
            color: Colors.grey[400],
          ),
          SizedBox(height: 10),
          Text('Please log in to view your orders.', style: TextStyle(color: Colors.grey)),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Navigate to the login page (You should implement this part)
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
            },
            child: Text('Log In'),
          ),
        ],
      ),
    );
  }

  // Function to handle bottom navigation tab taps
  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Login page implementation
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(child: Text('Login Form Here')),
    );
  }
}

class OrdersPage extends StatefulWidget {
  final bool isLoggedIn;

  OrdersPage({required this.isLoggedIn});

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  int _currentIndex = 3;

  // Default country set to Canada (CA)
  Country _selectedCountry = Country(
    phoneCode: '1',
    countryCode: 'CA',
    name: 'Canada',
    displayName: 'Canada',
    displayNameNoCountryCode: 'Canada',
    e164Key: 'CA',
    e164Sc: 1,
    example: '+1 (416) 555-0100',
    geographic: true,
    level: 1,
  );

  TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'My Orders',
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          const Divider(
            height: 4,
            thickness: 1,
          ),
          const SizedBox(height: 90),

          // Conditional rendering based on login status
          if (widget.isLoggedIn) ...[
            // Order ID field (only shown if logged in)
            Center(
              child: Container(
                width: 350, // Set the width of the TextField
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Order ID *',
                    hintStyle: TextStyle(color: Colors.grey),
                    label: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Order ID',
                            style: TextStyle(color: Colors.grey),
                          ),
                          TextSpan(
                            text: ' *',
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 7),

            // Country flag, vertical line, and Phone input (only shown if logged in)
            Center(
              child: Container(
                width: 350,
                child: Stack(
                  children: [
                    // TextField for phone number
                    TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Phone Number',
                        prefixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Country flag picker and +1 (Canada)
                            GestureDetector(
                              onTap: () {
                                showCountryPicker(
                                  context: context,
                                  showPhoneCode: true,
                                  onSelect: (country) {
                                    setState(() {
                                      _selectedCountry = country;
                                    });
                                  },
                                );
                              },
                              child: SvgPicture.network(
                                'https://flagcdn.com/${_selectedCountry.countryCode.toLowerCase()}.svg',
                                width: 30,
                                height: 20,
                              ),
                            ),
                            SizedBox(width: 10),
                            // Phone country code (e.g., +1 for Canada)
                            Text(
                              '+${_selectedCountry.phoneCode}',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                            SizedBox(width: 10),
                            // Vertical line
                            Text(
                              '|',
                              style: TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                            SizedBox(width: 10),
                          ],
                        ),
                        labelText: 'Phone *',
                        labelStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Track Order Button (only shown if logged in)
            Center(
              child: Container(
                width: 350, // Adjusts the button width
                child: ElevatedButton(
                  onPressed: () {}, // Enable button with an empty callback
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange, // Set the button's background color to orange
                    padding: EdgeInsets.symmetric(horizontal: 15.0), // Custom horizontal padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5), // Rounded corners with a 5-pixel radius
                    ),
                    elevation: 0, // Removes button shadow
                  ),
                  child: Text(
                    'Track Order',
                    style: TextStyle(
                      color: Colors.white, // Sets the text color to white for better contrast
                      fontWeight: FontWeight.bold, // Makes the text bold
                    ),
                  ),
                ),
              ),
            ),
          ] else ...[
            // Content to display if not logged in
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.login, // Replace with the icon you prefer
                    size: 100,  // Set the desired size
                    color: Colors.grey[400],  // Set the color, adjust as needed
                  ),
                  SizedBox(height: 10),
                  Text('Please log in to view your orders.', style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the login page
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: Text('Log In'),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndexbtmnav: _currentIndex,
        onTapbtmnav: _onTap,
      ),
    );
  }

  // Function to handle bottom navigation tab taps
  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
