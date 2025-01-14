import 'package:flutter/material.dart';
import 'package:try_test/components/no_data_found.dart';
import 'package:try_test/constant/user_constant.dart';
import 'package:try_test/service/api_service.dart';
import '../consts.dart';
import 'chat_screen.dart'; // Your chat page import


class ChatListLookingforScreen extends StatefulWidget {
  const ChatListLookingforScreen({super.key});

  @override
  State<ChatListLookingforScreen> createState() =>
      _ChatListLookingforScreenState();
}

class _ChatListLookingforScreenState extends State<ChatListLookingforScreen> {
  int userId = 0;
  String senderEmail = '';
  List<dynamic> chatRooms = [];
  bool isLoading = true;

  final ApiService _apiService = ApiService(); // Instantiate ApiService

  @override
  void initState() {
    super.initState();
    _getUserData(); // Fetch user data on initialization
  }

  // Function to get userId and email from SharedPreferences
  Future<void> _getUserData() async {
    setState(() {
      userId = UserConstant.USER_ID;
      senderEmail = UserConstant.EMAIL;
    });

    if (userId != 0) {
      _fetchChatRooms(); // Fetch chat rooms for the user
    }
  }

  // Function to fetch chat rooms from the API service
  Future<void> _fetchChatRooms() async {
    try {
      final chatRoomsData = await _apiService.fetchChatRoomsLookingFor(userId);
      setState(() {
        chatRooms = chatRoomsData;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Looking For',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 22.49,
            fontWeight: FontWeight.w500,
            height: 18.74 / 12.49, // Line height based on font size
            color: Colors.black,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryColor,
                AppColors.primaryTextColor,
              ],
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : chatRooms.isEmpty
              ? const NoDataFound(message: 'No chats available.', )
              : ListView.builder(
                  itemCount: chatRooms.length,
                  itemBuilder: (context, index) {
                    final chatRoom = chatRooms[index];
                    return _buildChatListItem(context, chatRoom);
                  },
                ),
    );
  }

  // Build each chat room list item
  Widget _buildChatListItem(BuildContext context, dynamic chatRoom) {
    final String chatRoomId = chatRoom['chat_room_id'];
    final String otherUserEmail = chatRoom['reciver_email'] == senderEmail
        ? chatRoom['sender_email']
        : chatRoom['reciver_email'];

    final int receiverUserId = chatRoom['reciver_id'] == userId
        ? chatRoom['sender_id']
        : chatRoom['reciver_id'];

    // Extract the first letter of the other user's email
    final String firstLetter =
        otherUserEmail.isNotEmpty ? otherUserEmail[0].toUpperCase() : '';

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryColor, // Replace with your gradient colors
                AppColors.primaryTextColor,
              ],
            ),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            firstLetter,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          otherUserEmail,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(chatRoom['product_name']),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          // Navigate to the chat page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                senderId: userId,
                senderEmail: senderEmail,
                receiverUserID: receiverUserId,
                receiverUserEmail: otherUserEmail,
                productImage: '',
                productName: '',
              ),
            ),
          );
        },
      ),
    );
  }
}
