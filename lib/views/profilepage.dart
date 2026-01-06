import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';

class ProfilePage extends StatefulWidget {
  final User? user;

  const ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late double screenWidth, screenHeight;

  // Form controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  File? profileImage;
  bool isEditing = false;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Load user data
    if (widget.user != null) {
      nameController.text = widget.user?.name ?? '';
      emailController.text = widget.user?.email ?? '';
      phoneController.text = widget.user?.phone ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    if (screenWidth > 600) {
      screenWidth = 600;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: screenWidth,
            child: Column(
              children: [
                // PROFILE IMAGE SECTION
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: isEditing ? pickProfileImage : null,
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey[300],
                          child: profileImage != null
                              ? ClipOval(
                                  child: Image.file(
                                    profileImage!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Colors.grey[600],
                                ),
                        ),
                      ),
                      if (isEditing)
                        TextButton.icon(
                          onPressed: pickProfileImage,
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Change Photo'),
                        ),
                    ],
                  ),
                ),

                // PROFILE FORM
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // NAME
                      TextField(
                        controller: nameController,
                        enabled: isEditing,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // EMAIL
                      TextField(
                        controller: emailController,
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: const Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // PHONE
                      TextField(
                        controller: phoneController,
                        enabled: isEditing,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Phone',
                          prefixIcon: const Icon(Icons.phone),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // EDIT / SAVE BUTTON
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isEditing
                                ? const Color.fromARGB(255, 76, 175, 80)
                                : Colors.blue,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: isSubmitting
                              ? null
                              : () {
                                  if (isEditing) {
                                    submitProfileUpdate();
                                  } else {
                                    setState(() {
                                      isEditing = true;
                                    });
                                  }
                                },
                          child: isSubmitting
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(Colors.white),
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  isEditing ? 'Save Changes' : 'Edit Profile',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),

                      if (isEditing)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey,
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  isEditing = false;
                                  // Reset fields
                                  nameController.text = widget.user?.name ?? '';
                                  phoneController.text = widget.user?.phone ?? '';
                                  profileImage = null;
                                });
                              },
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // PICK PROFILE IMAGE
  void pickProfileImage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick Image'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                openCamera();
              },
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                openGallery();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> openCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> openGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        profileImage = File(pickedFile.path);
      });
    }
  }

  // SUBMIT PROFILE UPDATE
  void submitProfileUpdate() {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter name'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter phone'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Profile'),
        content: const Text('Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              updateProfileToAPI();
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void updateProfileToAPI() {
    setState(() {
      isSubmitting = true;
    });

    String profileImageBase64 = '';

    if (profileImage != null) {
      profileImageBase64 = base64Encode(profileImage!.readAsBytesSync());
    }

    http.post(
      Uri.parse('${MyConfig.baseUrl}/pawpal/api/update_profile.php'),
      body: {
        "user_id": widget.user?.user_id.toString(),
        "name": nameController.text.trim(),
        "phone": phoneController.text.trim(),
        "profile_image": profileImageBase64,
      },
    ).then((response) {
      print("Response: ${response.body}");

      setState(() {
        isSubmitting = false;
      });

      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);

        if (res['status'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          setState(() {
            isEditing = false;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(res['message'] ?? 'Failed to update'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }).catchError((error) {
      setState(() {
        isSubmitting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $error'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }
}