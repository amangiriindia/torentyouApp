import 'package:flutter/material.dart';
import '../components/no_data_found.dart';
import '../constant/user_constant.dart';
import '../consts.dart';
import '../service/api_service.dart';
import 'chat_screen.dart'; // Your chat page import


class ChatListRentreqScreen extends StatefulWidget {
  const ChatListRentreqScreen({super.key});

  @override
  State<ChatListRentreqScreen> createState() => _ChatListRentreqScreenState();
}

class _ChatListRentreqScreenState extends State<ChatListRentreqScreen> {

  List<dynamic> chatRooms = [];
  bool isLoading = true;
  final ApiService apiService = ApiService(); // Create an instance of ApiService

  @override
  void initState() {
    super.initState();
    print(UserConstant.USER_ID);
    print(UserConstant.EMAIL);
    _fetchChatRooms();
  }

  // Function to fetch chat rooms using the ApiService
  Future<void> _fetchChatRooms() async {
    try {
      final chatRoomsData = await apiService.fetchChatRoomsRentReq(); // Fetch chat rooms using the ApiService
      setState(() {
        chatRooms = chatRoomsData;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching chat rooms: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching chat rooms')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Rent Request',
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
    final String otherUserEmail = chatRoom['reciver_email'] == UserConstant.EMAIL
        ? chatRoom['sender_email']
        : chatRoom['reciver_email'];

    final int receiverUserId = chatRoom['reciver_id'] == UserConstant.EMAIL
        ? chatRoom['sender_id']
        : chatRoom['reciver_id'];

    // Extract the first letter of the other user's email
      final String productname = chatRoom['product_name'];
    final String firstLetter =
        productname.isNotEmpty ? productname[0].toUpperCase() : '';

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
        productname,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(otherUserEmail),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          // Navigate to the chat page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                senderId: UserConstant.USER_ID,
                senderEmail: UserConstant.EMAIL,
                receiverUserID: receiverUserId,
                receiverUserEmail: otherUserEmail,
                productName: productname,
                productImage: '',
              ),
            ),
          );
        },
      ),
    );
  }
}
