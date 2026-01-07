import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';

class ProfilePage extends StatefulWidget {
  User user;
  ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  bool isLoading = false;
  File? profileImage;
  DateFormat dateFormat = DateFormat('dd/MM/yyyy HH:mm a');

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    nameController.text = widget.user.name.toString() ?? '';
    phoneController.text = widget.user.phone ?? '';
    emailController.text = widget.user.email ?? '';
  }

  // ================= PICK PROFILE IMAGE FROM GALLERY =================
  Future<void> _pickProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        profileImage = File(pickedFile.path);
      });
    }
  }

  // ================= UPDATE PROFILE =================
  Future<void> _updateProfile() async {
    if (nameController.text.isEmpty || phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in all fields"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    String profileImageBase64 = '';
    if (profileImage != null) {
      profileImageBase64 = base64Encode(profileImage!.readAsBytesSync());
    }

    final response = await http.post(
      Uri.parse('${MyConfig.baseUrl}/pawpal/api/update_profile.php'),
      body: {
        'user_id': widget.user.user_id,
        'name': nameController.text,
        'phone': phoneController.text,
        'profile_image': profileImageBase64,
      },
    );

    log("Update response: ${response.body}");

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Profile updated successfully"),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {
          profileImage = null;
        });
        loadProfile();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? "Update failed"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    setState(() => isLoading = false);
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width > 500
        ? 500.0
        : MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 72, 38, 44),
        foregroundColor: const Color.fromARGB(255, 255, 244, 215),
        titleSpacing: 16,
        title: const Text(
          "My Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              loadProfile();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: width),
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // ========== PROFILE IMAGE AVATAR ==========
                        GestureDetector(
                          onTap: _pickProfileImage,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey[300],
                            child: profileImage != null
                                ? ClipOval(
                                    child: Image.file(
                                      profileImage!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : ClipOval(
                                    child: Image.network(
                                      '${MyConfig.baseUrl}/pawpal/assets/profiles/profile_${widget.user.user_id}.jpg?t=${DateTime.now().millisecondsSinceEpoch}',
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          color: const Color.fromARGB(
                                              255, 72, 38, 44),
                                          child: Text(
                                            widget.user.name
                                                    ?.substring(0, 1)
                                                    .toUpperCase() ??
                                                'U',
                                            style: const TextStyle(
                                              fontSize: 32,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Tap to change photo text
                        Text(
                          "Tap to change photo",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ========== READONLY FIELDS ==========
                        _readonlyField("User ID", widget.user.user_id),
                        _readonlyField("Email", widget.user.email),
                        _readonlyField(
                          "Registered",
                          dateFormat.format(
                            DateTime.parse(
                              widget.user.regDate ?? '0000-00-00',
                            ),
                          ),
                        ),

                        const Divider(height: 30),
                        const SizedBox(height: 8),

                        // ========== EDITABLE FIELDS ==========
                        _inputField(
                          controller: nameController,
                          label: "Name",
                          icon: Icons.person,
                          keyboard: TextInputType.name,
                        ),

                        const SizedBox(height: 12),

                        _inputField(
                          controller: phoneController,
                          label: "Phone Number",
                          icon: Icons.phone_outlined,
                          keyboard: TextInputType.phone,
                        ),

                        const SizedBox(height: 20),

                        // ========== SAVE BUTTON ==========
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 72, 38, 44),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: _updateProfile,
                            child: const Text(
                              "Save Changes",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ========== LOADING OVERLAY ==========
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  // ================= HELPER WIDGETS =================
  Widget _readonlyField(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        readOnly: true,
        controller: TextEditingController(text: value ?? "-"),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.lock_outline),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void loadProfile() {
    http
        .get(
          Uri.parse(
            '${MyConfig.baseUrl}/pawpal/api/get_user_details.php?user_id=${widget.user.user_id}',
          ),
        )
        .then((response) {
          if (response.statusCode == 200) {
            var jsonResponse = response.body;
            var resarray = jsonDecode(jsonResponse);
            log(response.body);
            if (resarray['status'] == true) {
              User user = User.fromJson(resarray['data'][0]);
              widget.user = user;
              _loadUserData();
              setState(() {});
            }
          }
        });
  }
}