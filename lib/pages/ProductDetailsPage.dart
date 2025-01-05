import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../chat/chat_screen.dart';
import '../components/Button.dart';
import '../components/grdient_button.dart';
import '../consts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../pageutills/chat_alrert_box.dart';
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
  int? senderUserId;
  String? senderEmail;
  int? reciverUserId;
  String? reciverEmail;
  String? productName;

  @override
  void initState() {
    super.initState();
    fetchProductDetails();
    _getUserData();
  }



  Future<void> createChatRoom ()async {
    // Define the API URL (replace with your actual API endpoint)
    const String apiUrl = '${AppConstant.API_URL}api/v1/chat/create-chat-room';

    try {
      // Prepare the request payload
      final Map<String, dynamic> requestData = {
        'chat_room_id': '${senderUserId}_${reciverUserId}',
        'sender_id': senderUserId,
        'sender_email': senderEmail,
        'receiver_id': reciverUserId,
        'receiver_email': reciverEmail,
        'product_id': widget.productId,
        'product_name': productName,
      };

      // Send the POST request
      final  response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestData),
      );
      print(response.body);
      if (response.statusCode == 201) {
        // If the server returns a 201 CREATED response
        print('Chat room created successfully.');
      } else {
        // If the server returns an error response
        print('Failed to create chat room. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      // Handle any errors
      print('Error occurred: $e');
    }
  }


  Future<void> _getUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    senderUserId = pref.getInt('userId') ?? 0;
    senderEmail = pref.getString('email') ?? '';
    setState(() {}); // Call setState to update the UI if `id` is being used there
  }

  Future<void> getReciverEmail(int reciverId) async {
    final url = '${AppConstant.API_URL}api/v1/seller/single-seller/$reciverId';

    try {
      // Making GET request
      final response = await http.get(Uri.parse(url));

      // Print response body and status code for debugging
      print('Response Body: ${response.body}');
      print('Status Code: ${response.statusCode}');

      // Check if status code is 200 (success)
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Check if 'email' field exists in the response
        if (data != null && data['email'] != null) {
          reciverEmail = data['email']; // Set the email
          print('Reciver Email: $reciverEmail');
        } else {
          print("Email not found in response data");
        }
      } else {
        // Handle cases where the status code is not 200
        print("Failed to fetch data. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      // Print the error message for debugging
      print("Error occurred: $e");
    }
  }


  Future<void> fetchProductDetails() async {
    final url = '${AppConstant.API_URL}api/v1/product/single-product/${widget.productId}';
    try {
      final response = await http.get(Uri.parse(url));
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          product = data;
          isLoading = false;
          reciverUserId = product?['seller_id'];
          productName = product?['product_name'];

        });

        if(reciverUserId!=null){
          getReciverEmail(reciverUserId!);
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
                          "Important Notice",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                      content: const Text(
                        "For your safety:\n\n"
                            "Do not share personal information like OTP, passwords, or bank details.\n"
                            "Avoid transferring money without verifying the product and seller.\n"
                            "Communicate through the app for better security.\n\n"
                            "Proceed to chat if you agree to these terms.",
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
