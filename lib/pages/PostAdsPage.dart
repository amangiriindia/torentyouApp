import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:try_test/constant/user_constant.dart';
import '../consts.dart';
import '../pageutills/myAdspage.dart';
import '../service/google_map_helper.dart';

class PostAdsPage extends StatelessWidget {
  const PostAdsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const PostAdsContent(),
    );
  }
}

class PostAdsContent extends StatefulWidget {
  const PostAdsContent({Key? key}) : super(key: key);

  @override
  _PostAdsContentState createState() => _PostAdsContentState();
}

class _PostAdsContentState extends State<PostAdsContent> {
  List<XFile?> _images = []; // List to hold multiple images
  final ImagePicker _picker = ImagePicker();
  List<Map<String, dynamic>> categories = [];
  List<Map<String, dynamic>> subcategories = [];
  String? selectedCategory;
  String? selectedSubCategory;
  bool? packageOption;
  String? addLatitude;
  String? addLongitude;
  int? userId;
  String? selectedDay;
  String? selectedMonth;
  String duration = "";

  final List<String> days = List.generate(31, (index) => "${index + 1} day");
  final List<String> months =
      List.generate(12, (index) => "${index + 1} month");

  // Controllers for input fields
  final TextEditingController productNameController = TextEditingController();
  late TextEditingController locationController = TextEditingController();
  final TextEditingController monthlyRentalController = TextEditingController();
  final TextEditingController depositController = TextEditingController();
  final TextEditingController tagsController = TextEditingController();
  final TextEditingController shortDescriptionController =
      TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController stockController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCategories();
    _getId();
  }

  Future<void> _getId() async {
    print(UserConstant.NAME);
    userId = UserConstant.USER_ID ?? 1;
    setState(
        () {}); // Call setState to update the UI if `id` is being used there
  }

  @override
  void dispose() {
    productNameController.dispose();
    locationController.dispose();
    monthlyRentalController.dispose();
    depositController.dispose();
    tagsController.dispose();
    shortDescriptionController.dispose();
    descriptionController.dispose();
    stockController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    // Change this method to pick multiple images
    final List<XFile>? selectedImages = await _picker.pickMultiImage();
    if (selectedImages != null) {
      setState(() {
        _images = selectedImages; // Set the state with the selected images
      });
    }
  }

  // Call this method to update latitude and longitude
  Future<void> updateCoordinates() async {
    // Call the function to get updated latitude and longitude
    Map<String, double>? location = await GoogleMapHelper.updateAddressForApi();

    if (location != null) {
      // Update the variables if the location is not null
      addLatitude = location['latitude']?.toString();
      addLongitude = location['longitude']?.toString();

      // Optional: Print the updated values for debugging
      print("Updated Latitude: $addLatitude, Longitude: $addLongitude");
    } else {
      // Handle the case where location could not be retrieved
      print("Failed to update location.");
    }
  }

  Future<void> fetchCategories() async {
    const url = '${AppConstant.API_URL}api/v1/category/all-category';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          setState(() {
            categories =
                List<Map<String, dynamic>>.from(data['results'].map((category) {
              return {
                'id': category['id'] ?? 0,
                'name': category['c_name'],
                'image': category['image'],
              };
            }));
          });
        }
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  Future<void> fetchSubCategories(String categoryId) async {
    final url =
        '${AppConstant.API_URL}api/v1/subcategory/single-subcategory/$categoryId';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          setState(() {
            subcategories =
                List<Map<String, dynamic>>.from(data['data'].map((subcategory) {
              return {
                'id': subcategory['id'],
                'name': subcategory['subcategory_name'],
              };
            }));
          });
        }
      } else {
        throw Exception('Failed to load subcategories');
      }
    } catch (e) {
      print('Error fetching subcategories: $e');
    }
  }

  Future<List<String>> uploadImagesToFirebase(List<XFile?> images) async {
    List<String> imageUrls = []; // To hold all uploaded image URLs

    for (var image in images) {
      if (image == null) continue; // Skip if image is null

      try {
        FirebaseStorage storage = FirebaseStorage.instance;
        String fileName =
            DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';
        Reference ref = storage.ref().child('ads_images/$fileName');
        UploadTask uploadTask = ref.putFile(File(image.path));

        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();
        imageUrls.add(downloadUrl); // Add the download URL to the list
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
    return imageUrls; // Return the list of image URLs
  }

  void _updateLocationFeild() async {
    String location = await GoogleMapHelper.getCurrentLocation();
    updateCoordinates();
    setState(() {
      locationController.text =
          location; // Update the text property of the controller
    });
  }

  Future<void> postProduct() async {
    if (addLatitude == null && addLongitude == null) {
      updateCoordinates();
    }
    if (_images.isEmpty ||
        productNameController.text.isEmpty ||
        selectedCategory == null ||
        selectedSubCategory == null ||
        locationController.text.isEmpty ||
        monthlyRentalController.text.isEmpty ||
        depositController.text.isEmpty ||
        stockController.text.isEmpty ||
        packageOption == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    // Upload images
    List<String> imageUrls = await uploadImagesToFirebase(_images);

    if (imageUrls.isEmpty) {
      // Handle error if image upload fails
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to upload images')),
      );
      return;
    }

    // Parse numeric fields safely
    int? monthlyRental = int.tryParse(monthlyRentalController.text);
    int? deposit = int.tryParse(depositController.text);
    int? stock = int.tryParse(stockController.text);

    if (monthlyRental == null || deposit == null || stock == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid numbers')),
      );
      return;
    }

    // Prepare the data with an array of image URLs
    Map<String, dynamic> data = {
      "seller_id": userId, // Replace with actual seller_id
      "category_id": int.parse(selectedCategory!),
      "subcategory": int.parse(selectedSubCategory!),
      "product_name": productNameController.text,
      "monthly_rental": monthlyRental,
      "deposit": deposit,
      "description": descriptionController.text,
      "tags": tagsController.text,
      "packages": packageOption == true ? "Yes" : "No",
      "short_description": shortDescriptionController.text,
      "location": locationController.text,
      "status": 1, // Assuming status is fixed
      "stock": stock,
      "images": imageUrls, // Send the image URLs as an array
      "addlongtitude": addLongitude,
      "addletitude": addLatitude,
    };

    // Send POST request
    final apiUrl = '${AppConstant.API_URL}api/v1/product/create-product';
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        if (responseData['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product posted successfully')),
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MyAdsPage(),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${responseData['message']}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to post product: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void updateDuration() {
    setState(() {
      duration = "${selectedMonth ?? ""} ${selectedDay ?? ""}".trim();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _Label(text: 'Product Name*'),
            _InputField(
              hintText: 'Enter product name',
              controller: productNameController,
            ),

            const SizedBox(height: 20),
            const _Label(text: 'Category*'),
            DropdownButtonFormField<String>(
              value: selectedCategory != null &&
                      categories.any((category) =>
                          category['id'].toString() == selectedCategory)
                  ? selectedCategory
                  : null,
              items: categories.isEmpty
                  ? [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('No categories available'),
                      ),
                    ]
                  : categories.map((category) {
                      return DropdownMenuItem(
                        value: category['id'].toString(),
                        child: Text(category['name']),
                      );
                    }).toList(),
              onChanged: categories.isEmpty
                  ? null
                  : (value) {
                      setState(() {
                        selectedCategory = value;
                        selectedSubCategory = null; // Reset subcategory
                        fetchSubCategories(
                            value!); // Fetch subcategories when category is selected
                      });
                    },
              decoration: _inputDecoration(hintText: 'Select Category'),
            ),

            const SizedBox(height: 20),
            const _Label(text: 'Subcategory*'),
            DropdownButtonFormField<String>(
              value: selectedSubCategory != null &&
                      subcategories.any((subcategory) =>
                          subcategory['id'].toString() == selectedSubCategory)
                  ? selectedSubCategory
                  : null,
              items: subcategories.isEmpty
                  ? [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('No subcategories available'),
                      ),
                    ]
                  : subcategories.map((subcategory) {
                      return DropdownMenuItem(
                        value: subcategory['id'].toString(),
                        child: Text(subcategory['name']),
                      );
                    }).toList(),
              onChanged: subcategories.isEmpty
                  ? null
                  : (value) {
                      setState(() {
                        selectedSubCategory = value;
                      });
                    },
              decoration: _inputDecoration(hintText: 'Select Subcategory'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed:
                  _updateLocationFeild, // Calls the function to update location
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Row(
                mainAxisSize:
                    MainAxisSize.min, // Keeps the button as small as possible
                children: [
                  Icon(Icons.location_on), // Location icon
                  SizedBox(width: 8), // Spacing between icon and text
                  Text("Get Location"), // Button text
                ],
              ),
            ),
            const SizedBox(height: 20),
            const _Label(text: 'Location*'),
            _InputField(
              hintText: 'Enter location',
              controller: locationController,
            ),
            const SizedBox(height: 20),
            const _Label(text: 'Monthly Rental*'),
            _InputField(
              hintText: 'Enter monthly rental',
              controller: monthlyRentalController,
              prefixText: '₹ ',
            ),

            const SizedBox(height: 20),
            const _Label(text: 'Deposit*'),
            _InputField(
              hintText: 'Enter deposit',
              controller: depositController,
              prefixText: '₹ ',
            ),

            const SizedBox(height: 20),
            const _Label(text: 'Tags'),
            _InputField(
              hintText: 'Enter tags, separated by commas',
              controller: tagsController,
            ),

            const SizedBox(height: 20),
            const _Label(text: 'Short Description'),
            _InputField(
              hintText: 'Enter short description',
              controller: shortDescriptionController,
              maxLines: 3,
            ),

            const SizedBox(height: 20),
            const _Label(text: 'Stock*'),
            _InputField(
              hintText: 'Enter stock',
              controller: stockController,
            ),

            const SizedBox(height: 20),
            const _Label(text: 'Package*'),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text('Yes'),
                    value: true,
                    groupValue: packageOption,
                    onChanged: (value) {
                      setState(() {
                        packageOption = value;
                      });
                    },
                    activeColor: Colors.black,
                  ),
                ),
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text('No'),
                    value: false,
                    groupValue: packageOption,
                    onChanged: (value) {
                      setState(() {
                        packageOption = value;
                      });
                    },
                    activeColor: Colors.black,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            const _Label(text: 'Select Duration'),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedMonth,
                    items: months
                        .map((month) => DropdownMenuItem(
                              value: month,
                              child: Text(month),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedMonth = value;
                        updateDuration();
                      });
                    },
                    decoration: _inputDecoration(hintText: 'Select Month'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedDay,
                    items: days
                        .map((day) => DropdownMenuItem(
                              value: day,
                              child: Text(day),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedDay = value;
                        updateDuration();
                      });
                    },
                    decoration: _inputDecoration(hintText: 'Select Day'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const _Label(text: 'Description'),
            _InputField(
              hintText: 'Enter detailed description',
              controller: descriptionController,
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            const _Label(text: 'Upload Images*'),
            GestureDetector(
              onTap: _pickImages, // Call _pickImages to pick multiple images
              child: Container(
                width: double.infinity,
                height: 100,
                color: Colors.grey[200],
                child: Center(
                  child: Text(
                    'Tap to upload images',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

// Display the selected images with a remove icon and error handling
            Wrap(
              spacing: 8.0,
              children: _images.asMap().entries.map((entry) {
                int index = entry.key; // Get the index of the image
                XFile? image = entry.value; // Get the image

                return Padding(
                  padding: const EdgeInsets.all(
                      2.0), // Add padding of 2px around the image item
                  child: Stack(
                    children: [
                      // Try-catch to handle possible image loading errors
                      if (File(image!.path)
                          .existsSync()) // Check if the file exists
                        Image.file(
                          File(image.path),
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        )
                      else
                        Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey[300],
                          child: Center(
                            child: Icon(
                              Icons.broken_image, // Show a broken image icon
                              color: Colors.red,
                            ),
                          ),
                        ),
                      // Remove icon in the top-right corner
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _images.removeAt(
                                  index); // Remove the image from the list
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                            ),
                            padding: const EdgeInsets.all(4.0),
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16, // Small size for the remove icon
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 30),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryTextColor,
                    AppColors.primaryColor,
                  ],
                ),
              ),
              child: ElevatedButton(
                onPressed: postProduct,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Post',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }
}

class _InputField extends StatelessWidget {
  final String hintText;
  final String? prefixText;
  final int maxLines;
  final TextEditingController controller;

  const _InputField({
    required this.hintText,
    required this.controller,
    this.prefixText,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: hintText,
        prefixText: prefixText,
      ),
      keyboardType:
          prefixText != null ? TextInputType.number : TextInputType.text,
    );
  }
}

InputDecoration _inputDecoration({required String hintText}) {
  return InputDecoration(
    border: const OutlineInputBorder(),
    hintText: hintText,
  );
}
