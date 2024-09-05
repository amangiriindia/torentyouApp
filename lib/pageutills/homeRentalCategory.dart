import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For jsonDecode
import '../consts.dart';
import 'categoryWise.dart'; // Import CategoryWise page

class RentalCategory extends StatefulWidget {
  const RentalCategory({Key? key}) : super(key: key);

  @override
  _RentalCategoryState createState() => _RentalCategoryState();
}

class _RentalCategoryState extends State<RentalCategory> {
  List<Map<String, dynamic>> categories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    const url = 'http://192.168.1.39:8080/api/v1/category/all-category';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(response.statusCode);
        print(response.body);

        if (data['success']) {
          setState(() {
            categories = List<Map<String, dynamic>>.from(data['results'].map((category) {
              return {
                'id': category['id'] ?? 0, // Capture the category ID
                'name': category['c_name'],
                'image': category['image'],
              };
            }));
          });
        }
      } else {
        // Handle non-200 responses
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      // Handle error, e.g., by showing a message
      print('Error fetching categories: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 15.0),
          child: Text(
            'Rental Category',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryTextColor,
            ),
          ),
        ),
        SizedBox(
          height: 100,
          child: categories.isNotEmpty
              ? ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryWise(
                        categoryName: category['name'],
                        categoryId: category['id'] , // Pass the dynamic ID here
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5.0), // Adding padding for white background
                        decoration: BoxDecoration(
                          color: Colors.white, // White background
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Container(
                          height: 60, // Adjusted to fit inside the padding
                          width: 60,  // Adjusted to fit inside the padding
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(category['image']),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        category['name'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )
              : const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }
}
