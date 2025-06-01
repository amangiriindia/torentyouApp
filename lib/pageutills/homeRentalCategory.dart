import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../consts.dart';
import 'categoryWise.dart';

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
    _loadCachedCategories();  // Load cached data first
    fetchCategories();        // Then fetch from API
  }

  /// Load categories from SharedPreferences
  Future<void> _loadCachedCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString('rental_categories');
    if (cached != null) {
      final List<dynamic> decoded = jsonDecode(cached);
      setState(() {
        categories = List<Map<String, dynamic>>.from(decoded);
      });
    }
  }

  /// Fetch fresh data from API and update SharedPreferences
  Future<void> fetchCategories() async {
    const url = '${AppConstant.API_URL}api/v1/category/all-category';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          final List<Map<String, dynamic>> fetchedCategories =
          List<Map<String, dynamic>>.from(data['results'].map((category) {
            return {
              'id': category['id'] ?? 0,
              'name': category['c_name'],
            };
          }));

          if (mounted) {
            setState(() {
              categories = fetchedCategories;
            });
          }

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('rental_categories', jsonEncode(fetchedCategories));
        }
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  /// Map category name to asset image path
  String _getAssetPath(String categoryName) {
    final key = categoryName.toLowerCase().replaceAll(" ", "_");
    return 'assets/icon/$key.png';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.0, vertical: 15.0),
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
              final imagePath = _getAssetPath(category['name']);

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryWise(
                        categoryName: category['name'],
                        categoryId: category['id'],
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
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
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage(imagePath),
                              fit: BoxFit.contain,
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
              : const Center(child: CircularProgressIndicator()),
        ),
      ],
    );
  }
}
