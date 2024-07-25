import 'package:flutter/material.dart';
import 'welcome_page.dart'; // Import the welcome page

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Use Future.delayed to navigate after a delay
    Future.delayed(Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => WelcomePage()),
      );
    });

    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/logo.png', width: 150), // Adjust width as needed
            SizedBox(height: 20),
            Text(
              'Healing Together',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Adjust color if needed
              ),
            ),
          ],
        ),
      ),
    );
  }
}
