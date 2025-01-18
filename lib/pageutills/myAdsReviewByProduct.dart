import 'package:flutter/material.dart';
import '../components/no_data_found.dart';
import '../consts.dart';
import '../service/api_service.dart';

class AdsReviewByProduct extends StatefulWidget {
  final String productId;
  final String imageUrl;
  final String productName;

  const AdsReviewByProduct({
    Key? key,
    required this.productId,
    required this.imageUrl,
    required this.productName,
  }) : super(key: key);

  @override
  _AdsReviewByProductState createState() => _AdsReviewByProductState();
}

class _AdsReviewByProductState extends State<AdsReviewByProduct> {
  List<Review> reviews = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchReviews();
  }

  Future<void> fetchReviews() async {
    try {
      ApiService apiService = ApiService();
      final reviewList = await apiService.fetchReviews(widget.productId);
      setState(() {
        reviews = reviewList;
        isLoading = false;
        hasError = false;
      });
    } catch (e) {
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
        title: Text(widget.productName),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryColor, AppColors.primaryTextColor],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.imageUrl),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Product ID: ${widget.productId}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
                '${widget.productName} - Customer Reviews',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : hasError
                  ? const NoDataFound(message: 'No reviews found for this product')
                  : ListView.builder(
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  final review = reviews[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${review.rating}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              review.comment,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Name: ${review.userName}',
                                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                                ),
                                Text(
                                  'Mobile: ${review.mobile}',
                                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Date: ${review.date}',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
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

class Review {
  final double rating;
  final String comment;
  final String userName;
  final String mobile;
  final String date;

  Review({
    required this.rating,
    required this.comment,
    required this.userName,
    required this.mobile,
    required this.date,
  });
}
