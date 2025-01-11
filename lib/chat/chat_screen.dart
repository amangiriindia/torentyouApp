import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:try_test/consts.dart';
import 'chat_service.dart';

class ChatPage extends StatefulWidget {
  final int senderId;
  final String senderEmail;
  final String receiverUserEmail;
  final int receiverUserID;

  const ChatPage({
    super.key,
    required this.senderId,
    required this.senderEmail,
    required this.receiverUserEmail,
    required this.receiverUserID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
        widget.senderId.toString(),
        widget.senderEmail,
        widget.receiverUserID.toString(),
        _messageController.text,
      );
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: 
      PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryColor, AppColors.primaryTextColor], // Define your gradient colors here
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent, // Make the background transparent
            title: Text(
              widget.receiverUserEmail,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            elevation: 0, // No shadow effect
            actions: [
              IconButton(
                icon: Icon(Icons.more_vert, color: Colors.white),
                onPressed: () {
                  // Add any additional actions (e.g., view profile)
                },
              ),
            ],
          ),
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    bool isSender = data['senderId'] == widget.senderId;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: BubbleSpecialTwo(
        text: data['message'],
        isSender: isSender,
        color: isSender ? AppColors.primaryColor : AppColors.primaryTextColor,
        textStyle: const TextStyle(fontSize: 16, color: Colors.white),
        tail: true,
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(
          widget.receiverUserID.toString(), widget.senderId.toString()),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          reverse: true, // Start from the bottom (latest messages)
          children: snapshot.data!.docs
              .map((document) => _buildMessageItem(document))
              .toList(),
        );
      },
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                filled: true,
                hintText: 'Type a message...',
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryColor,
                    AppColors.primaryTextColor,
                  ], // You can change these colors as per your requirement
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Material(
                  color: Colors
                      .transparent, // Make sure the button color is transparent to show the gradient
                  child: InkWell(
                    onTap:
                        sendMessage, // Ensure the tap functionality is intact
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
