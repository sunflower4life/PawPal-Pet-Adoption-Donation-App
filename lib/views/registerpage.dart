import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();  
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  late double height, width;
  bool visible = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    print(width);
    if(width > 400) {
      width = 400;
    } else{
      width = width;
    }
    return Scaffold(
      appBar: AppBar(title: Text('Register Page'),),
      body: Center(
        child: SingleChildScrollView(
          child:Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
            child: SizedBox(
              width: width,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset('assets/images/pawpal.png' , scale: 4.5),
                  ),
                  SizedBox(height:5),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height:5),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextField(
                    controller: passwordController,
                    obscureText: visible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        onPressed: (){
                          if(visible){
                            visible = false;
                          }else{
                            visible = true;
                          }
                          setState(() {});
                        },
                        icon: Icon(Icons.visibility),
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 5),
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: visible,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: (){
                          if(visible){
                            visible = false;
                          }else{
                            visible = true;
                          }
                          setState(() {});
                        },
                        icon: Icon(Icons.visibility),
                      ),
                    )
                  ),
                  SizedBox(height: 5),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone',
                      border: OutlineInputBorder(),
                    ),  
                  ),
                  SizedBox(height: 5),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (){
                        print('Register button pressed');
                        registerDialog();
                      }, 
                      child: Text('Register'),
                    ),
                  ),
                  SizedBox(height: 5),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      /*Navigator.push(
                        context
                        /*MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),*/
                      );*/
                    }, 
                    child: Text('Already have an account? Login')
                  ),
                  SizedBox(height:5),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void registerDialog(){
    String name = nameController.text.trim();
    String email = emailController.text.trim(); 
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();
    String phone = phoneController.text.trim();

  //validation 1: Check if all field is empty  
  if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty || phone.isEmpty) {
      SnackBar snackBar = const SnackBar(
        content: Text('Please fill in all fields'),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    //validation 2: Check if password and confirm password match
    if (password != confirmPassword) {
      SnackBar snackBar = const SnackBar(
        content: Text('Passwords do not match'),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    //validation 3: Check if email is valid
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      SnackBar snackBar = const SnackBar(
        content: Text('Please enter a valid email address'),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    // Validation 3: Check password length (minimum 6 characters) - THIS WAS MISSING!
    if (password.length < 6) {
      SnackBar snackBar = const SnackBar(
        content: Text('Password must be at least 6 characters long'),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    //if all validation is valid, then show a confirmation message
    showDialog( //a pop up message
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Register this account?'),
        //content: const Text('Are you sure you want to register?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              //print('Before registering user with email: $email');
              registerUser(name, email, password, phone);
            },
            child: Text('Register'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
        content: Text ('Are you sure you want to register this account'),
      ),
    );
  }

  void registerUser(String name, String email, String password, String phone) async {
    await http.post(
      Uri.parse('http:// /pawpal/api/register_user.php'),
      body:{
        'name': name,
        'email': email,
        'password': password,
        'phone': phone},

    ).then((response) {
      print(response.body);
    });
  }
}  
