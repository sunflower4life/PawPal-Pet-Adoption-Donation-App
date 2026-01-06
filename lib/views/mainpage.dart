import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/models/petservices.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/views/loginscreen.dart';
import 'package:pawpal/views/submitpetscreen.dart';
import 'package:pawpal/views/petdetailsscreen.dart';

class HomeScreen extends StatefulWidget {
  final User? user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<PetService> allPets = []; // All pets from database
  List<PetService> filteredPets = []; // Filtered/searched pets
  String status = "Loading...";
  late double screenWidth, screenHeight;
  
  // Filter variables
  String selectedTypeFilter = "All"; // Filter dropdown value
  List<String> petTypeFilter = ["All", "Cat", "Dog", "Rabbit", "Others"];
  
  // Search variable sbb dlm assignment nk search bar
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load all public pets when page opens
    loadAllPublicPets();
  }

  @override
  Widget build(BuildContext context) {
    print("HomeScreen built with user: ${widget.user?.user_id}");
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    if (screenWidth > 600) {
      screenWidth = 600;
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('All Pets'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              loadAllPublicPets();
            },
          ),
          /*if (widget.user?.user_id != null && widget.user?.user_id != '0')
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                // Navigate to profile screen (you'll create this later)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Profile screen coming soon")),
                );
              },
            ),*/
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: SizedBox(
          width: screenWidth,
          child: Column(
            children: [
              // SEARCH BAR
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    applyFiltersAndSearch();
                  },
                  decoration: InputDecoration(
                    hintText: 'Search pet name...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 15),
                  ),
                ),
              ),

              // FILTER DROPDOWN
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

              SizedBox(height: 10),

              // PET LIST
              allPets.isEmpty
                ? Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.pets, size: 64, color: Colors.grey),
                          SizedBox(height: 12),
                          Text(
                            status,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  )
                : Expanded(
                    child: filteredPets.isEmpty
                        ? Center(
                            child: Text(
                              "No pets match your search/filter",
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            itemCount: filteredPets.length,
                            itemBuilder: (BuildContext context, int index) {
                              String? firstImageUrl =
                                getFirstImageUrl(filteredPets[index]);

                              return GestureDetector(
                                onTap: () {
                                  // Navigate to Pet Details screen
                                  navigateToPetDetails(filteredPets[index]);
                                },
                                child: Card(
                                  elevation: 4,
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 6,
                                    horizontal: 8,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // IMAGE THUMBNAIL
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Container(
                                            width: screenWidth * 0.25,
                                            height: screenWidth * 0.25,
                                            color: Colors.grey[200],
                                            child: firstImageUrl != null
                                                ? Image.network(
                                                    firstImageUrl,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context,
                                                      error,
                                                      stackTrace) {
                                                      return Icon(
                                                        Icons.pets,size: 50,
                                                        color: Colors.grey,
                                                      );
                                                    },
                                                  )
                                                : Icon(
                                                    Icons.pets,size: 40,
                                                    color: Colors.grey,
                                                  ),
                                            ),
                                          ),

                                          const SizedBox(width: 12),

                                          // TEXT DETAILS
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // PET NAME
                                                Text(
                                                  filteredPets[index].petName.toString(),
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),

                                                const SizedBox(height: 4),

                                                // PET TYPE
                                                Text(
                                                  "Type: ${filteredPets[index].petType.toString()}",
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black87,
                                                  ),
                                                ),

                                                const SizedBox(height: 4),

                                                // PET AGE
                                                Text(
                                                  "Age: ${filteredPets[index].petAge.toString()}",
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black87,
                                                  ),
                                                ),

                                                const SizedBox(height: 6),

                                                // CATEGORY BADGE
                                                Container(
                                                  padding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: getCategoryColor(
                                                            filteredPets[index]
                                                                .category)
                                                        .withOpacity(0.2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: Text(
                                                    filteredPets[index]
                                                        .category
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      color:
                                                          getCategoryColor(
                                                              filteredPets[index].category),
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                );
                              },
                            ),
                    ),
            ],
          ),
        ),
      ),
      floatingActionButton:(widget.user != null && 
                      widget.user?.user_id != null &&
                      widget.user?.user_id != '0')
          ? FloatingActionButton(
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
              child: Icon(Icons.add),
              backgroundColor:
                  const Color.fromARGB(255, 242, 194, 121),
            )
          : null,
    );
  }

  // Load ALL public pets from API
  void loadAllPublicPets() {
    setState(() {
      status = "Loading...";
    });

    http.get(
      Uri.parse(
        '${MyConfig.baseUrl}/pawpal/api/get_my_pets.php',
      ),
    ).then((response) {
      print("API Response: ${response.body}");

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status'] == true &&
            jsonResponse['data'] != null) {
          setState(() {
            allPets.clear();
            for (var item in jsonResponse['data']) {
              allPets.add(PetService.fromJson(item));
            }
            // Apply initial filter
            filteredPets = List.from(allPets);
            status = allPets.isEmpty ? "No pets available" : "";
          });
        } else {
          setState(() {
            allPets.clear();
            status = jsonResponse['message'] ?? "No pets found";
          });
        }
      } else {
        setState(() {
          status = "Failed to load pets";
        });
      }
    });
  }

  // Apply search and filter
  void applyFiltersAndSearch() {
    setState(() {
      filteredPets = allPets.where((pet) {
        // Filter by type
        bool typeMatch = selectedTypeFilter == "All" ||
            pet.petType.toString() == selectedTypeFilter;

        // Filter by search query
        bool searchMatch = searchController.text.isEmpty ||
            pet.petName
                .toString()
                .toLowerCase()
                .contains(searchController.text.toLowerCase());

        return typeMatch && searchMatch;
      }).toList();
    });
  }

  // Get first image URL
  String? getFirstImageUrl(PetService pet) {
    if (pet.imagePaths == null || pet.imagePaths!.isEmpty) {
      return null;
    }

    try {
      var images = jsonDecode(pet.imagePaths!) as List;
      if (images.isNotEmpty) {
        String firstImage = images[0].toString().trim();
        return '${MyConfig.baseUrl}/pawpal/$firstImage';
      }
    } catch (e) {
      try {
        var paths = pet.imagePaths!.split(',');
        if (paths.isNotEmpty && paths[0].trim().isNotEmpty) {
          String firstImage = paths[0].trim();
          return '${MyConfig.baseUrl}/pawpal/$firstImage';
        }
      } catch (e2) {
        print("Error parsing image paths: $e2");
      }
    }

    return null;
  }

  // Get category color
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

  // Navigate to Pet Details Screen
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
}