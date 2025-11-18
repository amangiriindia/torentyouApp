
// import 'dart:ffi';
// import 'package:flutter/material.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:try_app/pages/auth/loginPage.dart';
// import 'chat/chat_screen.dart';
// import '../components/Button.dart';
// import '../components/grdient_button.dart';
// import '../components/product_details_full_screen.dart';
// import '../constant/user_constant.dart';
// import '../consts.dart';
// import '../service/api_service.dart';
// import '../service/review_service.dart'; // Add this import

// class ProductDetailsPage extends StatefulWidget {
//   final int productId;
//   final int categoryId;
//   final int subcategoryId;
//   final String image;

//   const ProductDetailsPage({
//     Key? key,
//     required this.productId,
//     required this.categoryId,
//     required this.subcategoryId,
//     required this.image,
//   }) : super(key: key);

//   @override
//   _ProductDetailsPageState createState() => _ProductDetailsPageState();
// }

// class _ProductDetailsPageState extends State<ProductDetailsPage> {
//   Map<String, dynamic>? product;
//   bool isLoading = true;
//   int? senderUserId;
//   String? senderEmail;
//   int? reciverUserId;
//   String? reciverEmail;
//   String? productName;
//   late final String? imageurl;
//   final ApiService _apiService = ApiService();
//   final ReviewService _reviewService = ReviewService(); // Add ReviewService instance

//   // Review related variables
//   final TextEditingController _reviewController = TextEditingController();
//   int _selectedRating = 5;
//   List<Map<String, dynamic>> _reviews = [];
//   double _averageRating = 0.0;
//   bool _isSubmittingReview = false; // Add loading state for review submission

//   @override
//   void initState() {
//     super.initState();
//     fetchProductDetails();
//     _getUserData();
//     imageurl = widget.image;
//     _loadDummyReviews(); // Load dummy reviews
//   }

//   @override
//   void dispose() {
//     _reviewController.dispose();
//     super.dispose();
//   }

//   // Load dummy reviews - replace with API call in future
//   void _loadDummyReviews() {
//      _reviews = [
//     {
//       'user_name': 'Amit Sharma',
//       'rating': 5,
//       'comment': 'Excellent product! Great condition and fast delivery. Highly recommend!',
//       'date': '2025-01-15',
//       'user_avatar': 'assets/default_avatar.png'
//     },
//     {
//       'user_name': 'Priya Singh',
//       'rating': 4,
//       'comment': 'Good quality item, exactly as described. Owner was very responsive.',
//       'date': '2025-01-10',
//       'user_avatar': 'assets/default_avatar.png'
//     },
//     {
//       'user_name': 'Rahul Verma',
//       'rating': 5,
//       'comment': 'Amazing experience! The product was in perfect condition.',
//       'date': '2025-01-05',
//       'user_avatar': 'assets/default_avatar.png'
//     },
//     {
//       'user_name': 'Sneha Patel',
//       'rating': 4,
//       'comment': 'Very satisfied with the rental. Clean and well-maintained.',
//       'date': '2024-12-28',
//       'user_avatar': 'assets/default_avatar.png'
//     },
//   ];

//     // Calculate average rating
//     if (_reviews.isNotEmpty) {
//       double total = _reviews.fold(0.0, (sum, review) => sum + review['rating']);
//       _averageRating = total / _reviews.length;
//     }
//     setState(() {});
//   }

//   Future<void> fetchProductDetails() async {
//     final productData = await _apiService.fetchProductDetails(widget.productId);
//     if (productData != null) {
//       setState(() {
//         product = productData;
//         isLoading = false;
//         reciverUserId = product?['seller_id'];
//         productName = product?['product_name'];
//       });

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

//   Future<void> _getUserData() async {
//     senderUserId = UserConstant.USER_ID ?? 0;
//     senderEmail = UserConstant.EMAIL ?? '';
//     setState(() {});
//   }

//   void _shareProduct() async {
//     final subject = 'Check out this ${product?['product_name']} on TorentYou!';
//     final text =
//         '${product?['short_description']} - ${product?['description']}';
//     final imageUrl = widget.image;

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

//   // Updated submit review method with API integration
//   Future<void> _submitReview() async {
//     if (_reviewController.text.trim().isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter a review comment')),
//       );
//       return;
//     }

