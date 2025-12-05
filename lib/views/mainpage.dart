import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pawpal/models/petservices.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/views/loginscreen.dart';
import 'package:pawpal/views/submitpetscreen.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  final User? user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<PetService> listServices = [];
  String status = "Loading...";
  DateFormat formatter = DateFormat('dd/MM/yyyy hh:mm a');
  late double screenWidth, screenHeight;
  int numofpage = 1;
  int curpage = 1;
  int numofresult = 0;
  var color;
  
  @override
  void initState() {
    super.initState();
    loadServices('');
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    if (screenWidth > 600) {
      screenWidth = 600;
    } else {
      screenWidth = screenWidth;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('My Pets Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearchDialog();
            },
          ),
          IconButton(
            onPressed: () {
              loadServices('');
            },
            icon: Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            icon: Icon(Icons.login),
          ),
        ],
      ),
      body: Center(
        child: SizedBox(
          width: screenWidth,
          child: Column(
            children: [
              listServices.isEmpty
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
                      child: ListView.builder(
                        itemCount: listServices.length,
                        itemBuilder: (BuildContext context, int index) {
                          // Get first image URL
                          String? firstImageUrl = getFirstImageUrl(listServices[index]);
                          
                          return Card(
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // IMAGE
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      width: screenWidth * 0.28,
                                      height: screenWidth * 0.22,
                                      color: Colors.grey[200],
                                      child: firstImageUrl != null
                                          ? Image.network(
                                              firstImageUrl,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Icon(
                                                  Icons.pets,
                                                  size: 40,
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

                                  // TEXT AREA
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // TITLE
                                        Text(
                                          listServices[index].petName.toString(),
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),

                                        const SizedBox(height: 4),

                                        // TYPE
                                        Text(
                                          "Type: ${listServices[index].petType.toString()}",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),

                                        const SizedBox(height: 4),

                                        // DESCRIPTION EXCERPT
                                        Text(
                                          listServices[index].description != null
                                              ? (listServices[index].description!.length > 50
                                                  ? "${listServices[index].description!.substring(0, 50)}..."
                                                  : listServices[index].description!)
                                              : "",
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.black54,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),

                                        const SizedBox(height: 6),

                                        // CATEGORY TAG
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.blueGrey.withOpacity(0.15),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            listServices[index].category.toString(),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.blueGrey,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // TRAILING ARROW BUTTON
                                  IconButton(
                                    onPressed: () {
                                      showDetailsDialog(index);
                                    },
                                    icon: const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
              // Pagination builder
              if (numofpage > 1)
                SizedBox(
                  height: screenHeight * 0.05,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: numofpage,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      color = (curpage - 1) == index ? Colors.red : Colors.black;
                      return TextButton(
                        onPressed: () {
                          curpage = index + 1;
                          loadServices('');
                        },
                        child: Text(
                          (index + 1).toString(),
                          style: TextStyle(color: color, fontSize: 18),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (widget.user?.user_id == null || widget.user?.user_id == '0') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Please login first to submit a pet"),
                backgroundColor: Colors.red,
              ),
            );
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          } else {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Submitpetscreen(user: widget.user),
              ),
            );
            loadServices('');
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void loadServices(String searchQuery) {
    listServices.clear();
    setState(() {
      status = "Loading...";
    });
    
    // Check if user is logged in
    if (widget.user?.user_id == null || widget.user?.user_id == '0') {
      setState(() {
        listServices.clear();
        status = "Please login to view your pets";
      });
      return;
    }
    
    http.get(
      Uri.parse(
        '${MyConfig.baseUrl}/pawpal/api/get_my_pets.php'
        '?user_id=${widget.user!.user_id}'
        '&search=$searchQuery'
        '&curpage=$curpage'
      ),
    ).then((response) {
      print("API Response Status: ${response.statusCode}");
      print("API Response Body: ${response.body}");
      
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        print("Parsed JSON: $jsonResponse");
        
        // Check if status is true (boolean)
        if (jsonResponse['status'] == true && 
            jsonResponse['data'] != null) {
          
          listServices.clear();
          for (var item in jsonResponse['data']) {
            listServices.add(PetService.fromJson(item));
          }
          
          numofpage = jsonResponse['numofpage'] != null 
              ? int.parse(jsonResponse['numofpage'].toString()) 
              : 1;
          numofresult = jsonResponse['numberofresult'] != null
              ? int.parse(jsonResponse['numberofresult'].toString())
              : listServices.length;
          
          setState(() {
            if (listServices.isEmpty) {
              status = "No submission yet";
            } else {
              status = "";
            }
          });
        } else {
          // No data or failed
          setState(() {
            listServices.clear();
            status = jsonResponse['message'] ?? "No pets found";
          });
        }
      } else {
        // Request failed
        setState(() {
          listServices.clear();
          status = "Failed to load pets. Error: ${response.statusCode}";
        });
      }
    }).catchError((error) {
      print("Error Details: $error");
      setState(() {
        listServices.clear();
        status = "Error loading pets: $error";
      });
    });
  }

  // Helper function to get first image URL
  String? getFirstImageUrl(PetService pet) {
    if (pet.imagePaths == null || pet.imagePaths!.isEmpty) {
      return null;
    }
    
    try {
      // Try to parse as JSON array first
      var images = jsonDecode(pet.imagePaths!) as List;
      if (images.isNotEmpty) {
        String firstImage = images[0].toString().trim();
        return '${MyConfig.baseUrl}/pawpal/$firstImage';
      }
    } catch (e) {
      // If not JSON, try comma-separated
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

  void showSearchDialog() {
    TextEditingController searchController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Search Pets'),
          content: TextField(
            controller: searchController,
            decoration: InputDecoration(hintText: 'Search by name, type, or category'),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Search'),
              onPressed: () {
                String search = searchController.text;
                curpage = 1;
                loadServices(search);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showDetailsDialog(int index) {
    PetService pet = listServices[index];
    String? firstImageUrl = getFirstImageUrl(pet);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(pet.petName.toString()),
          content: SizedBox(
            width: screenWidth * 0.8,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // IMAGE
                  if (firstImageUrl != null)
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[200],
                      ),
                      child: Image.network(
                        firstImageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.pets,
                            size: 100,
                            color: Colors.grey,
                          );
                        },
                      ),
                    ),
                  
                  SizedBox(height: 15),
                  
                  // PET DETAILS
                  ListTile(
                    leading: Icon(Icons.pets, color: Colors.blue),
                    title: Text("Type"),
                    subtitle: Text(pet.petType.toString()),
                  ),
                  
                  ListTile(
                    leading: Icon(Icons.category, color: Colors.green),
                    title: Text("Category"),
                    subtitle: Text(pet.category.toString()),
                  ),
                  
                  ListTile(
                    leading: Icon(Icons.description, color: Colors.orange),
                    title: Text("Description"),
                    subtitle: Text(pet.description ?? "No description"),
                  ),
                  
                  if (pet.lat != null && pet.lng != null)
                    ListTile(
                      leading: Icon(Icons.location_on, color: Colors.red),
                      title: Text("Location"),
                      subtitle: Text("Lat: ${pet.lat}, Lng: ${pet.lng}"),
                    ),
                  
                  if (pet.createdAt != null)
                    ListTile(
                      leading: Icon(Icons.calendar_today, color: Colors.purple),
                      title: Text("Submitted On"),
                      subtitle: Text(pet.createdAt.toString()),
                    ),
                  
                  SizedBox(height: 10),
                  
                  // CONTACT INFO
                  if (pet.userPhone != null || pet.userEmail != null)
                    Card(
                      color: Colors.grey[50],
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Contact Info",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 8),
                            if (pet.userName != null)
                              Text("Name: ${pet.userName}"),
                            if (pet.userPhone != null)
                              Text("Phone: ${pet.userPhone}"),
                            if (pet.userEmail != null)
                              Text("Email: ${pet.userEmail}"),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}