import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'chat_service.dart';

class ChatPage extends StatefulWidget {
  final int senderId;  // Added senderId
  final String senderEmail; // Added senderEmail
  final String receiverUserEmail;
  final int receiverUserID;

  const ChatPage({
    super.key,
    required this.senderId, // Required senderId
    required this.senderEmail, // Required senderEmail
    required this.receiverUserEmail,
    required this.receiverUserID
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
        widget.senderId.toString(),          // Pass senderId from ChatPage
        widget.senderEmail,        // Pass senderEmail from ChatPage
        widget.receiverUserID.toString(),     // Receiver's ID
        _messageController.text,   // The message text
      );
      // Clear controller
      _messageController.clear();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(widget.receiverUserEmail),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),

          // User input
          _buildMessageInput(),
        ],
      ),
    );
  }

  // Build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    // Alignment logic for message based on senderId:
    var alignment = (data['senderId'] == widget.senderId)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    double bottomRight = 0;
    double bottomLeft = 0;

    if (alignment == Alignment.centerRight) {
      bottomRight = 1;
      bottomLeft = 30;
    } else {
      bottomLeft = 1;
      bottomRight = 30;
    }

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(30),
                  topRight: const Radius.circular(30),
                  bottomRight: Radius.circular(bottomRight),
                  bottomLeft: Radius.circular(bottomLeft),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20),
                child: Text(
                  data['message'],
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build message list
  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverUserID.toString(), widget.senderId.toString()),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }

        return ListView(
          children: snapshot.data!.docs
              .map((document) => _buildMessageItem(document))
              .toList(),
        );
      },
    );
  }

  // Build message input
  Widget _buildMessageInput() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: TextField(
              style: const TextStyle(color: Colors.white, fontSize: 18),
              cursorColor: Colors.white,
              controller: _messageController,
              obscureText: false,
              decoration: InputDecoration(
                filled: true,
                hintText: "Enter Message",
                fillColor: const Color(0xff121212),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                hintStyle: const TextStyle(color: Colors.white38),
              ),
            ),
          ),
        ),

        // Send button
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
          child: FloatingActionButton(
            backgroundColor: Colors.orange,
            onPressed: sendMessage,
            child: const Icon(
              color: Colors.white,
              Icons.send_rounded,
              size: 40,
            ),
          ),
        ),
      ],
    );
  }
}
