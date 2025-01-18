// ProductDetailsPage.dart

import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:try_test/constant/user_constant.dart';
import '../chat/chat_screen.dart';
import '../components/Button.dart';
import '../components/grdient_button.dart';
import '../components/product_details_full_screen.dart';
import '../consts.dart';
import '../service/api_service.dart';

class ProductDetailsPage extends StatefulWidget {
  final int productId;
  final int categoryId;
  final int subcategoryId;
  final String image;

  const ProductDetailsPage({
    Key? key,
    required this.productId,
    required this.categoryId,
    required this.subcategoryId,
    required this.image,
  }) : super(key: key);

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  Map<String, dynamic>? product;
  bool isLoading = true;
  int? senderUserId;
  String? senderEmail;
  int? reciverUserId;
  String? reciverEmail;
  String? productName;
  late final String? imageurl;
  final ApiService _apiService = ApiService(); // Instance of ApiService

  @override
  void initState() {
    super.initState();
    fetchProductDetails();
    _getUserData();
    imageurl = widget.image;
  }

  Future<void> fetchProductDetails() async {
    final productData = await _apiService.fetchProductDetails(widget.productId);
    if (productData != null) {
      setState(() {
        product = productData;
        isLoading = false;
        reciverUserId = product?['seller_id'];
        productName = product?['product_name'];
      });

      if (reciverUserId != null) {
        final email = await _apiService.getReceiverEmail(reciverUserId!);
        setState(() {
          reciverEmail = email;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> createChatRoom() async {
    // Prepare the request data
    final requestData = {
      'chat_room_id': '${senderUserId}_${reciverUserId}',
      'sender_id': senderUserId,
      'sender_email': senderEmail,
      'receiver_id': reciverUserId,
      'receiver_email': reciverEmail,
      'product_id': widget.productId,
      'product_name': productName,
    };
    final success = await _apiService.createChatRoom(requestData);
    if (success) {
      print('Chat room created successfully.');
    } else {
      print('Failed to create chat room.');
    }
  }

  Future<void> _getUserData() async {
   
    senderUserId = UserConstant.USER_ID?? 0;
    senderEmail = UserConstant.EMAIL ?? '';
    setState(() {});
  }

  void _shareProduct() async {
    final subject = 'Check out this ${product?['product_name']} on TorentYou!';
    final text =
        '${product?['short_description']} - ${product?['description']}';
    final imageUrl = widget.image;

    try {
      await Share.share(
        '$subject\n\n$text\n\n$imageUrl',
        subject: subject,
        sharePositionOrigin: const Rect.fromLTWH(0, 0, 0, 0),
      );
    } catch (error) {
      print('Error sharing product: $error');
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
              image: AssetImage('assets/logo.png'),
              width: 110,
              height: 110,
            ),
          ),
          bottom: PreferredSize(
          //  preferredSize: fromHeight(5.0),
          preferredSize: Magnifier.kDefaultMagnifierSize,
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
            image: AssetImage('assets/logo.png'),
            width: 110,
            height: 110,
          ),
        ),
        bottom: PreferredSize(
        //  preferredSize: const Size.fromHeight(5.0),
        preferredSize: Magnifier.kDefaultMagnifierSize,
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
            GestureDetector(
              onTap: () {
                // Navigate to the full-screen image view
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        FullScreenImageView(imageUrl: imageurl),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageurl ?? '',
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 250,
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.broken_image,
                        size: 50,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
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
                // Show alert dialog before navigating
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(  title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Icon(Icons.warning, color: Colors.red), // Icon for the heading
                        SizedBox(width: 10), // Add space between the icon and the text
                        
                        Text(
                            "Warning: Can be Rental\n Scams Ahead!",
                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
                          ),
                      ],
                    ),
                  
                      content: const  Text(
              "- Transfer money without meeting in person\n"
              "- Go to unknown places alone\n"
              "- Share OTP or PIN\n"
              "- Agree to rent without a written lease\n"
              "- Ignore red flags\n"
              "- Forget to discuss terms and conditions in detail\n"
              "- Rush into decisions\n"
              "- Hesitate to report suspicious activity",
              style: TextStyle(fontSize: 16),
            ),
                      actions: [
                        // Cancel Button with Gradient
                        GradientButton(
                          onPressed: () {
                            Navigator.pop(context); // Close the dialog
                          },
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.cancel, color: Colors.white),
                              SizedBox(width: 5),
                              Text(
                                "Cancel",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        // Proceed Button with Gradient
                        GradientButton(
                          onPressed: () {
                            Navigator.pop(context); // Close the dialog
                            // Navigate to the ChatPage after user agrees
                            createChatRoom();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatPage(
                                  senderId: senderUserId!,
                                  senderEmail: senderEmail!,
                                  receiverUserID: reciverUserId!,
                                  receiverUserEmail: reciverEmail!,
                              productName: productName!, productImage: widget.image,
                                ),
                              ),
                            );
                          },
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.chat_bubble_outline, color: Colors.white),
                              SizedBox(width: 5),
                              Text(
                                "Proceed",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );

              },
              title: "Chat now",
              gradient: const LinearGradient(
                colors: [
                  AppColors.primaryColor,
                  AppColors.primaryTextColor,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),

          ],
        ),
      ),
    );
  }
}