//     if (senderEmail == null || senderEmail!.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('User email not found')),
//       );
//       return;
//     }

//     setState(() {
//       _isSubmittingReview = true;
//     });

//     try {
//       // Submit review to API
//       final response = await _reviewService.submitReview(
//         productId: widget.productId.toString(),
//         rating: _selectedRating.toString(),
//         name: senderEmail!.split('@')[0], // Use email username as name
//         email: senderEmail!,
//         comment: _reviewController.text.trim(),
//       );

//       if (response != null && response['success'] == true) {
//         // Add new review to the local list (for immediate UI update)
//         final newReview = {
//           'user_name': senderEmail!.split('@')[0],
//           'rating': _selectedRating,
//           'comment': _reviewController.text.trim(),
//           'date': DateTime.now().toString().substring(0, 10),
//           'user_avatar': 'assets/default_avatar.png'
//         };

//         setState(() {
//           _reviews.insert(0, newReview); // Add to beginning of list

//           // Recalculate average rating
//           double total = _reviews.fold(0.0, (sum, review) => sum + review['rating']);
//           _averageRating = total / _reviews.length;

//           // Clear form
//           _reviewController.clear();
//           _selectedRating = 5;
//         });

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(response['message'] ?? 'Review submitted successfully!'),
//             backgroundColor: Colors.green,
//           ),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Failed to submit review. Please try again.'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } catch (e) {
//       print('Error submitting review: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('An error occurred. Please try again.'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     } finally {
//       setState(() {
//         _isSubmittingReview = false;
//       });
//     }
//   }

//   // Show review submission dialog
//   void _showReviewDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: !_isSubmittingReview,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (context, setDialogState) {
//             return AlertDialog(
//               title: const Text(
//                 'Write a Review',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               content: SingleChildScrollView(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Product info
//                     Text(
//                       'Product: ${product?['product_name'] ?? 'Unknown'}',
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.grey[600],
//                       ),
//                     ),
//                     const SizedBox(height: 16),

//                     // Rating Selection
//                     const Text(
//                       'Your Rating:',
//                       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                     ),
//                     const SizedBox(height: 8),
//                     Row(
//                       children: List.generate(5, (index) {
//                         return GestureDetector(
//                           onTap: _isSubmittingReview ? null : () {
//                             setDialogState(() {
//                               _selectedRating = index + 1;
//                             });
//                           },
//                           child: Icon(
//                             index < _selectedRating ? Icons.star : Icons.star_border,
//                             color: Colors.orange,
//                             size: 30,
//                           ),
//                         );
//                       }),
//                     ),
//                     const SizedBox(height: 16),

//                     // Review Text Field
//                     TextField(
//                       controller: _reviewController,
//                       enabled: !_isSubmittingReview,
//                       maxLines: 4,
//                       maxLength: 500,
//                       decoration: InputDecoration(
//                         hintText: 'Share your experience with this product...',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                           borderSide: const BorderSide(color: AppColors.primaryColor),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: _isSubmittingReview ? null : () {
//                     Navigator.of(context).pop();
//                     _reviewController.clear();
//                     _selectedRating = 5;
//                   },
//                   child: const Text('Cancel'),
//                 ),
//                 ElevatedButton(
//                   onPressed: _isSubmittingReview ? null : () async {
//                     Navigator.of(context).pop(); // Close dialog first
//                     await _submitReview(); // Then submit review
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primaryColor,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: _isSubmittingReview 
//                     ? const SizedBox(
//                         width: 20,
//                         height: 20,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                           valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                         ),
//                       )
//                     : const Text(
//                         'Submit',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }

//   Widget _buildRatingStars(double rating, {double size = 20}) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: List.generate(5, (index) {
//         return Icon(
//           index < rating.floor()
//               ? Icons.star
//               : index < rating
//               ? Icons.star_half
//               : Icons.star_border,
//           color: Colors.orange,
//           size: size,
//         );
//       }),
//     );
//   }

