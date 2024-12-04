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
            color: Color.fromARGB(199, 248, 85, 4),
          ),
        ),
      ),
      body: Stack(
        children: [
          // AnimatedGradient(),
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
      padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 10),
      child: Align(
        alignment: isSentByUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          decoration: BoxDecoration(
            color: isSentByUser
                ? const Color(0xffeedbcd)
                : const Color(0xffeedbcd),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Text(
            message,
            style: TextStyle(
              color: isSentByUser
                  ? const Color.fromARGB(199, 248, 85, 4)
                  : const Color.fromARGB(199, 248, 85, 4),
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
                hintStyle:
                    const TextStyle(color: Color.fromARGB(199, 248, 85, 4)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Color(0xffeedbcd)),
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
            backgroundColor: const Color(0xfff4e9e0),
            child: const Icon(
              Icons.send,
              color: Color.fromARGB(199, 248, 85, 4),
            ),
          ),
        ],
      ),
    );
  }
}
