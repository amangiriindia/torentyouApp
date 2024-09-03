import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../consts.dart';

// 1. Data Model for Review
class Review {
  final String productName;
  final String imageUrl;
  final double rating;
  final String comment;
  final String userName;
  final String mobile;
  final String date;

  Review({
    required this.productName,
    required this.imageUrl,
    required this.rating,
    required this.comment,
    required this.userName,
    required this.mobile,
    required this.date,
  });
}

// 2. Dummy Data List
List<Review> reviews = [
  Review(
    productName: 'Test Product 1',
    imageUrl: 'https://torentyou.com/admin/uploads/room.jpg',
    rating: 4.5,
    comment: 'Great product, really loved it!',
    userName: 'Alice',
    mobile: '7070099770',
    date: '2024-08-12 21:03:10',
  ),
  Review(
    productName: 'Test Product 2',
    imageUrl: 'https://torentyou.com/admin/uploads/room.jpg',
    rating: 3.5,
    comment: 'Good quality, could be better.',
    userName: 'Bob',
    mobile: '7070099771',
    date: '2024-08-11 19:22:30',
  ),
  Review(
    productName: 'Test Product 3',
    imageUrl: 'https://torentyou.com/admin/uploads/room.jpg',
    rating: 5.0,
    comment: 'Excellent product, highly recommend!',
    userName: 'Charlie',
    mobile: '7070099772',
    date: '2024-08-10 14:15:20',
  ),
];

// 3. MyReviewPage Widget
class MyReviewPage extends StatefulWidget {
  const MyReviewPage({super.key});

  @override
  _MyReviewPageState createState() => _MyReviewPageState();
}

class _MyReviewPageState extends State<MyReviewPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Ads Review'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryColor,AppColors.primaryTextColor ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
        padding: const EdgeInsets.all(20.0),
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          final review = reviews[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(review.imageUrl),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
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
                        Row(
                          children: [
                            RatingBar.builder(
                              initialRating: review.rating,
                              minRating: 1,
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                return const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                );
                              },
                              ignoreGestures: true,
                              onRatingUpdate: (rating) {},
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          review.comment,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                        const Divider(thickness: 1, height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Name: ${review.userName}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[800],
                              ),
                            ),
                            Text(
                              'Mobile: ${review.mobile}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Date: ${review.date}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
