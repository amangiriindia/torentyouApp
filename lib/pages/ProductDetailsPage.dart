//
//
// import 'dart:ffi';
// import 'package:flutter/material.dart';
// import 'package:share_plus/share_plus.dart';
// import '../chat/chat_screen.dart';
// import '../components/Button.dart';
// import '../components/grdient_button.dart';
// import '../components/product_details_full_screen.dart';
// import '../constant/user_constant.dart';
// import '../consts.dart';
// import '../service/api_service.dart';
//
// class ProductDetailsPage extends StatefulWidget {
//   final int productId;
//   final int categoryId;
//   final int subcategoryId;
//   final String image;
//
//   const ProductDetailsPage({
//     Key? key,
//     required this.productId,
//     required this.categoryId,
//     required this.subcategoryId,
//     required this.image,
//   }) : super(key: key);
//
//   @override
//   _ProductDetailsPageState createState() => _ProductDetailsPageState();
// }
//
// class _ProductDetailsPageState extends State<ProductDetailsPage> {
//   Map<String, dynamic>? product;
//   bool isLoading = true;
//   int? senderUserId;
//   String? senderEmail;
//   int? reciverUserId;
//   String? reciverEmail;
//   String? productName;
//   late final String? imageurl;
//   final ApiService _apiService = ApiService(); // Instance of ApiService
//
//   @override
//   void initState() {
//     super.initState();
//     fetchProductDetails();
//     _getUserData();
//     imageurl = widget.image;
//   }
//
//   Future<void> fetchProductDetails() async {
//     final productData = await _apiService.fetchProductDetails(widget.productId);
//     if (productData != null) {
//       setState(() {
//         product = productData;
//         isLoading = false;
//         reciverUserId = product?['seller_id'];
//         productName = product?['product_name'];
//       });
//
//       if (reciverUserId != null) {
//         final email = await _apiService.getReceiverEmail(reciverUserId!);
//         setState(() {
//           reciverEmail = email;
//         });
//       }
//     } else {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   Future<void> createChatRoom() async {
//     // Prepare the request data
//     final requestData = {
//       'chat_room_id': '${senderUserId}_${reciverUserId}',
//       'sender_id': senderUserId,
//       'sender_email': senderEmail,
//       'receiver_id': reciverUserId,
//       'receiver_email': reciverEmail,
//       'product_id': widget.productId,
//       'product_name': productName,
//     };
//     final success = await _apiService.createChatRoom(requestData);
//     if (success) {
//       print('Chat room created successfully.');
//     } else {
//       print('Failed to create chat room.');
//     }
//   }
//
//   Future<void> _getUserData() async {
//
//     senderUserId = UserConstant.USER_ID?? 0;
//     senderEmail = UserConstant.EMAIL ?? '';
//     setState(() {});
//   }
//
//   void _shareProduct() async {
//     final subject = 'Check out this ${product?['product_name']} on TorentYou!';
//     final text =
//         '${product?['short_description']} - ${product?['description']}';
//     final imageUrl = widget.image;
//
//     try {
//       await Share.share(
//         '$subject\n\n$text\n\n$imageUrl',
//         subject: subject,
//         sharePositionOrigin: const Rect.fromLTWH(0, 0, 0, 0),
//       );
//     } catch (error) {
//       print('Error sharing product: $error');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return Scaffold(
//         appBar: AppBar(
//           centerTitle: true,
//           title: const Padding(
//             padding: EdgeInsets.all(20.0),
//             child: Image(
//               image: AssetImage('assets/logo.png'),
//               width: 110,
//               height: 110,
//             ),
//           ),
//           bottom: PreferredSize(
//           //  preferredSize: fromHeight(5.0),
//           preferredSize: Magnifier.kDefaultMagnifierSize,
//             child: Container(
//               height: 1.0,
//               color: AppColors.dividerColor.withOpacity(0.5),
//             ),
//           ),
//         ),
//         body: const Center(child: CircularProgressIndicator()),
//       );
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Padding(
//           padding: EdgeInsets.all(20.0),
//           child: Image(
//             image: AssetImage('assets/logo.png'),
//             width: 110,
//             height: 110,
//           ),
//         ),
//         bottom: PreferredSize(
//         //  preferredSize: const Size.fromHeight(5.0),
//         preferredSize: Magnifier.kDefaultMagnifierSize,
//           child: Container(
//             height: 1.0,
//             color: AppColors.dividerColor.withOpacity(0.5),
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             GestureDetector(
//               onTap: () {
//                 // Navigate to the full-screen image view
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) =>
//                         FullScreenImageView(imageUrl: imageurl),
//                   ),
//                 );
//               },
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: Image.network(
//                   imageurl ?? '',
//                   height: 250,
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) {
//                     return Container(
//                       height: 250,
//                       width: double.infinity,
//                       color: Colors.grey[200],
//                       child: const Icon(
//                         Icons.broken_image,
//                         size: 50,
//                         color: Colors.grey,
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             const SizedBox(height: 16),
//             Text(
//               product?['product_name'] ?? 'No Title',
//               style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600, letterSpacing: 1),
//             ),
//             const SizedBox(height: 30),
//             Row(
//               children: [
//
//                 Text(
//                   '₹${product?['monthly_rental'] ?? 'N/A'}/Month',
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.grey.shade700),
//                 ),
//
//                 const SizedBox(width: 18), // Space between icon and text
//                 Text(
//                   'Deposit: ₹${product?['deposit'] ?? 'N/A'}',
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.grey.shade700),
//                 ),
//               ],
//             ),
//
//             const SizedBox(height: 16), // Space between rows
//             Row(
//               children: [
//                 const Icon(Icons.location_on, color: Colors.grey), // Location icon
//                 const SizedBox(width: 8), // Space between icon and text
//                 Expanded(
//                   child: Text(
//                     product?['location'] ?? 'No Location Available',
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                 ),
//               ],
//             ),
//
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 20.0),
//               child: SizedBox(
//                 child: Container(
//                   height: 0.7,
//                   color: Colors.grey.shade400,
//                 ),
//               ),
//             ),
//             Text(
//               product?['short_description'] ?? 'No Description Available',
//               style: const TextStyle(fontSize: 16),
//             ),
//
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 20.0),
//               child: SizedBox(
//                 child: Container(
//                   height: 0.7,
//                   color: Colors.grey.shade400,
//                 ),
//               ),
//             ),
//             Text(
//               product?['description'] ?? 'No Description Available',
//               style: const TextStyle(fontSize: 16),
//             ),
//
//             Padding(
//               padding: const EdgeInsets.only(top: 20.0),
//               child: SizedBox(
//                 child: Container(
//                   height: 0.7,
//                   color: Colors.grey.shade400,
//                 ),
//               ),
//             ),
//             InkWell(
//               onTap: _shareProduct,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     "Share",
//                     style: TextStyle(fontSize: 19),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.share),
//                     onPressed: _shareProduct,
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 2, bottom: 20.0),
//               child: SizedBox(
//                 child: Container(
//                   height: 0.7,
//                   color: Colors.grey.shade400,
//                 ),
//               ),
//             ),
//
//              ButtonCustom(
//               callback: () {
//                 // Show alert dialog before navigating
//                 showDialog(
//                   context: context,
//                   builder: (context) {
//                     return AlertDialog(  title: Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: const [
//                         Icon(Icons.warning, color: Colors.red), // Icon for the heading
//                         SizedBox(width: 10), // Add space between the icon and the text
//
//                         Text(
//                             "Warning: Can be Rental\n Scams Ahead!",
//                             style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
//                           ),
//                       ],
//                     ),
//
//                       content: const  Text(
//               "- Transfer money without meeting in person\n"
//               "- Go to unknown places alone\n"
//               "- Share OTP or PIN\n"
//               "- Agree to rent without a written lease\n"
//               "- Ignore red flags\n"
//               "- Forget to discuss terms and conditions in detail\n"
//               "- Rush into decisions\n"
//               "- Hesitate to report suspicious activity",
//               style: TextStyle(fontSize: 16),
//             ),
//                       actions: [
//                         // Cancel Button with Gradient
//                         GradientButton(
//                           onPressed: () {
//                             Navigator.pop(context); // Close the dialog
//                           },
//                           child: const Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Icon(Icons.cancel, color: Colors.white),
//                               SizedBox(width: 5),
//                               Text(
//                                 "Cancel",
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ],
//                           ),
//                         ),
//                         // Proceed Button with Gradient
//                         GradientButton(
//                           onPressed: () {
//                             Navigator.pop(context); // Close the dialog
//                             // Navigate to the ChatPage after user agrees
//                             createChatRoom();
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => ChatPage(
//                                   senderId: senderUserId!,
//                                   senderEmail: senderEmail!,
//                                   receiverUserID: reciverUserId!,
//                                   receiverUserEmail: reciverEmail!,
//                               productName: productName!, productImage: widget.image,
//                                 ),
//                               ),
//                             );
//                           },
//                           child: const Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Icon(Icons.chat_bubble_outline, color: Colors.white),
//                               SizedBox(width: 5),
//                               Text(
//                                 "Proceed",
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                 );
//
//               },
//               title: "Chat now",
//               gradient: const LinearGradient(
//                 colors: [
//                   AppColors.primaryColor,
//                   AppColors.primaryTextColor,
//                 ],
//                 begin: Alignment.centerLeft,
//                 end: Alignment.centerRight,
//               ),
//             ),
//
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../chat/chat_screen.dart';
import '../components/Button.dart';
import '../components/grdient_button.dart';
import '../components/product_details_full_screen.dart';
import '../constant/user_constant.dart';
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

  // Review related variables
  final TextEditingController _reviewController = TextEditingController();
  int _selectedRating = 5;
  List<Map<String, dynamic>> _reviews = [];
  double _averageRating = 0.0;

  @override
  void initState() {
    super.initState();
    fetchProductDetails();
    _getUserData();
    imageurl = widget.image;
    _loadDummyReviews(); // Load dummy reviews
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  // Load dummy reviews - replace with API call in future
  void _loadDummyReviews() {
    _reviews = [
      {
        'user_name': 'John Doe',
        'rating': 5,
        'comment': 'Excellent product! Great condition and fast delivery. Highly recommend!',
        'date': '2025-01-15',
        'user_avatar': 'assets/default_avatar.png'
      },
      {
        'user_name': 'Sarah Wilson',
        'rating': 4,
        'comment': 'Good quality item, exactly as described. Owner was very responsive.',
        'date': '2025-01-10',
        'user_avatar': 'assets/default_avatar.png'
      },
      {
        'user_name': 'Mike Johnson',
        'rating': 5,
        'comment': 'Amazing experience! The product was in perfect condition.',
        'date': '2025-01-05',
        'user_avatar': 'assets/default_avatar.png'
      },
      {
        'user_name': 'Emma Brown',
        'rating': 4,
        'comment': 'Very satisfied with the rental. Clean and well-maintained.',
        'date': '2024-12-28',
        'user_avatar': 'assets/default_avatar.png'
      },
    ];

    // Calculate average rating
    if (_reviews.isNotEmpty) {
      double total = _reviews.fold(0.0, (sum, review) => sum + review['rating']);
      _averageRating = total / _reviews.length;
    }
    setState(() {});
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
    senderUserId = UserConstant.USER_ID ?? 0;
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

  void _submitReview() {
    if (_reviewController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a review comment')),
      );
      return;
    }

    // Add new review to the list (dummy implementation)
    final newReview = {
      'user_name': UserConstant.EMAIL?.split('@')[0] ?? 'Anonymous',
      'rating': _selectedRating,
      'comment': _reviewController.text.trim(),
      'date': DateTime.now().toString().substring(0, 10),
      'user_avatar': 'assets/default_avatar.png'
    };

    setState(() {
      _reviews.insert(0, newReview); // Add to beginning of list

      // Recalculate average rating
      double total = _reviews.fold(0.0, (sum, review) => sum + review['rating']);
      _averageRating = total / _reviews.length;

      // Clear form
      _reviewController.clear();
      _selectedRating = 5;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Review submitted successfully!')),
    );

    // TODO: Replace with actual API call
    // await _apiService.submitReview(widget.productId, newReview);
  }

  Widget _buildRatingStars(double rating, {double size = 20}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating.floor()
              ? Icons.star
              : index < rating
              ? Icons.star_half
              : Icons.star_border,
          color: Colors.orange,
          size: size,
        );
      }),
    );
  }

  Widget _buildReviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Reviews Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Reviews (${_reviews.length})',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (_reviews.isNotEmpty)
              Row(
                children: [
                  _buildRatingStars(_averageRating),
                  const SizedBox(width: 8),
                  Text(
                    '${_averageRating.toStringAsFixed(1)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
          ],
        ),

        const SizedBox(height: 20),

        // Write Review Section
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Write a Review',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),

              // Rating Selection
              const Text(
                'Your Rating:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Row(
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedRating = index + 1;
                      });
                    },
                    child: Icon(
                      index < _selectedRating ? Icons.star : Icons.star_border,
                      color: Colors.orange,
                      size: 30,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),

              // Review Text Field
              TextField(
                controller: _reviewController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Share your experience with this product...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.primaryColor),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitReview,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Submit Review',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Reviews List
        if (_reviews.isNotEmpty)
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _reviews.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final review = _reviews[index];
              return Container(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                          child: Text(
                            review['user_name'][0].toString().toUpperCase(),
                            style: const TextStyle(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                review['user_name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              Row(
                                children: [
                                  _buildRatingStars(review['rating'].toDouble()),
                                  const SizedBox(width: 8),
                                  Text(
                                    review['date'],
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      review['comment'],
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              );
            },
          )
        else
          Container(
            padding: const EdgeInsets.all(20),
            child: const Text(
              'No reviews yet. Be the first to review this product!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
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
                const SizedBox(width: 18),
                Text(
                  'Deposit: ₹${product?['deposit'] ?? 'N/A'}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.grey.shade700),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.grey),
                const SizedBox(width: 8),
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
              child: Container(
                height: 0.7,
                color: Colors.grey.shade400,
              ),
            ),
            Text(
              product?['short_description'] ?? 'No Description Available',
              style: const TextStyle(fontSize: 16),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Container(
                height: 0.7,
                color: Colors.grey.shade400,
              ),
            ),
            Text(
              product?['description'] ?? 'No Description Available',
              style: const TextStyle(fontSize: 16),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Container(
                height: 0.7,
                color: Colors.grey.shade400,
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
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Container(
                height: 0.7,
                color: Colors.grey.shade400,
              ),
            ),

            // Reviews Section
            _buildReviewSection(),

            const SizedBox(height: 30),

            ButtonCustom(
              callback: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Icon(Icons.warning, color: Colors.red),
                          SizedBox(width: 10),
                          Text(
                            "Warning: Can be Rental\n Scams Ahead!",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                      content: const Text(
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
                        GradientButton(
                          onPressed: () {
                            Navigator.pop(context);
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
                        GradientButton(
                          onPressed: () {
                            Navigator.pop(context);
                            createChatRoom();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatPage(
                                  senderId: senderUserId!,
                                  senderEmail: senderEmail!,
                                  receiverUserID: reciverUserId!,
                                  receiverUserEmail: reciverEmail!,
                                  productName: productName!,
                                  productImage: widget.image,
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