import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../chat/chat_screen.dart';
import '../components/Button.dart';
import '../consts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'ChatScreen.dart';

class ProductDetailsPage extends StatefulWidget {
  final int productId;
  final int categoryId;
  final int subcategoryId;

  const ProductDetailsPage({
    Key? key,
    required this.productId,
    required this.categoryId,
    required this.subcategoryId,
  }) : super(key: key);

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  Map<String, dynamic>? product;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProductDetails();
  }

  Future<void> fetchProductDetails() async {
    final url = '${AppConstant.API_URL}api/v1/product/single-product/${widget.productId}';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          product = data;
          isLoading = false;
        });
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

  void _shareProduct() async {
    final subject = 'Check out this ${product?['product_name']} on TorentYou!';
    final text = '${product?['short_description']} - ${product?['description']}';
    final imageUrl = product?['image']; // Get the image URL

    try {
      await Share.share(
        '$subject\n\n$text\n\n$imageUrl',
        subject: subject,
        sharePositionOrigin: const Rect.fromLTWH(0, 0, 0, 0),
      );
    } catch (error) {
      print('Error sharing product: $error');
      // Optionally show an error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Padding(
            padding: EdgeInsets.all(20.0),
            child: Image(
              image: AssetImage('assets/logo.png'),  // Replace with your logo file path
              width: 110,  // Adjust size as needed
              height: 110,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(5.0),
            child: Container(
              height: 1.0,
              color: AppColors.dividerColor.withOpacity(0.5),
            ),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Padding(
          padding: EdgeInsets.all(20.0),
          child: Image(
            image: AssetImage('assets/logo.png'),  // Replace with your logo file path
            width: 110,  // Adjust size as needed
            height: 110,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(5.0),
          child: Container(
            height: 1.0,
            color: AppColors.dividerColor.withOpacity(0.5),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                product?['image'] ?? '', // Default empty image URL
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Add error handling
                  return const Icon(Icons.error); // Show error icon
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(
              product?['product_name'] ?? 'No Title',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600, letterSpacing: 1),
            ),
            const SizedBox(height: 30),
            Row(
              children: [

                Text(
                  '₹${product?['monthly_rental'] ?? 'N/A'}/Month',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.grey.shade700),
                ),

                const SizedBox(width: 18), // Space between icon and text
                Text(
                  'Deposit: ₹${product?['deposit'] ?? 'N/A'}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.grey.shade700),
                ),
              ],
            ),

            const SizedBox(height: 16), // Space between rows
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.grey), // Location icon
                const SizedBox(width: 8), // Space between icon and text
                Expanded(
                  child: Text(
                    product?['location'] ?? 'No Location Available',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: SizedBox(
                child: Container(
                  height: 0.7,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
            Text(
              product?['short_description'] ?? 'No Description Available',
              style: const TextStyle(fontSize: 16),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: SizedBox(
                child: Container(
                  height: 0.7,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
            Text(
              product?['description'] ?? 'No Description Available',
              style: const TextStyle(fontSize: 16),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: SizedBox(
                child: Container(
                  height: 0.7,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
            InkWell(
              onTap: _shareProduct,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Share",
                    style: TextStyle(fontSize: 19),
                  ),
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: _shareProduct,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2, bottom: 20.0),
              child: SizedBox(
                child: Container(
                  height: 0.7,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
            ButtonCustom(
              callback: () {
                // Navigate to the ChatPage when the button is clicked
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(
                      senderId: "randomSenderId123",    // Replace with actual senderId
                      senderEmail: "sender@example.com", // Replace with actual senderEmail
                      receiverUserEmail: "receiver@example.com", // Replace with actual receiverUserEmail
                      receiverUserID: "randomReceiverId456",    // Replace with actual receiverUserID
                    ),
                  ),
                );
              },
              title: "Chat Now",
              gradient: const LinearGradient(colors: [
                AppColors.primaryColor,
                AppColors.primaryTextColor,
              ]),
            )

          ],
        ),
      ),
    );
  }
}
