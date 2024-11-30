import 'dart:ui';

import 'package:ev_homes/wrappers/cp_home_wrapper.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final Function() goBack;
  const ChatScreen({super.key, required this.goBack});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<String> messages = ["Hello!", "How can I help you today?"];
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: widget.goBack,
        ),
        title: const Text(
          'Chat',
          style: TextStyle(
            color: Color(0xFF042630),
          ),
        ),
      ),
      body: Stack(
        children: [
          // AnimatedGradient(),
          Positioned.fill(
            child: Image.asset(
              'assets/images/chat_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          // Positioned.fill(
          //   child: BackdropFilter(
          //     filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          //     child: Container(
          //       color: Colors.black.withOpacity(0.3),
          //     ),
          //   ),
          // ),
          SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return _buildChatBubble(messages[index]);
                    },
                  ),
                ),
                _buildInputArea(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble(String message) {
    bool isSentByUser = message != messages.first;

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
      child: Align(
        alignment: isSentByUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          decoration: BoxDecoration(
            color: isSentByUser
                ? Color.fromARGB(255, 203, 233, 227)
                : Color(0xFF042630),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Text(
            message,
            style: TextStyle(
              color: isSentByUser
                  ? Color(0xFF042630)
                  : Color.fromARGB(255, 203, 233, 227),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Type a message...",
                hintStyle: const TextStyle(color: Color(0xFF042630)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 203, 233, 227)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                if (_controller.text.trim().isNotEmpty) {
                  messages.insert(0, _controller.text.trim());
                  _controller.clear();
                }
              });
            },
            backgroundColor: Color.fromARGB(255, 203, 233, 227),
            child: const Icon(
              Icons.send,
              color: Color(0xFF042630),
            ),
          ),
        ],
      ),
    );
  }
}
