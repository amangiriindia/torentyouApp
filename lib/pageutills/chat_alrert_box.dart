// import 'package:flutter/material.dart';
//
// import '../chat/chat_screen.dart';
//
// void showModernDialog(BuildContext context, Function createChatRoom, String senderUserId, String senderEmail, String receiverUserId, String receiverEmail) {
//   showDialog(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(15),
//         ),
//         title: const Text(
//           "Important Notice",
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 18,
//           ),
//         ),
//         content: const Text(
//           "For your safety:\n\n"
//               "• Do not share personal information like OTP, passwords, or bank details.\n"
//               "• Avoid transferring money without verifying the product and seller.\n"
//               "• Communicate through the app for better security.\n\n"
//               "Proceed to chat if you agree to these terms.",
//           style: TextStyle(
//             fontSize: 14,
//             height: 1.5,
//           ),
//         ),
//         actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         actions: [
//           SizedBox(
//             width: double.infinity,
//             child: Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       Navigator.pop(context); // Close the dialog
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.grey[300],
//                       foregroundColor: Colors.black,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                     ),
//                     child: const Text("Cancel"),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       Navigator.pop(context); // Close the dialog
//                       // Navigate to ChatPage after user agrees
//                       createChatRoom();
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ChatPage(
//                             senderId: senderUserId,
//                             senderEmail: senderEmail,
//                             receiverUserID: receiverUserId,
//                             receiverUserEmail: receiverEmail,
//                           ),
//                         ),
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blueAccent,
//                       foregroundColor: Colors.white,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                     ),
//                     child: const Text("Proceed"),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       );
//     },
//   );
// }