//   Widget _buildReviewSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Reviews Header with Write Review Button
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Reviews (${_reviews.length})',
//                   style: const TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 if (_reviews.isNotEmpty)
//                   Row(
//                     children: [
//                       _buildRatingStars(_averageRating),
//                       const SizedBox(width: 8),
//                       Text(
//                         '${_averageRating.toStringAsFixed(1)}',
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//               ],
//             ),
//            // Show review button only if user is logged in
// if (UserConstant.USER_ID != null && UserConstant.USER_ID != 0)
//   ElevatedButton.icon(
//     onPressed: _isSubmittingReview ? null : _showReviewDialog,
//     icon: const Icon(Icons.edit, color: Colors.white, size: 16),
//     label: const Text(
//       'Write Review',
//       style: TextStyle(color: Colors.white),
//     ),
//     style: ElevatedButton.styleFrom(
//       backgroundColor: AppColors.primaryColor,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20),
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//     ),
//   ),
//           ],
//         ),

//         const SizedBox(height: 20),

//         // Reviews List
//         if (_reviews.isNotEmpty)
//           ListView.separated(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: _reviews.length,
//             separatorBuilder: (context, index) => const Divider(),
//             itemBuilder: (context, index) {
//               final review = _reviews[index];
//               return Container(
//                 padding: const EdgeInsets.all(12),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         CircleAvatar(
//                           radius: 20,
//                           backgroundColor: AppColors.primaryColor.withOpacity(0.1),
//                           child: Text(
//                             review['user_name'][0].toString().toUpperCase(),
//                             style: const TextStyle(
//                               color: AppColors.primaryColor,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 review['user_name'],
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                               Row(
//                                 children: [
//                                   _buildRatingStars(review['rating'].toDouble()),
//                                   const SizedBox(width: 8),
//                                   Text(
//                                     review['date'],
//                                     style: TextStyle(
//                                       color: Colors.grey[600],
//                                       fontSize: 12,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       review['comment'],
//                       style: const TextStyle(fontSize: 14),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           )
//         else
//           Container(
//             padding: const EdgeInsets.all(20),
//             child: const Text(
//               'No reviews yet. Be the first to review this product!',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),
//       ],
//     );
//   }

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
//             preferredSize: Magnifier.kDefaultMagnifierSize,
//             child: Container(
//               height: 1.0,
//               color: AppColors.dividerColor.withOpacity(0.5),
//             ),
//           ),
//         ),
//         body: const Center(child: CircularProgressIndicator()),
//       );
//     }

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
//           preferredSize: Magnifier.kDefaultMagnifierSize,
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
//             Text(
//               product?['product_name'] ?? 'No Title',
//               style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600, letterSpacing: 1),
//             ),
//             const SizedBox(height: 30),
//             Row(
//               children: [
//                 Text(
//                   '₹${product?['monthly_rental'] ?? 'N/A'}/Month',
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.grey.shade700),
//                 ),
//                 const SizedBox(width: 18),
//                 Text(
//                   'Deposit: ₹${product?['deposit'] ?? 'N/A'}',
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.grey.shade700),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Row(
//               children: [
//                 const Icon(Icons.location_on, color: Colors.grey),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     product?['location'] ?? 'No Location Available',
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                 ),
//               ],
//             ),

//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 20.0),
//               child: Container(
//                 height: 0.7,
//                 color: Colors.grey.shade400,
//               ),
//             ),
//             Text(
//               product?['short_description'] ?? 'No Description Available',
//               style: const TextStyle(fontSize: 16),
//             ),

//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 20.0),
//               child: Container(
//                 height: 0.7,
//                 color: Colors.grey.shade400,
//               ),
//             ),
//             Text(
//               product?['description'] ?? 'No Description Available',
//               style: const TextStyle(fontSize: 16),
//             ),

//             Padding(
//               padding: const EdgeInsets.only(top: 20.0),
//               child: Container(
//                 height: 0.7,
//                 color: Colors.grey.shade400,
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
//               padding: const EdgeInsets.symmetric(vertical: 20.0),
//               child: Container(
//                 height: 0.7,
//                 color: Colors.grey.shade400,
//               ),
//             ),

//             // Reviews Section
//             _buildReviewSection(),

//             const SizedBox(height: 30),

