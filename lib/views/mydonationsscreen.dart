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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              loadMyDonations();
            },
          ),
        ]
      ),
      backgroundColor: Colors.grey[50],
      body: Center(
        child: SizedBox(
          width: screenWidth,
          child: Column(
            children: [
              // SUMMARY CARD
              if (donationsList.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color.fromARGB(255, 72, 38, 44),
                          const Color.fromARGB(255, 120, 60, 70),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 72, 38, 44).withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildSummaryItem(
                            icon: Icons.favorite,
                            label: "Total Donations",
                            value: donationsList.length.toString(),
                            color: Colors.white,
                          ),
                          Container(
                            width: 1,
                            height: 60,
                            color: Colors.white.withOpacity(0.3),
                          ),
                          _buildSummaryItem(
                            icon: Icons.monetization_on,
                            label: "Money Donated",
                            value: "RM ${totalDonated.toStringAsFixed(2)}",
                            color: Colors.amber,
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
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[200],
                              ),
                              child: Icon(Icons.favorite_border, size: 64, color: Colors.grey[400]),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              status,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        itemCount: donationsList.length,
                        itemBuilder: (context, index) {
                          var donation = donationsList[index];
                          return _buildDonationCard(donation);
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, size: 32, color: color),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildDonationCard(Map<String, dynamic> donation) {
    String donationType = donation['donation_type'] ?? "";
    Color typeColor = getDonationTypeColor(donationType);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER ROW
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          donation['pet_name'] ?? "Unknown Pet",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 72, 38, 44),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Donated on ${donation['created_at'] ?? ''}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: typeColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      donationType,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: typeColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // DONATION DETAILS
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: typeColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getDonationIcon(donationType),
                        color: typeColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            donationType == 'Money' ? 'Amount Donated' : 'Description',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 4),
                          if (donationType == 'Money')
                            Text(
                              "RM ${donation['amount'] ?? '0'}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: typeColor,
                              ),
                            )
                          else
                            Text(
                              donation['description'] ?? "No description",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                                height: 1.4,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getDonationIcon(String type) {
    switch (type) {
      case "Food":
        return Icons.fastfood;
      case "Medical":
        return Icons.local_hospital;
      case "Money":
        return Icons.monetization_on;
      default:
        return Icons.favorite;
    }
  }

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