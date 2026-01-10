// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pawpal/models/petservices.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/views/loginscreen.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/views/mydonationsscreen.dart';
import 'package:pawpal/views/submitpetscreen.dart';
import 'package:pawpal/views/petdetailsscreen.dart';
import 'package:pawpal/views/profilepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final User? user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late double screenWidth, screenHeight;
  late List<PetService> allPets;
  late List<PetService> filteredPets;
  late String status;
  late DateFormat formatter;
  late String selectedTypeFilter;
  late List<String> petTypeFilter;
  late TextEditingController searchController;
  int numofpage = 1;
  int curpage = 1;
  int numofresult = 0;
  var color;

  @override
  void initState() {
    // Initialize all data variables
    allPets = [];
    filteredPets = [];
    status = "Loading...";
    formatter = DateFormat('dd/MM/yyyy hh:mm a');
    selectedTypeFilter = "All";
    petTypeFilter = ["All", "Cat", "Dog", "Rabbit", "Others"];
    searchController = TextEditingController();
    super.initState();

    // Check if user is logged in
    if (widget.user == null ||
        widget.user?.user_id == null ||
        widget.user?.user_id == '0') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _logout();
      });
      return;
    }

    // Load pets from API
    loadAllPublicPets();
  }

  @override
  void dispose() {
    // Clean up controller
    searchController.dispose();
    super.dispose();
  }

  // ================= LOAD DATA =================
  // Fetch all pets from API
  void loadAllPublicPets() {
    allPets.clear();
    filteredPets.clear();
    setState(() {
      status = "Loading...";
    });

    http
        .get(
          Uri.parse(
            '${MyConfig.baseUrl}/pawpal/api/get_my_pets.php',
          ),
        )
        .then((response) {
          print("API Response: ${response.body}");

          if (response.statusCode == 200) {
            var jsonResponse = jsonDecode(response.body);

            if (jsonResponse['status'] == true &&
                jsonResponse['data'] != null) {
              // Parse pets data
              setState(() {
                allPets.clear();
                for (var item in jsonResponse['data']) {
                  allPets.add(PetService.fromJson(item));
                }
                // Initialize filtered list with all pets
                filteredPets = List.from(allPets);
                status = allPets.isEmpty ? "No pets available" : "";
              });
            } else {
              // No data returned
              setState(() {
                allPets.clear();
                filteredPets.clear();
                status = jsonResponse['message'] ?? "No pets found";
              });
            }
          } else {
            // API request failed
            setState(() {
              allPets.clear();
              filteredPets.clear();
              status = "Failed to load pets";
            });
          }
        });
  }

  // ================= FILTER & SEARCH =================
  // Apply filter and search to pets list
  void applyFiltersAndSearch() {
    setState(() {
      filteredPets = allPets.where((pet) {
        // Check if pet type matches filter
        bool typeMatch = selectedTypeFilter == "All" ||
            pet.petType.toString() == selectedTypeFilter;

        // Check if pet name matches search query
        bool searchMatch = searchController.text.isEmpty ||
            pet.petName
                .toString()
                .toLowerCase()
                .contains(searchController.text.toLowerCase());

        return typeMatch && searchMatch;
      }).toList();
    });
  }

  // Execute search query
  void _performSearch(String query) {
    Navigator.pop(context);

    if (query.trim().isEmpty) {
      searchController.clear();
      applyFiltersAndSearch();
    } else {
      searchController.text = query.trim();
      applyFiltersAndSearch();
    }
  }

  // Show search dialog
  void showSearchDialog() {
    TextEditingController tempSearchController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Search Pets",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: tempSearchController,
                  autofocus: true,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (value) {
                    _performSearch(value);
                  },
                  decoration: InputDecoration(
                    hintText: "e.g. Kitty, Mochi, Rabitty",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 72, 38, 44),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        _performSearch(tempSearchController.text);
                      },
                      child: const Text("Search"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ================= NAVIGATION & DIALOGS =================
  // Navigate to pet details screen
  void navigateToPetDetails(PetService pet) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PetDetailsScreen(
          pet: pet,
          user: widget.user,
        ),
      ),
    );
  }

  // Show exit confirmation dialog
  Future<bool> _showExitDialog() async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text("Exit App"),
            content: const Text("Are you sure you want to exit PawPal?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("Exit"),
              ),
            ],
          ),
        ) ??
        false;
  }

  // Logout and clear preferences
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  // ================= HELPERS =================
  // Get first image URL from pet
  String? getFirstImageUrl(PetService pet) {
    if (pet.imagePaths == null || pet.imagePaths!.isEmpty) {
      return null;
    }

    var images = jsonDecode(pet.imagePaths!) as List;
    if (images.isNotEmpty) {
      String firstImage = images[0].toString().trim();
      return '${MyConfig.baseUrl}/pawpal/$firstImage';
    }

    return null;
  }

  // Get color based on pet category
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

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    final contentWidth = screenWidth > 900 ? 900.0 : screenWidth;

    return WillPopScope(
      onWillPop: () async {
        return await _showExitDialog();
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: buildModernAppBar(),
        body: Center(
          child: SizedBox(
            width: contentWidth,
            child: Column(
              children: [
                // Search bar
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) {
                      applyFiltersAndSearch();
                    },
                    decoration: InputDecoration(
                      hintText: 'Search pet name...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 15),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                // Filter dropdown
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      Text(
                        "Filter by Type:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: DropdownButton<String>(
                          value: selectedTypeFilter,
                          isExpanded: true,
                          items: petTypeFilter.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedTypeFilter = newValue ?? "All";
                            });
                            applyFiltersAndSearch();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Pet list
                Expanded(
                  child: allPets.isEmpty
                      ? _buildEmptyState()
                      : _buildPetList(),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: (widget.user != null &&
                    widget.user?.user_id != null &&
                    widget.user?.user_id != '0')
            ? Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color.fromARGB(255, 72, 38, 44),
                      const Color.fromARGB(255, 120, 60, 70),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 72, 38, 44).withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: FloatingActionButton.extended(
                  backgroundColor: Colors.transparent,
                  foregroundColor: const Color.fromARGB(255, 255, 244, 215),
                  elevation: 0,
                  icon: const Icon(Icons.add),
                  label: const Text("Add Pet"),
                  onPressed: () async {
                    var result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Submitpetscreen(user: widget.user),
                      ),
                    );
                    if (result == true) {
                      loadAllPublicPets();
                    }
                  },
                ),
              )
            : null,
      ),
    );
  }

  // ================= WIDGETS =================
  Widget _buildPetList() {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: filteredPets.length,
      itemBuilder: (context, index) {
        String? firstImageUrl = getFirstImageUrl(filteredPets[index]);
        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => navigateToPetDetails(filteredPets[index]),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  // Image thumbnail
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 110,
                      height: 90,
                      color: Colors.grey.shade200,
                      child: firstImageUrl != null
                          ? Image.network(
                              firstImageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.pets,
                                  size: 50,
                                  color: Colors.grey,
                                );
                              },
                            )
                          : Icon(
                              Icons.pets,
                              size: 40,
                              color: Colors.grey,
                            ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Text details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Pet name
                        Text(
                          filteredPets[index].petName.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        // Pet type
                        Text(
                          "Type: ${filteredPets[index].petType.toString()}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Pet age
                        Text(
                          "Age: ${filteredPets[index].petAge.toString()}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Category color label
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: getCategoryColor(
                                    filteredPets[index].category)
                                .withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            filteredPets[index].category.toString(),
                            style: TextStyle(
                              fontSize: 12,
                              color: getCategoryColor(
                                  filteredPets[index].category),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.pets, size: 72, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            status.isEmpty ? "No pets available" : status,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  AppBar buildModernAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: const Color.fromARGB(255, 255, 244, 215),
      titleSpacing: 16,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color.fromARGB(255, 72, 38, 44),
              const Color.fromARGB(255, 120, 60, 70),
              const Color.fromARGB(255, 200, 150, 160),
            ],
          ),
        ),
      ),
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "PawPal",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 2),
          Text(
            "Pet Adoption & Donation",
            style: TextStyle(fontSize: 11, color: Colors.white70),
          ),
        ],
      ),
      actions: [
        _buildAppBarIcon(
          icon: Icons.refresh,
          tooltip: "Refresh",
          onTap: () => loadAllPublicPets(),
        ),
        if (widget.user != null && widget.user?.user_id != '0')
          _buildAppBarIcon(
            icon: Icons.volunteer_activism,
            tooltip: "My Donations",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyDonationsScreen(user: widget.user),
                ),
              );
            },
          ),
        if (widget.user != null && widget.user?.user_id != '0')
          _buildAppBarIcon(
            icon: Icons.person,
            tooltip: "Profile",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(user: widget.user!),
                ),
              );
            },
          ),
        _buildAppBarIcon(
          icon: Icons.logout,
          tooltip: "Logout",
          onTap: _logout,
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildAppBarIcon({
    required IconData icon,
    required VoidCallback onTap,
    String? tooltip,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Tooltip(
          message: tooltip ?? '',
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20),
          ),
        ),
      ),
    );
  }
}