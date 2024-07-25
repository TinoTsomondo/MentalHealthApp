import 'package:flutter/material.dart';
import 'home_page.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate loading process and navigate to HomePage after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      int userId = 123; // Replace with actual userId fetching logic
      if (userId > 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(userId: userId)),
        );
      } else {
        // Handle the case where userId is invalid
        print("Error: Invalid userId");
        // You might want to navigate to a login screen or show an error message
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/logo.png', width: 100), // Adjust size as needed
            SizedBox(height: 20),
            Text('Loading...', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}