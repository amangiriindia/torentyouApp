import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../components/ProductCard.dart';
import '../consts.dart';
import '../pages/ProductDetailsPage.dart';

class CategoryWise extends StatefulWidget {
  final String categoryName;
  final int categoryId;

  const CategoryWise({
    Key? key,
    required this.categoryName,
    required this.categoryId,
  }) : super(key: key);

  @override
  _CategoryWiseState createState() => _CategoryWiseState();
}

class _CategoryWiseState extends State<CategoryWise> {
  List<Map<String, dynamic>> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final url = '${AppConstant.API_URL}api/v1/product/all-product';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"category_id": widget.categoryId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          setState(() {
            products = List<Map<String, dynamic>>.from(data['results']);
            isLoading = false;
          });
        } else {
          // Handle the error
          setState(() {
            isLoading = false;
          });
        }
      } else {
        // Handle the error
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      // Handle the error
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.categoryName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryColor,
                AppColors.primaryTextColor,
              ],
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
          child: products.isNotEmpty
              ? GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.6,
              mainAxisSpacing: 15.0, // Space between rows
            ),
            itemCount: products.length,
            itemBuilder: (BuildContext context, int index) {
              final product = products[index];

              final String title = product['product_name'] ?? 'Unknown';
              final String imageUrl = product['image'] ?? '';
              final String price = "${product['monthly_rental']}/Month" ?? 'N/A';
              final String category = widget.categoryName;
              final int productId = product['id']; // Get product ID

              return ProductCard(
                title: title,
                imageUrl: imageUrl,
                price: price,
                category: category,
                onRentNow: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailsPage(
                        productId: productId,
                        categoryId: product['category_id'],
                        subcategoryId: product['subcategory'],
                      ),
                    ),
                  );
                },
              );
            },
          )
              : const Center(
            child: Text(
              'No products available in this category.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}