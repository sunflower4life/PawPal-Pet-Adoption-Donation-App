import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/views/mainpage.dart';
import 'package:pawpal/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  String email = '';
  String password = '';

  @override
  void initState() {
    super.initState();
    autologin();
  }

  void autologin() {
    SharedPreferences.getInstance().then((prefs) {
      bool? rememberMe = prefs.getBool('rememberMe');
      if (rememberMe != null && rememberMe) {
        email = prefs.getString('email') ?? 'NA';
        password = prefs.getString('password') ?? 'NA';
        print("Auto-login: email=$email, password=$password");
        
        http
            .post(
              Uri.parse('${MyConfig.baseUrl}/pawpal/api/login_user.php'),
              body: {
                'email': email,
                'password': password,
              },
            )
            .then((response) {
              print("Auto-login response: ${response.body}");
              
              if (response.statusCode == 200) {
                var jsonResponse = response.body;
                var resarray = jsonDecode(jsonResponse);
                
                if (resarray['success'] == true) {
                  // Login successful - create user from response
                  User user = User.fromJson(resarray['data'][0]);
                  if (!mounted) return;
                  
                  Future.delayed(const Duration(seconds: 2), () {
                    if (!mounted) return;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(user: user),
                      ),
                    );
                  });
                } else {
                  // Login failed - navigate as guest
                  print("Auto-login failed: ${resarray['message']}");
                  Future.delayed(const Duration(seconds: 3), () {
                    if (!mounted) return;
                    User user = User(
                      user_id: '0',
                      name: 'guest',
                      email: 'guest@email.com',
                      phone: '000-0000000',
                      password: 'guest',
                      regDate: '0000-00-00',
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(user: user),
                      ),
                    );
                  });
                }
              } else {
                // Server error - navigate as guest
                print("Auto-login server error: ${response.statusCode}");
                Future.delayed(const Duration(seconds: 3), () {
                  if (!mounted) return;
                  User user = User(
                    user_id: '0',
                    name: 'guest',
                    email: 'guest@email.com',
                    phone: '000-0000000',
                    password: 'guest',
                    regDate: '0000-00-00',
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(user: user),
                    ),
                  );
                });
              }
            });
      } else {
        // No saved credentials - navigate as guest
        print("No remember me preference found");
        Future.delayed(const Duration(seconds: 3), () {
          if (!mounted) return;
          User user = User(
            user_id: '0',
            name: 'guest',
            email: 'guest@email.com',
            phone: '000-0000000',
            password: 'guest',
            regDate: '0000-00-00',
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(user: user),
            ),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 72, 38, 44),
              Color.fromARGB(255, 242, 194, 121),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // APP ICON
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(
                Icons.pets,
                size: 60,
                color: Color.fromARGB(255, 72, 38, 44),
              ),
            ),

            const SizedBox(height: 24),

            // APP NAME
            const Text(
              "PawPal",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),

            const SizedBox(height: 8),

            // TAGLINE
            const Text(
              "Pet Adoption & Donation",
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),

            const SizedBox(height: 40),

            // LOADING INDICATOR
            const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2.5,
            ),
          ],
        ),
      ),
    );
  }
}