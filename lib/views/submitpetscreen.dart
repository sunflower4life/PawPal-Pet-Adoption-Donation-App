import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';

class Submitpetscreen extends StatefulWidget {
  final User? user;

  const Submitpetscreen({super.key, required this.user});

  @override
  State<Submitpetscreen> createState() => _SubmitpetscreenState();
}

class _SubmitpetscreenState extends State<Submitpetscreen> {
  List<String> petType = [
    'Cat', 
    'Dog', 
    'Rabbit', 
    'Others'];
  List<String> category = [
    'Adoption', 
    'Donation Request', 
    'Help/Rescue'];

  TextEditingController petnamecontroller = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  String selectedPet = '';
  String selectedCategory = '';

  String lat = "";
  String lng = "";
  late Position myposition;

  /// MAX 3 IMAGES
  List<File> imageFiles = [];
  late double height, width;

  //for dot indicator at bottom of image slider to tell user that they can slide to see the next image
  PageController pageController = PageController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    if (width > 600) width = 600;

    return Scaffold(
      appBar: AppBar(
        title: Text('Pet Service'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: width,
            child: SingleChildScrollView(
              child: Column(
                children: [

                  //IMAGE PICKER AREA
                  GestureDetector(
                    onTap: pickImageDialog,
                    child: Container(
                      width: width,
                      height: height / 3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey.shade200,
                        border: Border.all(color: Colors.grey.shade400),
                      ),

                      child: imageFiles.isEmpty
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.camera_alt, size: 80, color: Colors.grey),
                                SizedBox(height: 10),
                                Text("Tap to add images (max 3)",
                                    style: TextStyle(color: Colors.grey)),
                              ],
                            )
                          : PageView(
                              controller: pageController,//untuk dot indicator
                              onPageChanged: (i) {
                                setState(() {
                                  currentIndex = i;
                                });
                              },
                              children: imageFiles
                                  .map((file) => Image.file(file, fit: BoxFit.cover))
                                  .toList(),
                            ),
                    ),
                  ),
                  SizedBox(height: 10),

                  //DOT INDICATOR
                  if (imageFiles.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(imageFiles.length, (index) {
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          width: currentIndex == index ? 12 : 8,
                          height: currentIndex == index ? 12 : 8,
                          decoration: BoxDecoration(
                            color: currentIndex == index ? Colors.black : Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        );
                      }),
                    ),
                  SizedBox(height: 10),

                  //PET NAME
                  TextField(
                    controller: petnamecontroller,
                    decoration: InputDecoration(
                      labelText: 'Pet Name',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  SizedBox(height: 10),

                  //PET TYPE 
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Pet Types',
                      border: OutlineInputBorder(),
                    ),
                    items: petType.map((String value) {
                      return DropdownMenuItem(value: value, child: Text(value));
                    }).toList(),
                    onChanged: (value) => setState(() => selectedPet = value!),
                  ),

                  SizedBox(height: 10),

                  //CATEGORY
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    items: category.map((String value) {
                      return DropdownMenuItem(value: value, child: Text(value));
                    }).toList(),
                    onChanged: (value) => setState(() => selectedCategory = value!),
                  ),

                  SizedBox(height: 10),

                  //DESCRIPTION
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),

                  SizedBox(height: 10),

                  //LOCATION
                  TextField(
                    controller: locationController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Location',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () async {
                          myposition = await _determinePosition();
                          lat = myposition.latitude.toString();
                          lng = myposition.longitude.toString();

                          List<Placemark> placemarks = await placemarkFromCoordinates(
                            myposition.latitude,
                            myposition.longitude,
                          );

                          Placemark place = placemarks[0];
                          locationController.text =
                              "${place.name},\n${place.street},\n${place.postalCode},${place.locality},\n${place.administrativeArea},${place.country}";

                          setState(() {});
                        },
                        icon: Icon(Icons.gps_fixed),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  //SUBMIT BUTTON 
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 72, 38, 44),
                      minimumSize: Size(width, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: showSubmitDialog,
                    child: Text("Submit", style: TextStyle(color: Colors.white)),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //pick image from camera/gallery
  void pickImageDialog() {
  if (imageFiles.length >= 3) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Maximum 3 images allowed"), backgroundColor: Colors.red),
    );
    return;
  }

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Pick Image'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                openCamera();
              },
            ),
            ListTile(
              leading: Icon(Icons.image),
              title: Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                openGallery();
              },
            ),
          ],
        ),
      );
    },
  );
}

Future<void> openCamera() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.camera);

  if (pickedFile != null) {
    File img = File(pickedFile.path);
    imageFiles.add(img);
    setState(() {});
  }
}

Future<void> openGallery() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
  if (imageFiles.length < 3) {
    setState(() {
      imageFiles.add(File(pickedFile.path));
    });
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Maximum 3 images allowed")),
    );
  }
  }
}

  Future<void> cropImage(File file) async {
    CroppedFile? cropped = await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatio: CropAspectRatio(ratioX: 4, ratioY: 3),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.deepPurple,
          toolbarWidgetColor: Colors.white,
        )
      ],
    );

    if (cropped != null) {
      setState(() => imageFiles.add(File(cropped.path)));
    }
  }

  // Permission check for GPS
  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return Future.error("Location services disabled.");

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error("Location permanently denied");
    }

    return await Geolocator.getCurrentPosition();
  }

  void showSubmitDialog() {
    // VALIDATION 1: PET NAME
    if (petnamecontroller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter Pet Name"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // VALIDATION 2: PET TYPE
    if (selectedPet.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please choose a Pet Type"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    //VALIDATION 3: PET CATEGORY
    if (selectedCategory.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please choose Pet Category"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // VALIDATION 4: DESCRIPTION
    if (descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter description"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // VALIDATION 5: IMAGE
    if (imageFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select at least 1 image"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    // VALIDATION 6: IMAGE
    if (imageFiles.length > 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Maximum 3 images allowed"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    //VALIDATION 7: DESCRIPTION <10
    if (descriptionController.text.length < 10) {
      SnackBar snackBar = const SnackBar(
        content: Text('Description must be minimun 10 characters long'),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    
    // VALIDATION 8: LOCATION
    if (lat.isEmpty || lng.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please tap GPS icon to get your location"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Submit Pet"),
        content: Text("Are you sure?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              submitPet();
            },
            child: Text("Submit"),
          ),
        ],
      ),
    );
  }

  //send data to API
  void submitPet() {
    
    List<String> encodedImages = [];
    for (var img in imageFiles) {
      encodedImages.add(base64Encode(img.readAsBytesSync()));
    }

    // Assign image1, image2, image3
    String? img1 = encodedImages.length > 0 ? encodedImages[0] : "";
    String? img2 = encodedImages.length > 1 ? encodedImages[1] : "";
    String? img3 = encodedImages.length > 2 ? encodedImages[2] : "";
    http.post(
      Uri.parse('${MyConfig.baseUrl}/pawpal/api/submit_pet.php'),
      
      body: {
        "user_id": widget.user!.user_id.toString(),
        "pet_name": petnamecontroller.text.trim(),
        "pet_type": selectedPet,
        "category": selectedCategory,
        "description": descriptionController.text.trim(),
        "lat": lat,
        "lng": lng,
        "image1": img1,
        "image2": img2,
        "image3": img3,
      },
    ).then((response) {
      print("RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);

        if (res['status'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Pet submitted successfully"),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true); 
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(res['message']),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    });
  }

}
