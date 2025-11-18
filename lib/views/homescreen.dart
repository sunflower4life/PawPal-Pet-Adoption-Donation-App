import 'package:flutter/material.dart';
import 'package:pawpal/user.dart';

class HomeScreen extends StatefulWidget {
  final User user;  // Remove the ? - user is required!

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
        backgroundColor: Colors.orange[700],
        automaticallyImplyLeading: false, // Removes back button
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
              SizedBox(height: 30),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'User Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Divider(),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.email, color: Colors.orange[700]),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text('Email: ${widget.user.email}'),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.phone, color: Colors.orange[700]),
                          SizedBox(width: 10),
                          Text('Phone: ${widget.user.phone}'),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, color: Colors.orange[700]),
                          SizedBox(width: 10),
                          Text('Registered: ${widget.user.regDate}'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}