//         ButtonCustom(
//   callback: () {
//     // Check if user is logged in
//     if (UserConstant.USER_ID == null || UserConstant.USER_ID == 0) {
//       // User is not logged in - navigate to login page
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => const LoginPage(), // Replace with your actual login page
//         ),
//       );
//       return;
//     }

//     // User is logged in - show warning dialog and proceed with chat
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: const [
//               Icon(Icons.warning, color: Colors.red),
//               SizedBox(width: 10),
//               Text(
//                 "Warning: Can be Rental\n Scams Ahead!",
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//               ),
//             ],
//           ),
//           content: const Text(
//             "- Transfer money without meeting in person\n"
//                 "- Go to unknown places alone\n"
//                 "- Share OTP or PIN\n"
//                 "- Agree to rent without a written lease\n"
//                 "- Ignore red flags\n"
//                 "- Forget to discuss terms and conditions in detail\n"
//                 "- Rush into decisions\n"
//                 "- Hesitate to report suspicious activity",
//             style: TextStyle(fontSize: 16),
//           ),
//           actions: [
//             GradientButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(Icons.cancel, color: Colors.white),
//                   SizedBox(width: 5),
//                   Text(
//                     "Cancel",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ],
//               ),
//             ),
//             GradientButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 createChatRoom();
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ChatPage(
//                       senderId: senderUserId!,
//                       senderEmail: senderEmail!,
//                       receiverUserID: reciverUserId!,
//                       receiverUserEmail: reciverEmail!,
//                       productName: productName!,
//                       productImage: widget.image,
//                     ),
//                   ),
//                 );
//               },
//               child: const Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(Icons.chat_bubble_outline, color: Colors.white),
//                   SizedBox(width: 5),
//                   Text(
//                     "Proceed",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   },
//   title: UserConstant.USER_ID == null || UserConstant.USER_ID == 0 
//       ? "Login" 
//       : "Chat now",
//   gradient: const LinearGradient(
//     colors: [
//       AppColors.primaryColor,
//       AppColors.primaryTextColor,
//     ],
//     begin: Alignment.centerLeft,
//     end: Alignment.centerRight,
//   ),
// ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:try_app/pages/auth/loginPage.dart';
import 'package:url_launcher/url_launcher.dart'; // Add this import
import 'chat/chat_screen.dart';
import '../components/Button.dart';
import '../components/grdient_button.dart';
import '../components/product_details_full_screen.dart';
import '../constant/user_constant.dart';
import '../consts.dart';
import '../service/api_service.dart';
import '../service/review_service.dart';

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
  final ApiService _apiService = ApiService();
  final ReviewService _reviewService = ReviewService();

  // Review related variables
  final TextEditingController _reviewController = TextEditingController();
  int _selectedRating = 5;
  List<Map<String, dynamic>> _reviews = [];
  double _averageRating = 0.0;
  bool _isSubmittingReview = false;

  @override
  void initState() {
    super.initState();
    fetchProductDetails();
    _getUserData();
    imageurl = widget.image;
    _loadDummyReviews();
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  // Launch URL helper method
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open the link')),
        );
      }
    }
  }

  void _loadDummyReviews() {
    _reviews = [
      {
        'user_name': 'Amit Sharma',
        'rating': 5,
        'comment': 'Excellent product! Great condition and fast delivery. Highly recommend!',
        'date': '2025-01-15',
        'user_avatar': 'assets/default_avatar.png'
      },
      {
        'user_name': 'Priya Singh',
        'rating': 4,
        'comment': 'Good quality item, exactly as described. Owner was very responsive.',
        'date': '2025-01-10',
        'user_avatar': 'assets/default_avatar.png'
      },
      {
        'user_name': 'Rahul Verma',
        'rating': 5,
        'comment': 'Amazing experience! The product was in perfect condition.',
        'date': '2025-01-05',
        'user_avatar': 'assets/default_avatar.png'
      },
      {
        'user_name': 'Sneha Patel',
        'rating': 4,
        'comment': 'Very satisfied with the rental. Clean and well-maintained.',
        'date': '2024-12-28',
        'user_avatar': 'assets/default_avatar.png'
      },
    ];

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
    final text = '${product?['short_description']} - ${product?['description']}';
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

  Future<void> _submitReview() async {
    if (_reviewController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a review comment')),
      );
      return;
    }

    if (senderEmail == null || senderEmail!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User email not found')),
      );
      return;
    }

    setState(() {
      _isSubmittingReview = true;
    });

    try {
      final response = await _reviewService.submitReview(
        productId: widget.productId.toString(),
        rating: _selectedRating.toString(),
        name: senderEmail!.split('@')[0],
        email: senderEmail!,
        comment: _reviewController.text.trim(),
      );

      if (response != null && response['success'] == true) {
        final newReview = {
          'user_name': senderEmail!.split('@')[0],
          'rating': _selectedRating,
          'comment': _reviewController.text.trim(),
          'date': DateTime.now().toString().substring(0, 10),
          'user_avatar': 'assets/default_avatar.png'
        };

        setState(() {
          _reviews.insert(0, newReview);
          double total = _reviews.fold(0.0, (sum, review) => sum + review['rating']);
          _averageRating = total / _reviews.length;
          _reviewController.clear();
          _selectedRating = 5;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? 'Review submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to submit review. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error submitting review: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isSubmittingReview = false;
      });
    }
  }

  void _showReviewDialog() {
    showDialog(
      context: context,
      barrierDismissible: !_isSubmittingReview,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text(
                'Write a Review',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Product: ${product?['product_name'] ?? 'Unknown'}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Your Rating:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: List.generate(5, (index) {
                        return GestureDetector(
                          onTap: _isSubmittingReview ? null : () {
                            setDialogState(() {
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
                    TextField(
                      controller: _reviewController,
                      enabled: !_isSubmittingReview,
                      maxLines: 4,
                      maxLength: 500,
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
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: _isSubmittingReview ? null : () {
                    Navigator.of(context).pop();
                    _reviewController.clear();
                    _selectedRating = 5;
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: _isSubmittingReview ? null : () async {
                    Navigator.of(context).pop();
                    await _submitReview();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isSubmittingReview 
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                ),
              ],
            );
          },
        );
      },
    );
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
            if (UserConstant.USER_ID != null && UserConstant.USER_ID != 0)
              ElevatedButton.icon(
                onPressed: _isSubmittingReview ? null : _showReviewDialog,
                icon: const Icon(Icons.edit, color: Colors.white, size: 16),
                label: const Text(
                  'Write Review',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
          ],
        ),
        const SizedBox(height: 20),
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

  // NEW: Service buttons widget
Widget _buildServiceButtons() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Additional Services',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 16),
      GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2.5,
        children: [
          _buildServiceButton(
            icon: Icons.local_shipping,
            label: 'Delivery',
            domain: 'porter.in',
            url: 'https://porter.in/',
            color: Colors.blue,
          ),
          _buildServiceButton(
            icon: Icons.home_repair_service,
            label: 'Service',
            domain: 'urbancompany.com',
            url: 'https://www.urbancompany.com/',
            color: Colors.purple,
          ),
          _buildServiceButton(
            icon: Icons.security,
            label: 'Insurance',
            domain: 'acko.com',
            url: 'https://www.acko.com/',
            color: Colors.orange,
          ),
          _buildServiceButton(
            icon: Icons.payment,
            label: 'Rent Pay',
            domain: 'rentenpe.com',
            url: 'https://www.rentenpe.com/',
            color: Colors.green,
          ),
        ],
      ),
    ],
  );
}

 Widget _buildServiceButton({
  required IconData icon,
  required String label,
  required String domain,
  required String url,
  required Color color,
}) {
  return InkWell(
    onTap: () => _launchURL(url),
    child: Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            domain,
            style: TextStyle(
              color: color.withOpacity(0.8),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ),
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
                    builder: (context) => FullScreenImageView(imageUrl: imageurl),
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

            // NEW: Service buttons section
            _buildServiceButtons(),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Container(
                height: 0.7,
                color: Colors.grey.shade400,
              ),
            ),

            _buildReviewSection(),

            const SizedBox(height: 30),

            ButtonCustom(
              callback: () {
                if (UserConstant.USER_ID == null || UserConstant.USER_ID == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                  return;
                }

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
              title: UserConstant.USER_ID == null || UserConstant.USER_ID == 0 
                  ? "Login" 
                  : "Chat now",
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