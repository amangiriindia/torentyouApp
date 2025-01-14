// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:try_test/constant/user_constant.dart';
// import '../consts.dart';
// import 'package:http/http.dart' as http;

// import 'myAdsReviewByProduct.dart';

// // 1. Data Model for Review
// class Review {
//   final String id;
//   final String productName;
//   final String imageUrl;
//   final double rating;
//   final String comment;
//   final String userName;
//   final String mobile;
//   final String date;

//   Review({
//     required this.id,
//     required this.productName,
//     required this.imageUrl,
//     required this.rating,
//     this.comment = 'Great product!',
//     this.userName = 'Static User',
//     this.mobile = '7070099770',
//     this.date = '2024-08-12 21:03:10',
//   });
// }

// class MyReviewPage extends StatefulWidget {
//   const MyReviewPage({super.key});

//   @override
//   _MyReviewPageState createState() => _MyReviewPageState();
// }

// class _MyReviewPageState extends State<MyReviewPage> {
//   List<Review> myAds = [];
//   bool isLoading = true;
//   bool hasError = false;
//   int? userId;

//   @override
//   void initState() {
//     super.initState();
//     _getUserData();

//   }
//   Future<void> _getUserData() async {
    
//     userId = UserConstant.USER_ID ?? 6;
//     setState(() {}); // Call setState to update the UI if `id` is being used there
//     if(userId != null){
//       fetchMyAds(); // Fetch ads when the widget initializes
//     }
//   }

//   Future<void> fetchMyAds() async {
//     try {
//       final response = await http.post(
//         Uri.parse('${AppConstant.API_URL}api/v1/product/user-myads-all-product'),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({
//           "seller_id": userId,
//         }),
//       );
//       print(response.body);
//       print(response.statusCode);

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);

//         // Check if the API returned a success and if the results are not null or empty
//         if (data['success'] && data['results'] != null) {
//           setState(() {
//             myAds = (data['results'] as List).map((item) {
//               // Handle missing or incorrect fields gracefully
//               return Review(
//                 id: item['id'].toString(),
//                 productName: item['product_name'] ?? 'Unnamed Product',
//                 imageUrl: item['image'] ?? 'https://placeholder.com/500', // Use a placeholder if image is missing
//                 rating: (item['rating_star'] ?? 0).toDouble(),
//               );
//             }).toList();
//             isLoading = false;
//             hasError = false; // Clear any previous errors
//           });
//         } else {
//           setState(() {
//             hasError = true;
//             isLoading = false;
//           });
//         }
//       } else {
//         setState(() {
//           hasError = true;
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       print('Error: $e');
//       setState(() {
//         hasError = true;
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('My Ads Review'),
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [AppColors.primaryColor, AppColors.primaryTextColor],
//             ),
//           ),
//         ),
//       ),
//       backgroundColor: Colors.white,
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : hasError
//           ? const Center(child: Text('Error fetching data'))
//           : ListView.builder(
//         padding: const EdgeInsets.all(20.0),
//         itemCount: myAds.length,
//         itemBuilder: (context, index) {
//           final review = myAds[index];
//           return GestureDetector(
//             onTap: () {
//               // Navigate to the AdsReviewByProduct page with the required data
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => AdsReviewByProduct(
//                     productId: review.id,
//                     imageUrl: review.imageUrl,
//                     productName: review.productName,
//                   ),
//                 ),
//               );
//             },
//             child: Padding(
//               padding: const EdgeInsets.only(bottom: 20.0),
//               child: Card(
//                 elevation: 6,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Container(
//                       width: double.infinity,
//                       height: 200,
//                       decoration: BoxDecoration(
//                         image: DecorationImage(
//                           image: NetworkImage(review.imageUrl),
//                           fit: BoxFit.cover,
//                         ),
//                         borderRadius: const BorderRadius.vertical(
//                             top: Radius.circular(15)),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             review.productName,
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 18,
//                               color: AppColors.primaryTextColor,
//                             ),
//                           ),
//                           const SizedBox(height: 5),
//                           Row(
//                             children: [
//                               RatingBar.builder(
//                                 initialRating: review.rating,
//                                 minRating: 1,
//                                 itemCount: 5,
//                                 itemBuilder: (context, index) {
//                                   return const Icon(
//                                     Icons.star,
//                                     color: Colors.amber,
//                                   );
//                                 },
//                                 ignoreGestures: true,
//                                 onRatingUpdate: (rating) {},
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 5),
//                           Text(
//                             review.comment,
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Colors.grey[700],
//                             ),
//                           ),
//                           const Divider(thickness: 1, height: 20),
//                           Row(
//                             mainAxisAlignment:
//                             MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 'Name: ${review.userName}',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.grey[800],
//                                 ),
//                               ),
//                               Text(
//                                 'Mobile: ${review.mobile}',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.grey[800],
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 5),
//                           Text(
//                             'Date: ${review.date}',
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:try_test/components/no_data_found.dart';
import 'package:try_test/service/api_service.dart';
import '../constant/user_constant.dart';
import '../consts.dart';
import 'myAdsReviewByProduct.dart';

// Data Model for Review
class Review {
  final String id;
  final String productName;
  final String imageUrl;
  final double rating;
  final String comment;
  final String userName;
  final String mobile;
  final String date;

  Review({
    required this.id,
    required this.productName,
    required this.imageUrl,
    required this.rating,
    this.comment = 'Great product!',
    this.userName = 'Static User',
    this.mobile = '7070099770',
    this.date = '2024-08-12 21:03:10',
  });
}

class MyReviewPage extends StatefulWidget {
  const MyReviewPage({super.key});

  @override
  _MyReviewPageState createState() => _MyReviewPageState();
}

class _MyReviewPageState extends State<MyReviewPage> {
  final ApiService _reviewService = ApiService();
  List<Review> myAds = [];
  bool isLoading = true;
  bool hasError = false;
  int? userId;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    userId = UserConstant.USER_ID ?? 6;
    if (userId != null) {
      await fetchMyAds();
    }
  }

  Future<void> fetchMyAds() async {
    try {
      final results = await _reviewService.fetchMyAds(userId!);
      setState(() {
        myAds = results.map<Review>((item) {
          return Review(
            id: item['id'].toString(),
            productName: item['product_name'] ?? 'Unnamed Product',
            imageUrl: item['image'] ?? 'https://placeholder.com/500',
            rating: (item['rating_star'] ?? 0).toDouble(),
          );
        }).toList();
        isLoading = false;
        hasError = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Ads Review'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryColor, AppColors.primaryTextColor],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasError
              ? const NoDataFound(message: 'No products found. Start selling your products now!')
              : ListView.builder(
                  padding: const EdgeInsets.all(20.0),
                  itemCount: myAds.length,
                  itemBuilder: (context, index) {
                    final review = myAds[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdsReviewByProduct(
                              productId: review.id,
                              imageUrl: review.imageUrl,
                              productName: review.productName,
                            ),
                          ),
                        );
                      },
                      child: _buildReviewCard(review),
                    );
                  },
                ),
    );
  }

  Widget _buildReviewCard(Review review) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(review.imageUrl),
                  fit: BoxFit.cover,
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review.productName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 5),
                  RatingBar.builder(
                    initialRating: review.rating,
                    minRating: 1,
                    itemCount: 5,
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    ignoreGestures: true,
                    onRatingUpdate: (_) {},
                  ),
                  const SizedBox(height: 5),
                  Text(
                    review.comment,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
