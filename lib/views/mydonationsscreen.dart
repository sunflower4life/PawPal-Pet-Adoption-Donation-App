import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';

class MyDonationsScreen extends StatefulWidget {
  final User? user;

  const MyDonationsScreen({super.key, required this.user});

  @override
  State<MyDonationsScreen> createState() => _MyDonationsScreenState();
}

class _MyDonationsScreenState extends State<MyDonationsScreen> {
  List<Map<String, dynamic>> donationsList = [];
  String status = "Loading...";
  late double screenWidth, screenHeight;
  double totalDonated = 0;

  @override
  void initState() {
    super.initState();
    loadMyDonations();
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
        title: const Text('My Donations'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              loadMyDonations();
            }
        )],
      ),
      body: Center(
        child: SizedBox(
          width: screenWidth,
          child: Column(
            children: [
              // SUMMARY CARD
              if (donationsList.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              const Text("Total Donations", style: TextStyle(fontSize: 12, color: Colors.grey)),
                              const SizedBox(height: 8),
                              Text(
                                donationsList.length.toString(),
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Text("Money Donated", style: TextStyle(fontSize: 12, color: Colors.grey)),
                              const SizedBox(height: 8),
                              Text(
                                "RM ${totalDonated.toStringAsFixed(2)}",
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // DONATIONS LIST
              donationsList.isEmpty
                  ? Expanded(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                            const SizedBox(height: 12),
                            Text(
                              status,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: donationsList.length,
                        itemBuilder: (context, index) {
                          var donation = donationsList[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // PET NAME AND DONATION TYPE
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          donation['pet_name'] ?? "Unknown",
                                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: getDonationTypeColor(donation['donation_type']).withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          donation['donation_type'] ?? "",
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: getDonationTypeColor(donation['donation_type']),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 8),

                                  // DONATION DETAILS
                                  if (donation['donation_type'] == 'Money')
                                    Text(
                                      "Amount: RM ${donation['amount'] ?? '0'}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    )
                                  else
                                    Text(
                                      donation['description'] ?? "",
                                      style: const TextStyle(fontSize: 13, color: Colors.black87),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),

                                  const SizedBox(height: 8),

                                  // DATE
                                  Text(
                                    "Donated: ${donation['created_at'] ?? ''}",
                                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  // LOAD MY DONATIONS
  void loadMyDonations() {
    if (widget.user?.user_id == null || widget.user?.user_id == '0') {
      setState(() {
        status = "Please login to view your donations";
        donationsList.clear();
      });
      return;
    }

    http
        .get(
          Uri.parse(
            '${MyConfig.baseUrl}/pawpal/api/get_my_donations.php?user_id=${widget.user!.user_id}',
          ),
        )
        .then((response) {
          print("API Response: ${response.body}");

          if (response.statusCode == 200) {
            var jsonResponse = jsonDecode(response.body);

            if (jsonResponse['status'] == true && jsonResponse['data'] != null) {
              setState(() {
                donationsList.clear();
                totalDonated = 0;

                for (var item in jsonResponse['data']) {
                  donationsList.add(item);

                  // Calculate total money donated
                  if (item['donation_type'] == 'Money' && item['amount'] != null) {
                    totalDonated += double.tryParse(item['amount'].toString()) ?? 0;
                  }
                }

                status = donationsList.isEmpty ? "No donations yet" : "";
              });
            } else {
              setState(() {
                donationsList.clear();
                status = jsonResponse['message'] ?? "No donations found";
              });
            }
          } else {
            setState(() {
              status = "Failed to load donations";
            });
          }
        });
  }

  // GET DONATION TYPE COLOR
  Color getDonationTypeColor(String? type) {
    switch (type) {
      case "Food":
        return Colors.orange;
      case "Medical":
        return Colors.red;
      case "Money":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}