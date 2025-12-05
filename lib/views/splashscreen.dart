import 'dart:convert'; //decode JSON text from PHP

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/views/mainpage.dart';
import 'package:pawpal/views/registerscreen.dart';
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
    autologin(); //automatically login using stored email & pass. User ticked "remember me" > try auto login
    //server login success > navigate to HomeScreen dengan user data 
    //server login fail > navigate to Homescreen as guest
    // After 3 seconds, navigate to LoginPage
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const RegisterScreen()),
      );
    });
  }

  void autologin() {
    SharedPreferences.getInstance().then((prefs) {
      bool? rememberMe = prefs.getBool('rememberMe');//check if remember me was enabled
      if (rememberMe != null && rememberMe) {
        email = prefs.getString('email') ?? 'NA';
        password = prefs.getString('password') ?? 'NA';
        http //send post request to back end API
            .post(
              Uri.parse(
                '${MyConfig.baseUrl}/pawpal/api/login_user.php'
                ), 
                body: { 'email': email, 'password': password },
              )
            .then((response) {
              if (response.statusCode == 200) { //PHP sends JSON > Flutter turn into Map using jsonDecode
                var jsonResponse = response.body;
                //print(jsonResponse);
                var resarray = jsonDecode(jsonResponse);
                if (resarray['success'] == true) {
                  User user = User.fromJson(resarray['data'][0]);
                  if(!mounted) return;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(user: user),
                    ),
                  );
                } else{
                  Future.delayed(const Duration(seconds: 3), () {
                    if(!mounted) return;
                    //if login fail , navigate to homescreen as guest
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
                  Future.delayed(const Duration(seconds: 3), () {
                    if(!mounted) return;
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
          Future.delayed(const Duration(seconds: 3), () {
            if(!mounted) return;
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
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/pawpal.png', scale: 3),
            SizedBox(height: 20),
            CircularProgressIndicator(
              color: Colors.orange,
            ),
            SizedBox(height: 20),
            Text(
              'Loading PawPal...',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

