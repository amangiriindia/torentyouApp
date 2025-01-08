import 'package:flutter/material.dart';
import '../consts.dart';
import 'Button.dart';

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String price;
  final String category;
  final VoidCallback onRentNow;

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.category,
    required this.title,
    required this.price,
    required this.onRentNow,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Card(
          elevation: 2,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: AppColors.cardOutlineColor.withOpacity(0.6),
              width: 1.7,
            ),
          ),
          color: Colors.white,
          child: InkWell(
            onTap: onRentNow,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  imageUrl,
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 180,
                      color: Colors.grey[200], // Optional background color for the icon
                      child: const Icon(
                        Icons.broken_image, // Broken image icon
                        size: 50,
                        color: Colors.grey, // Icon color
                      ),
                    );
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 6.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.currency_rupee_rounded, color: AppColors.primaryTextColor, size: 15.5),
                            Padding(
                              padding: const EdgeInsets.only(top: 2.0),
                              child: Text(
                                price,
                                style: const TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: ButtonCustom(
                            callback: onRentNow,
                            title: "View more",
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.primaryColor,
                                AppColors.primaryTextColor,
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



// void _showEditDialog() {
//   _editedRating = 4.0; // Set initial rating in the dialog
//   _editedCommentController.text = 'Test review comment here.'; // Set initial comment in the dialog
//
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//     ),
//     builder: (context) {
//       return Padding(
//         padding: EdgeInsets.only(
//           bottom: MediaQuery.of(context).viewInsets.bottom,
//           left: 16.0,
//           right: 16.0,
//           top: 20.0,
//         ),
//         child: Wrap(
//           spacing: 16.0, // Add spacing between the elements
//           runSpacing: 20.0, // Add spacing between the rows
//           children: [
//             const Center(
//               child: Text(
//                 'Edit Review',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//             ),
//             const SizedBox(height: 20),
//
//             // Rating
//             RatingBar.builder(
//               initialRating: _editedRating,
//               minRating: 1,
//               allowHalfRating: true,
//               itemCount: 5,
//               itemBuilder: (context, index) {
//                 return const Icon(
//                   Icons.star,
//                   color: Colors.amber,
//                 );
//               },
//               onRatingUpdate: (rating) {
//                 setState(() {
//                   _editedRating = rating;
//                 });
//               },
//             ),
//
//             // Edit Comment
//             TextField(
//               controller: _editedCommentController,
//               decoration: const InputDecoration(
//                 labelText: 'Comment',
//                 border: OutlineInputBorder(),
//                 contentPadding: EdgeInsets.all(12.0), // Increase padding inside the TextField
//               ),
//               maxLines: 3,
//             ),
//
//             // Submit Button
//             Container(
//               width: double.infinity,
//               margin: const EdgeInsets.only(top: 20.0), // Add top margin
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [AppColors.primaryTextColor, AppColors.primaryColor],
//                   begin: Alignment.centerLeft,
//                   end: Alignment.centerRight,
//                 ),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: ElevatedButton(
//                 onPressed: () {
//                   // Handle review submission (update rating and comment)
//                   Navigator.of(context).pop();
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.transparent,
//                   padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   elevation: 0,
//                 ),
//                 child: const Text(
//                   'Submit',
//                   style: TextStyle(color: Colors.white, fontSize: 16.0),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       );
//     },
//   );
// }