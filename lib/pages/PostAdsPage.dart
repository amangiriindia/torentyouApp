import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../consts.dart';
import '../pageutills/myAdspage.dart';

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
  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  List<Map<String, dynamic>> categories = [];
  List<Map<String, dynamic>> subcategories = [];
  String? selectedCategory;
  String? selectedSubCategory;
  bool? packageOption;

  // Controllers for input fields
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController monthlyRentalController = TextEditingController();
  final TextEditingController depositController = TextEditingController();
  final TextEditingController tagsController = TextEditingController();
  final TextEditingController shortDescriptionController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController stockController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCategories();
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

  Future<void> _pickImage() async {
    final XFile? selectedImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = selectedImage;
    });
  }

  Future<void> fetchCategories() async {
    const url = '${AppConstant.API_URL}api/v1/category/all-category';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          setState(() {
            categories = List<Map<String, dynamic>>.from(data['results'].map((category) {
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
    final url = '${AppConstant.API_URL}api/v1/subcategory/single-subcategory/$categoryId';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          setState(() {
            subcategories = List<Map<String, dynamic>>.from(data['data'].map((subcategory) {
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

  Future<String?> uploadImageToFirebase(XFile? image) async {
    if (image == null) return null;

    try {
      // Create a reference to Firebase Storage
      FirebaseStorage storage = FirebaseStorage.instance;

      // Create a unique filename for the image
      String fileName = DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';

      // Upload the image to Firebase Storage
      Reference ref = storage.ref().child('ads_images/$fileName');
      UploadTask uploadTask = ref.putFile(File(image.path));

      // Wait for the upload to complete
      TaskSnapshot snapshot = await uploadTask;

      // Get the image URL
      String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> postProduct() async {
    // Validate required fields
    if (_image == null ||
        productNameController.text.isEmpty ||
        selectedCategory == null ||
        selectedSubCategory == null ||
        locationController.text.isEmpty ||
        monthlyRentalController.text.isEmpty ||
        depositController.text.isEmpty ||
        stockController.text.isEmpty ||
        packageOption == null) {

      // Show a snackbar or dialog to notify the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    // Upload image
    String? imageUrl = await uploadImageToFirebase(_image);

    if (imageUrl == null) {
      // Handle error if image upload fails
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to upload image')),
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

    // Prepare the data
    Map<String, dynamic> data = {
      "seller_id": 1, // Replace with actual seller_id
      "category_id": int.parse(selectedCategory!),
      "subcategory": int.parse(selectedSubCategory!),
      "product_name": productNameController.text,
      "monthly_rental": monthlyRental,
      "deposit": deposit,
      "description": descriptionController.text,
      "tags": tagsController.text,
      "packages": packageOption == true ? "Yes" : "No", // Adjust as per API expectation
      "short_description": shortDescriptionController.text,
      "location": locationController.text,
      "status": 1, // Assuming status is fixed
      "stock": stock,
      "image": imageUrl,
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
          // Show success message or navigate
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
          // Handle API error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${responseData['message']}')),
          );
        }
      } else {
        // Handle non-200 response
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to post product: ${response.statusCode}')),
        );
      }
    } catch (e) {
      // Handle network or parsing errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
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
              value: selectedCategory != null && categories.any((category) => category['id'].toString() == selectedCategory)
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
                  fetchSubCategories(value!); // Fetch subcategories when category is selected
                });
              },
              decoration: _inputDecoration(hintText: 'Select Category'),
            ),

            const SizedBox(height: 20),
            const _Label(text: 'Subcategory*'),
            DropdownButtonFormField<String>(
              value: selectedSubCategory != null && subcategories.any((subcategory) => subcategory['id'].toString() == selectedSubCategory)
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

            const SizedBox(height: 20),
            const _Label(text: 'Location*'),
            _InputField(
              hintText: 'Enter location',
              controller: locationController,
            ),

            const SizedBox(height: 20),
            const _Label(text: 'Product Image*'),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _image != null
                    ? Image.file(
                  File(_image!.path),
                  fit: BoxFit.cover,
                )
                    : const Icon(
                  Icons.camera_alt,
                  color: Colors.grey,
                  size: 50,
                ),
              ),
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
            const _Label(text: 'Description'),
            _InputField(
              hintText: 'Enter detailed description',
              controller: descriptionController,
              maxLines: 5,
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
