
import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../constant/user_constant.dart';
import '../consts.dart';
import '../pageutills/myAdspage.dart';
import '../service/google_map_helper.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';

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
  String duration = "";
  String? selectedDurationType; // 'days' or 'months'
  final TextEditingController durationValueController = TextEditingController();

  // Controllers for input fields
  final TextEditingController productNameController = TextEditingController();
  late TextEditingController locationController = TextEditingController();
  final TextEditingController monthlyRentalController = TextEditingController();
  final TextEditingController depositController = TextEditingController();
  final TextEditingController shortDescriptionController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCategories();
    _getId();
    selectedDurationType = 'days'; // Set default value
  }

  Future<void> _getId() async {
    userId = UserConstant.USER_ID ?? 1;
    setState(() {});
  }

  @override
  void dispose() {
    productNameController.dispose();
    locationController.dispose();
    monthlyRentalController.dispose();
    depositController.dispose();
    shortDescriptionController.dispose();
    descriptionController.dispose();
    durationValueController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Select from Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text('Cancel'),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool> _validateImageFile(XFile imageFile) async {
    try {
      final File file = File(imageFile.path);

      if (!await file.exists()) {
        return false;
      }

      final int fileSizeInBytes = await file.length();
      const int maxSizeInBytes = 10 * 1024 * 1024; // 10MB
      if (fileSizeInBytes > maxSizeInBytes) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image file is too large. Max size is 10MB.'),
            backgroundColor: Colors.orange,
          ),
        );
        return false;
      }

      final String extension = imageFile.path.toLowerCase().split('.').last;
      const List<String> supportedFormats = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];
      if (!supportedFormats.contains(extension)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unsupported format: .$extension.'),
            backgroundColor: Colors.orange,
          ),
        );
        return false;
      }

      final Uint8List bytes = await file.readAsBytes();
      final ui.Codec codec = await ui.instantiateImageCodec(bytes);
      await codec.getNextFrame();

      return true;
    } catch (e) {
      print('Image validation error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Corrupted or unsupported image format.'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final List<XFile>? selectedImages = await _picker.pickMultiImage();
      if (selectedImages != null && selectedImages.isNotEmpty) {
        List<XFile> validImages = [];
        int invalidCount = 0;

        for (XFile image in selectedImages) {
          if (await _validateImageFile(image)) {
            validImages.add(image);
          } else {
            invalidCount++;
          }
        }

        if (validImages.isNotEmpty) {
          setState(() {
            _images.addAll(validImages);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${validImages.length} image(s) added successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }

        if (invalidCount > 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$invalidCount image(s) failed to add.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      print('Error selecting images: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error selecting images.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _pickFromCamera() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (photo != null && await _validateImageFile(photo)) {
        setState(() {
          _images.add(photo);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Photo added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('Error taking photo: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error taking photo.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildImageDisplay() {
    if (_images.isEmpty) return const SizedBox.shrink();

    return Container(
      constraints: const BoxConstraints(maxHeight: 120),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _images.asMap().entries.map((entry) {
            int index = entry.key;
            XFile? image = entry.value;

            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: File(image!.path).existsSync()
                          ? Image.file(
                        File(image.path),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      )
                          : Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(
                            Icons.broken_image,
                            color: Colors.red,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _images.removeAt(index);
                        });
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        padding: const EdgeInsets.all(4.0),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 4,
                    left: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<void> _addMoreImages() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.add_photo_alternate),
                title: const Text('Add from Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.add_a_photo),
                title: const Text('Take Another Photo'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.clear_all),
                title: const Text('Clear All Images'),
                onTap: () {
                  Navigator.of(context).pop();
                  _clearAllImages();
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text('Cancel'),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _clearAllImages() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear All Images'),
          content: const Text('Are you sure you want to remove all images?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _images.clear();
                });
                Navigator.of(context).pop();
              },
              child: const Text('Clear All'),
            ),
          ],
        );
      },
    );
  }

  void updateDuration() {
    setState(() {
      if (durationValueController.text.isNotEmpty && selectedDurationType != null) {
        String unit = selectedDurationType == 'days' ? 'day' : 'month';
        String value = durationValueController.text;
        duration = "$value $unit${int.tryParse(value) != null && int.parse(value) > 1 ? 's' : ''}";
      } else {
        duration = "";
      }
    });
  }

  Future<void> updateCoordinates() async {
    Map<String, double>? location = await GoogleMapHelper.updateAddressForApi();
    if (location != null) {
      addLatitude = location['latitude']?.toString();
      addLongitude = location['longitude']?.toString();
    } else {
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

  Future<List<String>> uploadImagesToFirebase(List<XFile?> images) async {
    List<String> imageUrls = [];

    for (var image in images) {
      if (image == null) continue;

      try {
        FirebaseStorage storage = FirebaseStorage.instance;
        String fileName = DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';
        Reference ref = storage.ref().child('ads_images/$fileName');
        UploadTask uploadTask = ref.putFile(File(image.path));
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();
        imageUrls.add(downloadUrl);
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
    return imageUrls;
  }

  Future<void> _updateLocationFeild() async {
    String location = await GoogleMapHelper.getCurrentLocation();
    await updateCoordinates();
    setState(() {
      locationController.text = location;
    });
  }

  Future<void> postProduct() async {
    if (addLatitude == null || addLongitude == null) {
      await updateCoordinates();
    }

    if (_images.isEmpty ||
        productNameController.text.isEmpty ||
        selectedCategory == null ||
        selectedSubCategory == null ||
        locationController.text.isEmpty ||
        monthlyRentalController.text.isEmpty ||
        depositController.text.isEmpty ||
        durationValueController.text.isEmpty ||
        selectedDurationType == null ||
        packageOption == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    List<String> imageUrls = await uploadImagesToFirebase(_images);
    if (imageUrls.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to upload any images')),
      );
      return;
    }

    int? monthlyRental = int.tryParse(monthlyRentalController.text);
    int? deposit = int.tryParse(depositController.text);

    if (monthlyRental == null || deposit == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid numbers')),
      );
      return;
    }

    Map<String, dynamic> data = {
      "seller_id": userId,
      "category_id": int.parse(selectedCategory!),
      "subcategory": int.parse(selectedSubCategory!),
      "product_name": productNameController.text,
      "monthly_rental": monthlyRental,
      "deposit": deposit,
      "description": descriptionController.text,
      "tags":  "tag",
      "packages": packageOption == true ? "Yes" : "No",
      "short_description": shortDescriptionController.text,
      "location": locationController.text,
      "status": 1,
      "stock": 1,
      "images": imageUrls,
      "addLongitude": addLongitude,
      "addLatitude": addLatitude,
      "duration": duration,
    };

    final apiUrl = '${AppConstant.API_URL}api/v1/product/create-product';
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        if (responseData['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product posted successfully')),
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyAdsPage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${responseData['message']}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to post product: ${response.statusCode}')),
        );
      }
    } catch (e) {
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
              value: selectedCategory,
              items: categories.isEmpty
                  ? [const DropdownMenuItem(value: null, child: Text('No categories available'))]
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
                  selectedSubCategory = null;
                  fetchSubCategories(value!);
                });
              },
              decoration: _inputDecoration(hintText: 'Select Category'),
            ),
            const SizedBox(height: 20),
            const _Label(text: 'Subcategory*'),
            DropdownButtonFormField<String>(
              value: selectedSubCategory,
              items: subcategories.isEmpty
                  ? [const DropdownMenuItem(value: null, child: Text('No subcategories available'))]
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
            ElevatedButton(
              onPressed: _updateLocationFeild,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_on),
                  SizedBox(width: 8),
                  Text("Get Location"),
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
            const _Label(text: 'Short Description'),
            _InputField(
              hintText: 'Enter short description',
              controller: shortDescriptionController,
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            const _Label(text: 'Posted By?*'),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text('Owner'),
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
                    title: const Text('Agent'),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _Label(text: 'Select Duration*'),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: durationValueController,
                        decoration: _inputDecoration(hintText: 'Enter Duration'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          updateDuration();
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: DropdownButtonFormField<String>(
                        value: selectedDurationType,
                        items: const [
                          DropdownMenuItem(value: 'days', child: Text('Days')),
                          DropdownMenuItem(value: 'months', child: Text('Months')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedDurationType = value;
                            updateDuration();
                          });
                        },
                        decoration: _inputDecoration(hintText: 'Type'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (duration.isNotEmpty)
                  Text(
                    'Duration: $duration',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
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
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _pickImages,
                    child: Container(
                      width: double.infinity,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.grey[400]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate,
                            size: 40,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Add Images',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (_images.isNotEmpty) ...[
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: _addMoreImages,
                    icon: const Icon(Icons.add),
                    label: const Text('More'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 10),
            if (_images.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  '${_images.length} image${_images.length > 1 ? 's' : ''} selected',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            const SizedBox(height: 10),
            _buildImageDisplay(),
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text(
                  'Post',
                  style: TextStyle(color: Colors.white, fontSize: 18),
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
      keyboardType: prefixText != null ? TextInputType.number : TextInputType.text,
    );
  }
}

InputDecoration _inputDecoration({required String hintText}) {
  return InputDecoration(
    border: const OutlineInputBorder(),
    hintText: hintText,
  );
}