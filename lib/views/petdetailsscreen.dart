import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/models/petservices.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/views/donationpaymentpage.dart';
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
  
  TextEditingController motivationController = TextEditingController();
  bool isSubmittingRequest = false;

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
        foregroundColor: const Color.fromARGB(255, 255, 244, 215),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 72, 38, 44),
                Color.fromARGB(255, 120, 60, 70),
                Color.fromARGB(255, 200, 150, 160),
              ],
            ),
          ),
        ),
      ),

      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: screenWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // PET IMAGE WITH GRADIENT OVERLAY
                if (firstImageUrl != null)
                  Stack(
                    children: [
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
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.3),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // PET NAME & CATEGORY
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.pet.petName ?? "Unknown",
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 72, 38, 44),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: getCategoryColor(widget.pet.category).withOpacity(0.15),
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
                        ],
                      ),

                      const SizedBox(height: 20),

                      // PET DETAILS CARD
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              _buildDetailRow(
                                icon: Icons.pets,
                                label: "Type",
                                value: widget.pet.petType ?? "Unknown",
                                iconColor: Colors.blue,
                              ),
                              const Divider(height: 20),
                              _buildDetailRow(
                                icon: Icons.calendar_today,
                                label: "Age",
                                value: "${widget.pet.petAge ?? '0'} years old",
                                iconColor: Colors.orange,
                              ),
                              const Divider(height: 20),
                              _buildDetailRow(
                                icon: widget.pet.petGender == "Male" ? Icons.male : Icons.female,
                                label: "Gender",
                                value: widget.pet.petGender ?? "Unknown",
                                iconColor: widget.pet.petGender == "Male" ? Colors.blue : Colors.pink,
                              ),
                              const Divider(height: 20),
                              _buildDetailRow(
                                icon: Icons.favorite,
                                label: "Health Status",
                                value: widget.pet.petHealth ?? "Unknown",
                                iconColor: getHealthColor(widget.pet.petHealth),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // DESCRIPTION
                      Text(
                        "About",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Text(
                          widget.pet.description ?? "No description",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            height: 1.6,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // LOCATION
                      if (widget.pet.lat != null && widget.pet.lng != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Location",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey[200]!),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.location_on, color: Color.fromARGB(255, 72, 38, 44)),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      "Lat: ${widget.pet.lat}, Lng: ${widget.pet.lng}",
                                      style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),

                      // POSTED BY
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Posted By",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.grey[800],
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (widget.pet.userName != null)
                              Text("${widget.pet.userName}", style: TextStyle(color: Colors.grey[700])),
                            if (widget.pet.userEmail != null)
                              Text("${widget.pet.userEmail}", style: TextStyle(color: Colors.grey[700])),
                            if (widget.pet.userPhone != null)
                              Text("${widget.pet.userPhone}", style: TextStyle(color: Colors.grey[700])),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // ADOPTION FORM
                      if (widget.pet.category == "Adoption")
                        _buildAdoptionForm(),

                      // DONATION FORM
                      if (widget.pet.category == "Donation Request" || widget.pet.category == "Help/Rescue")
                        _buildDonationForm(),

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

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAdoptionForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Request to Adopt",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 72, 38, 44),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: motivationController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: "Share your motivation for adopting...",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color.fromARGB(255, 72, 38, 44),
                width: 2,
              ),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(12),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                : const Text(
                    "Submit Adoption Request",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildDonationForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Make a Donation",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 72, 38, 44),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: DropdownButton<String>(
              value: donationType,
              isExpanded: true,
              underline: SizedBox(),
              items: donationTypes.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  donationType = value ?? 'Food';
                  donationAmountController.clear();
                  donationDescriptionController.clear();
                });
              },
            ),
          ),
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
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          )
        else
          TextField(
            controller: donationDescriptionController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Description',
              hintText: 'Describe what you are donating...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
        const SizedBox(height: 16),
          SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero, // IMPORTANT
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: isSubmittingDonation ? null : submitDonation,
            child: Ink(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromARGB(255, 72, 38, 44),
                    Color.fromARGB(255, 120, 60, 70),
                    Color.fromARGB(255, 200, 150, 160),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                alignment: Alignment.center,
                child: isSubmittingDonation
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "Submit Donation",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 255, 244, 215),
                        ),
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }

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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Submit Adoption Request"),
        content: const Text("Are you sure?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () {
              Navigator.pop(context);
              submitAdoptionToAPI();
            },
            child: const Text("Submit", style: TextStyle(color: Colors.white)),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Confirm Donation"),
        content: const Text("Are you sure?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 72, 38, 44)),
            onPressed: () {
              Navigator.pop(context);
              submitDonationToAPI();
            },
            child: const Text("Confirm", style: TextStyle(color: Colors.white)),
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

    http
        .post(
          Uri.parse('${MyConfig.baseUrl}/pawpal/api/submit_donation.php'),
          body: {
            "user_id": widget.user!.user_id.toString(),
            "pet_id": widget.pet.petId.toString(),
            "donation_type": donationType,
            "amount": amount,
            "description": description,
          },
        )
        .then((response) {
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

              if (donationType == 'Money') {
                double donationAmount = double.parse(amount);
                int petIdInt = int.parse(widget.pet.petId ?? '0');
                
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DonationPaymentPage(
                      user: widget.user!,
                      amount: donationAmount,
                      petId: petIdInt,
                      petName: widget.pet.petName ?? "Pet",
                    ),
                  ),
                );
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyDonationsScreen(user: widget.user),
                  ),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(res['message'] ?? "Failed"),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        })
        .catchError((error) {
          setState(() {
            isSubmittingDonation = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error: $error"),
              backgroundColor: Colors.red,
            ),
          );
        });
  }
}