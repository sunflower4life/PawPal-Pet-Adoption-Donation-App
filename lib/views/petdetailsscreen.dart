import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/models/petservices.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/views/mydonationsscreen.dart';

class PetDetailsScreen extends StatefulWidget {
  final PetService pet;
  final User? user;

  const PetDetailsScreen({
    super.key,
    required this.pet,
    required this.user,
  });

  @override
  State<PetDetailsScreen> createState() => _PetDetailsScreenState();
}

class _PetDetailsScreenState extends State<PetDetailsScreen> {
  late double screenWidth, screenHeight;
  
  // Adoption form
  TextEditingController motivationController = TextEditingController();
  bool isSubmittingRequest = false;

  // Donation form
  String donationType = 'Food';
  List<String> donationTypes = ['Food', 'Medical', 'Money'];
  TextEditingController donationAmountController = TextEditingController();
  TextEditingController donationDescriptionController = TextEditingController();
  bool isSubmittingDonation = false;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    if (screenWidth > 600) {
      screenWidth = 600;
    }

    String? firstImageUrl = getFirstImageUrl(widget.pet);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pet.petName ?? "Pet Details"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: screenWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // PET IMAGE
                if (firstImageUrl != null)
                  Container(
                    width: screenWidth,
                    height: 300,
                    color: Colors.grey[200],
                    child: Image.network(
                      firstImageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.pets, size: 100, color: Colors.grey);
                      },
                    ),
                  ),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // PET NAME
                      Text(
                        widget.pet.petName ?? "Unknown",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // PET DETAILS CARD
                      Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              // Type
                              Row(
                                children: [
                                  Icon(Icons.pets, color: Colors.blue),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("Type", 
                                      style: TextStyle(
                                        fontSize: 12, 
                                        color: Colors.grey
                                      )),
                                      Text(widget.pet.petType ?? "Unknown", 
                                      style: const TextStyle(
                                        fontSize: 16, 
                                        fontWeight: FontWeight.bold
                                      )),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Age
                              Row(
                                children: [
                                  Icon(Icons.calendar_today, color: Colors.orange),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("Age", 
                                      style: TextStyle(
                                        fontSize: 12, 
                                        color: Colors.grey
                                      )),
                                      Text("${widget.pet.petAge ?? '0'} years old", 
                                      style: const TextStyle(
                                        fontSize: 16, 
                                        fontWeight: FontWeight.bold
                                      )),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Gender
                              Row(
                                children: [
                                  Icon(widget.pet.petGender == "Male" ? Icons.male : Icons.female,
                                      color: widget.pet.petGender == "Male" ? Colors.blue : Colors.pink),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("Gender", 
                                      style: TextStyle(
                                        fontSize: 12, 
                                        color: Colors.grey
                                      )),
                                      Text(widget.pet.petGender ?? "Unknown", 
                                      style: const TextStyle(
                                        fontSize: 16, 
                                        fontWeight: FontWeight.bold
                                      )),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Health
                              Row(
                                children: [
                                  Icon(Icons.favorite, color: getHealthColor(widget.pet.petHealth)),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("Health Status", 
                                      style: TextStyle(
                                        fontSize: 12, 
                                        color: Colors.grey
                                      )),
                                      Text(widget.pet.petHealth ?? "Unknown", 
                                      style: const TextStyle(
                                        fontSize: 16, 
                                        fontWeight: FontWeight.bold
                                      )),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // CATEGORY BADGE
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: getCategoryColor(widget.pet.category).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.pet.category ?? "Unknown",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: getCategoryColor(widget.pet.category),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // DESCRIPTION
                      const Text("Description", 
                      style: TextStyle(
                        fontSize: 18, 
                        fontWeight: FontWeight.bold
                      )),
                      const SizedBox(height: 8),
                      Text(
                        widget.pet.description ?? "No description",
                        style: const TextStyle(
                          fontSize: 14, 
                          color: Colors.black87, 
                          height: 1.5
                        ),
                      ),

                      const SizedBox(height: 20),

                      // LOCATION
                      if (widget.pet.lat != null && widget.pet.lng != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Location", 
                            style: TextStyle(
                              fontSize: 18, 
                              fontWeight: FontWeight.bold
                            )),
                            const SizedBox(height: 8),
                            Text("Lat: ${widget.pet.lat}, Lng: ${widget.pet.lng}", 
                            style: const TextStyle(
                              fontSize: 14, 
                              color: Colors.black87
                            )),
                            const SizedBox(height: 20),
                          ],
                        ),

                      // POSTED BY
                      Card(
                        color: Colors.grey[50],
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Posted By", 
                              style: TextStyle(
                                fontWeight: FontWeight.bold, 
                                fontSize: 14
                              )),
                              const SizedBox(height: 8),
                              if (widget.pet.userName != null) Text("Name: ${widget.pet.userName}"),
                              if (widget.pet.userEmail != null) Text("Email: ${widget.pet.userEmail}"),
                              if (widget.pet.userPhone != null) Text("Phone: ${widget.pet.userPhone}"),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // ADOPTION FORM
                      if (widget.pet.category == "Adoption")
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Request to Adopt", 
                            style: TextStyle(
                              fontSize: 20, 
                              fontWeight: FontWeight.bold
                            )),
                            const SizedBox(height: 12),
                            TextField(
                              controller: motivationController,
                              maxLines: 4,
                              decoration: InputDecoration(
                                hintText: "Share your motivation for adopting...",
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                contentPadding: const EdgeInsets.all(12),
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 76, 175, 80),
                                  minimumSize: const Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: isSubmittingRequest ? null : submitAdoptionRequest,
                                child: isSubmittingRequest
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text("Submit Adoption Request", 
                                    style: TextStyle(
                                      fontSize: 16, 
                                      fontWeight: FontWeight.bold, 
                                      color: Colors.white
                                    )),
                              ),
                            ),
                          ],
                        ),

                      const SizedBox(height: 30),

                      // DONATION FORM
                      if (widget.pet.category == "Donation Request" || widget.pet.category == "Help/Rescue")
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Make a Donation", 
                            style: TextStyle(
                              fontSize: 20, 
                              fontWeight: FontWeight.bold
                            )),
                            const SizedBox(height: 12),

                            DropdownButtonFormField<String>(
                              value: donationType,
                              decoration: InputDecoration(
                                labelText: 'Donation Type',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              items: donationTypes.map((String value) {
                                return DropdownMenuItem<String>(value: value, child: Text(value));
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  donationType = value ?? 'Food';
                                  donationAmountController.clear();
                                  donationDescriptionController.clear();
                                });
                              },
                            ),

                            const SizedBox(height: 12),

                            if (donationType == 'Money')
                              TextField(
                                controller: donationAmountController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Amount (RM)',
                                  hintText: 'Enter donation amount',
                                  prefixText: 'RM ',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              )
                            else
                              TextField(
                                controller: donationDescriptionController,
                                maxLines: 3,
                                decoration: InputDecoration(
                                  labelText: 'Description',
                                  hintText: 'Describe what you are donating...',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  contentPadding: const EdgeInsets.all(12),
                                ),
                              ),

                            const SizedBox(height: 16),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 33, 150, 243),
                                  minimumSize: const Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: isSubmittingDonation ? null : submitDonation,
                                child: isSubmittingDonation
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text("Submit Donation", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                              ),
                            ),
                          ],
                        ),

                      const SizedBox(height: 30),
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

  // GET FIRST IMAGE
  String? getFirstImageUrl(PetService pet) {
    if (pet.imagePaths == null || pet.imagePaths!.isEmpty) {
      return null;
    }

    try {
      var images = jsonDecode(pet.imagePaths!) as List;
      if (images.isNotEmpty) {
        String imageUrl = images[0].toString().trim();
        if (imageUrl.startsWith('http')) {
          return imageUrl;
        }
        return '${MyConfig.baseUrl}/pawpal/$imageUrl';
      }
    } catch (e) {
      try {
        var paths = pet.imagePaths!.split(',');
        if (paths.isNotEmpty && paths[0].trim().isNotEmpty) {
          String imageUrl = paths[0].trim();
          if (imageUrl.startsWith('http')) {
            return imageUrl;
          }
          return '${MyConfig.baseUrl}/pawpal/$imageUrl';
        }
      } catch (e2) {
        print("Error parsing image paths: $e2");
      }
    }

    return null;
  }

  // GET HEALTH COLOR
  Color getHealthColor(String? health) {
    switch (health) {
      case "Healthy":
        return Colors.green;
      case "Sick":
        return Colors.red;
      case "Recovering":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  // GET CATEGORY COLOR
  Color getCategoryColor(String? category) {
    switch (category) {
      case "Adoption":
        return Colors.green;
      case "Donation Request":
        return Colors.orange;
      case "Help/Rescue":
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  // SUBMIT ADOPTION REQUEST
  void submitAdoptionRequest() {
    if (widget.user == null || widget.user?.user_id == null || widget.user?.user_id == '0') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please login first"), backgroundColor: Colors.red),
      );
      return;
    }

    if (motivationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter motivation message"), backgroundColor: Colors.red),
      );
      return;
    }

    if (motivationController.text.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Motivation must be at least 10 characters"), backgroundColor: Colors.red),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Submit Adoption Request"),
        content: Text("Are you sure?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              submitAdoptionToAPI();
            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }

  void submitAdoptionToAPI() {
    setState(() {
      isSubmittingRequest = true;
    });

    http.post(
      Uri.parse('${MyConfig.baseUrl}/pawpal/api/submit_adoption_request.php'),
      body: {
        "user_id": widget.user!.user_id.toString(),
        "pet_id": widget.pet.petId.toString(),
        "motivation_message": motivationController.text.trim(),
      },
    ).then((response) {
      print("Response: ${response.body}");

      setState(() {
        isSubmittingRequest = false;
      });

      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);

        if (res['status'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Request submitted successfully!"), backgroundColor: Colors.green),
          );
          motivationController.clear();
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pop(context);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(res['message'] ?? "Failed"), backgroundColor: Colors.red),
          );
        }
      }
    }).catchError((error) {
      setState(() {
        isSubmittingRequest = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $error"), backgroundColor: Colors.red),
      );
    });
  }

  // SUBMIT DONATION
  void submitDonation() {
    if (widget.user == null || widget.user?.user_id == null || widget.user?.user_id == '0') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please login first"), backgroundColor: Colors.red),
      );
      return;
    }

    if (donationType == 'Money') {
      if (donationAmountController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter amount"), backgroundColor: Colors.red),
        );
        return;
      }

      if (double.tryParse(donationAmountController.text) == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter valid amount"), backgroundColor: Colors.red),
        );
        return;
      }
    } else {
      if (donationDescriptionController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter description"), backgroundColor: Colors.red),
        );
        return;
      }

      if (donationDescriptionController.text.length < 5) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Description must be at least 5 characters"), backgroundColor: Colors.red),
        );
        return;
      }
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Donation"),
        content: Text("Are you sure?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              submitDonationToAPI();
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }

  void submitDonationToAPI() {
    setState(() {
      isSubmittingDonation = true;
    });

    String amount = '';
    String description = '';

    if (donationType == 'Money') {
      amount = donationAmountController.text.trim();
    } else {
      description = donationDescriptionController.text.trim();
    }

    http.post(
      Uri.parse('${MyConfig.baseUrl}/pawpal/api/submit_donation.php'),
      body: {
        "user_id": widget.user!.user_id.toString(),
        "pet_id": widget.pet.petId.toString(),
        "donation_type": donationType,
        "amount": amount,
        "description": description,
      },
    ).then((response) {
      print("Response: ${response.body}");

      setState(() {
        isSubmittingDonation = false;
      });

      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);

        if (res['status'] == true) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Donation submitted successfully!"),
      backgroundColor: Colors.green,
    ),
  );
  
  // Navigate to My Donations screen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MyDonationsScreen(user: widget.user),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(res['message'] ?? "Failed"),
                  backgroundColor: Colors.red,
                ),
              );
            }
      }
    }).catchError((error) {
      setState(() {
        isSubmittingDonation = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $error"), backgroundColor: Colors.red),
      );
    });
  }
}