import 'package:flutter/material.dart';
import 'package:pawpal/views/loginscreen.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  
  @override
  void initState() {
    super.initState();
    // After 2 seconds, navigate to LoginPage
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/pawpal.png', scale: 3),
            SizedBox(height: 20),
            CircularProgressIndicator(
              color: Colors.orange[700],
            ),
            SizedBox(height: 20),
            Text(
              'Loading PawPal...',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.orange[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}