import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../consts.dart';
import '../pageutills/myAdspage.dart';


class PostAdsPage extends StatelessWidget {
  const PostAdsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const PostAdsContent(), // Use the extracted content widget
    );
  }
}


class PostAdsContent extends StatefulWidget {
  const PostAdsContent({Key? key}) : super(key: key);

  @override
  _PostAdsContentState createState() => _PostAdsContentState();
}

class _PostAdsContentState extends State<PostAdsContent> {
  XFile? _image; // To store the selected image
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? selectedImage =
    await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = selectedImage;
    });
  }

  String? selectedCategory;
  String? selectedSubCategory;
  bool? packageOption;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Product Name*',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter product name',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Category*',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              items: const [
                DropdownMenuItem(child: Text('Select Category'), value: ''),
                DropdownMenuItem(
                    child: Text('Appliances'), value: 'Appliances'),
                DropdownMenuItem(child: Text('Clothes'), value: 'Clothes'),
                DropdownMenuItem(child: Text('Furniture'), value: 'Furniture'),
                DropdownMenuItem(child: Text('Home Stay'), value: 'Home Stay'),
                DropdownMenuItem(child: Text('Hotels'), value: 'Hotels'),
                DropdownMenuItem(child: Text('Property'), value: 'Property'),
                DropdownMenuItem(child: Text('Tools'), value: 'Tools'),
                DropdownMenuItem(child: Text('Vehicle'), value: 'Vehicle'),
                DropdownMenuItem(
                    child: Text('Yacht and Helicopters'),
                    value: 'Yacht and Helicopters'),
              ],
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Select Category',
              ),
              dropdownColor: Colors.white,
              iconEnabledColor: Colors.black,
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 20),
            const Text(
              'Subcategory*',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedSubCategory,
              items: const [
                DropdownMenuItem(child: Text('--SELECT--'), value: ''),
                DropdownMenuItem(
                    child: Text('Subcategory 1'), value: 'Sub1'),
                DropdownMenuItem(
                    child: Text('Subcategory 2'), value: 'Sub2'),
                DropdownMenuItem(
                    child: Text('Subcategory 3'), value: 'Sub3'),
              ],
              onChanged: (value) {
                setState(() {
                  selectedSubCategory = value;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Select Subcategory',
              ),
              dropdownColor: Colors.white,
              iconEnabledColor: Colors.black,
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 20),
            const Text(
              'Location*',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter location',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Product Image*',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _pickImage, // Image picker function
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
            const Text(
              'Monthly Rental*',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter monthly rental',
                prefixText: '₹ ',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            const Text(
              'Deposit*',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter deposit',
                prefixText: '₹ ',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            const Text(
              'Tags',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter tags, separated by commas',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Short Description',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter short description',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Package*',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
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
                    activeColor: Colors.black, // Change active color to black
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
                    activeColor: Colors.black, // Change active color to black
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Description',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter detailed description',
              ),
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyAdsPage(),
                    ),
                  );
                },
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
