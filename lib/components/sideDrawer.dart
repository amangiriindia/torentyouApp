
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shimmer/shimmer.dart';
import 'package:try_app/constant/user_constant.dart';
import '../consts.dart';
import '../pageutills/categoryWise.dart';

class SideDrawer extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const SideDrawer({Key? key, required this.scaffoldKey}) : super(key: key);

  @override
  _SideDrawerState createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  List<Map<String, dynamic>> categories = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  /// Fetch categories from the API and map to a simplified structure
  Future<void> _fetchCategories() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstant.API_URL}api/v1/category/all-category'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          categories = List<Map<String, dynamic>>.from(data['results'].map((category) {
            return {
              'id': category['id'],
              'name': category['c_name'],
            };
          }));
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  /// Handle tapping a category item
  void _onDrawerItemTap(int index) {
    final selectedCategory = categories[index];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryWise(
          categoryName: selectedCategory['name'],
          categoryId: selectedCategory['id'],
        ),
      ),
    );
    widget.scaffoldKey.currentState?.closeDrawer();
  }

  /// Generate asset path based on category name
  String _getAssetPath(String categoryName) {
    final key = categoryName.toLowerCase().replaceAll(" ", "_");
    return 'assets/icon/$key.png';
  }

  /// Build shimmer loading effect with circular placeholders
  Widget _buildShimmerLoader() {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: 6,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 16),
              Container(
                width: 120,
                height: 20,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userName = "${UserConstant.NAME}"; // Replace with dynamic name logic
    final userInitials = userName
        .split(' ')
        .map((e) => e[0])
        .take(2)
        .join()
        .toUpperCase();

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section
            Container(
              width: double.infinity,
              height: 200,
              padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryColor,
                    AppColors.primaryTextColor,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    child: Text(
                      userInitials,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                     'Hello $userName',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFFF3A683), Color(0xFFF7DC6F)],
                    ).createShader(bounds),
                    child: Text(
                      "Explore Categories",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Main Content
            Expanded(
              child: isLoading
                  ? _buildShimmerLoader()
                  : hasError
                  ? Center(
                child: Text(
                  "Failed to load categories. Try again later.",
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return GestureDetector(
                    onTap: () => _onDrawerItemTap(index),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage(_getAssetPath(category['name'])),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            category['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


