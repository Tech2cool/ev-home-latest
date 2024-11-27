import 'dart:async';
import 'package:ev_homes/components/animated_gradient_bg.dart';
import 'package:ev_homes/wrappers/customer_home_wrapper.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  List<Map<String, dynamic>> messages = [
    {"text": "Welcome to EV Homes!", "isBot": true},
    {"text": "How can I assist you today?", "isBot": true, "showOptions": true}
  ];
  final TextEditingController _controller = TextEditingController();
  bool _isTyping = false;
  late AnimationController _typingAnimationController;

  final Map<String, dynamic> botResponses = {
    "projects": {
      "text":
          "We have several exciting projects. Which one would you like to know more about?",
      "options": ["Luxury Villas", "Smart Homes", "Eco-friendly Apartments"]
    },
    "payment": {
      "text":
          "We offer various payment options to suit your needs. Which one interests you?",
      "options": ["Full payment", "Installment plans", "Home loan assistance"]
    },
    "issue":
        "I'm sorry to hear you're experiencing an issue. Could you please provide more details about the problem?",
    "human":
        "I'll connect you with one of our customer service representatives right away. Please hold for a moment.",
    "default":
        "I apologize, I didn't quite understand that. Could you please choose one of the following options?",
  };

  final List<String> mainOptions = [
    "Learn about our projects",
    "Discuss payment options",
    "Report an issue",
    "Speak to a human agent"
  ];

  @override
  void initState() {
    super.initState();
    _typingAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _typingAnimationController.dispose();
    super.dispose();
  }

  void _handleSubmitted(String text) {
    setState(() {
      messages.insert(0, {"text": text, "isBot": false});
      _isTyping = true;
    });
    _controller.clear();

    // Simulate bot thinking for 2 seconds
    Timer(const Duration(seconds: 2), () {
      _getBotResponse(text);
    });
  }

  void _getBotResponse(String userMessage) {
    String lowercaseMessage = userMessage.toLowerCase();
    dynamic botReply;
    bool showOptions = false;

    if (lowercaseMessage.contains("project") ||
        lowercaseMessage.contains("learn")) {
      botReply = botResponses["projects"];
      showOptions = true;
    } else if (lowercaseMessage.contains("payment") ||
        lowercaseMessage.contains("options")) {
      botReply = botResponses["payment"];
      showOptions = true;
    } else if (lowercaseMessage.contains("issue") ||
        lowercaseMessage.contains("problem")) {
      botReply = botResponses["issue"];
    } else if (lowercaseMessage.contains("human") ||
        lowercaseMessage.contains("agent")) {
      botReply = botResponses["human"];
    } else {
      botReply = botResponses["default"];
      showOptions = true;
    }

    setState(() {
      _isTyping = false;
      if (botReply is Map<String, dynamic>) {
        messages.insert(0, {
          "text": botReply["text"],
          "isBot": true,
          "showOptions": showOptions,
          "options": botReply["options"]
        });
      } else {
        messages.insert(
            0, {"text": botReply, "isBot": true, "showOptions": showOptions});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title:
            const Text('EV Homes Chat', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const CustomerHomeWrapper(),
              ),
            );
          },
        ),
      ),
      body: Stack(
        children: [
          const AnimatedGradientBg(),
          SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    itemCount: messages.length + (_isTyping ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (_isTyping && index == 0) {
                        return _buildTypingIndicator();
                      }
                      return _buildChatBubble(
                          messages[_isTyping ? index - 1 : index]);
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

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(120),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("EV Homes is typing",
                  style: TextStyle(color: Colors.black87)),
              const SizedBox(width: 8),
              AnimatedBuilder(
                animation: _typingAnimationController,
                builder: (context, child) {
                  return Row(
                    children: List.generate(3, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.black87.withOpacity(
                            index / 2 <= _typingAnimationController.value
                                ? 1
                                : 0.4,
                          ),
                          shape: BoxShape.circle,
                        ),
                      );
                    }),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatBubble(Map<String, dynamic> message) {
    bool isSentByUser = !message["isBot"];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment:
            isSentByUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                isSentByUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isSentByUser)
                const CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.house, color: Colors.white),
                ),
              const SizedBox(width: 8),
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    color: isSentByUser
                        ? Colors.blue.withAlpha(200)
                        : Colors.white.withAlpha(200),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message["text"],
                        style: TextStyle(
                            color:
                                isSentByUser ? Colors.white : Colors.black87),
                      ),
                      if (!isSentByUser && message["showOptions"] == true)
                        Column(
                          children: [
                            const SizedBox(height: 10),
                            ...(message["options"] ?? mainOptions)
                                .map((option) => Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: SizedBox(
                                        width: double.infinity,
                                        height: 40,
                                        child: ElevatedButton(
                                          onPressed: () =>
                                              _handleSubmitted(option),
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor:
                                                Colors.blue.withAlpha(100),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                          child: Text(option,
                                              style: const TextStyle(
                                                  color: Colors.white)),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              if (isSentByUser)
                const CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Icon(Icons.person, color: Colors.white),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(50),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Type your message...",
                hintStyle: const TextStyle(color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white.withAlpha(50),
              ),
              style: const TextStyle(color: Colors.white),
              onSubmitted: _handleSubmitted,
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            onPressed: () {
              if (_controller.text.trim().isNotEmpty) {
                _handleSubmitted(_controller.text.trim());
              }
            },
            backgroundColor: Colors.blue,
            child: const Icon(
              Icons.send,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
