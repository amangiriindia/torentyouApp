import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../components/ProductCard.dart';
import '../consts.dart';
import '../pages/ProductDetailsPage.dart';
import 'categoryWise.dart';

class ProductByCategory extends StatefulWidget {
  final String categoryName;
  final int categoryId;

  const ProductByCategory({
    Key? key,
    required this.categoryName,
    required this.categoryId,
  }) : super(key: key);

  @override
  _ProductByCategoryState createState() => _ProductByCategoryState();
}

class _ProductByCategoryState extends State<ProductByCategory> {
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15),
            child: SizedBox(
              height: 1,
              child: Container(
                color: Colors.grey,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.categoryName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryTextColor,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryWise(
                        categoryName: widget.categoryName, categoryId: widget.categoryId.toInt(),
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryTextColor,
                        AppColors.primaryColor,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 24,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.6,
              mainAxisSpacing: 15.0, // Space between rows
            ),
            itemCount: products.length > 4 ? 4 : products.length,
            itemBuilder: (BuildContext context, int index) {
              final product = products[index];

              final String title = product['product_name'] ?? 'Unknown';
              final String imageUrl = product['image'] ?? '';
              final String price =
                  "${product['monthly_rental']}/Month";
              final String category = widget.categoryName;
              final int productId = product['id']; // Get product ID
              final String image_url =product['image'] ?? '';

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
                        image: image_url,
                        categoryId: product['category_id'],
                        subcategoryId: product['subcategory'],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
