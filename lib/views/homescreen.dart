import 'package:flutter/material.dart';
import 'package:pawpal/user.dart';
import 'package:pawpal/views/loginscreen.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PawPal Home"),
        automaticallyImplyLeading: false, // Removes back button
        actions: [
          IconButton(// navigates back to login page
            onPressed: (){
              Navigator.push(context, 
              MaterialPageRoute(builder: (context) => const LoginPage()));
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.pets,
                size: 100,
                color: Colors.orange[700],
              ),
              SizedBox(height: 20),
              // Assignment requirement: "Welcome, Ali!" format
              Text(
                "Welcome, ${widget.user.name}!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[700],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'to PawPal Pet Adoption & Donation',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}