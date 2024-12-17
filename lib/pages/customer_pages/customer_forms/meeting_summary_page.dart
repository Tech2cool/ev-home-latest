// import 'package:ev_homes_customer/pages/AnimatedGradientScreen.dart';
// import 'package:ev_homes/Customer%20pages/AnimatedGradientScreen.dart';
import 'dart:async';
import 'package:ev_homes/components/animated_gradient_bg.dart';
import 'package:flutter/material.dart';

class MeetingSummaryPage extends StatelessWidget {
  final String title;
  final String description;
  final String date;

  const MeetingSummaryPage({
    super.key,
    required this.title,
    required this.description,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meeting Summary'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          const AnimatedGradientBg(),
          // Foreground content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                      // Ensure visibility over gradient
                      ),
                ),
                const SizedBox(height: 16),
                Text(
                  description,
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black // Ensure visibility over gradient
                      ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Completed on: $date',
                  style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black // Ensure visibility over gradient
                      ),
                ),
                const SizedBox(height: 16),
                // const Text(
                //   'Cost: 1.1CR',
                //   style: TextStyle(
                //     fontSize: 14,
                //     color:  Colors.black
                //   ),
                // ),
                // const SizedBox(height: 16),
                // const Text(
                //   'Unit No: 707',
                //   style: TextStyle(
                //     fontSize: 14,
                //     color:  Colors.black
                //   ),
                // ),
                const SizedBox(height: 20),
                Center(
                  // Center the button
                  child: TextButton(
                    onPressed: () {
                      _showChatBotBottomSheet(context);
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 30),
                      backgroundColor:
                          Colors.transparent, // Transparent background
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(
                            color: Colors.white54), // Border color
                      ),
                    ),
                    child: const Text(
                      'Chat',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Ensure visibility over gradient
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void _showChatBotBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: const ChatBottomSheet(),
      );
    },
  );
}

class ChatBottomSheet extends StatefulWidget {
  const ChatBottomSheet({super.key});

  @override
  State<ChatBottomSheet> createState() => _ChatBottomSheetState();
}

class _ChatBottomSheetState extends State<ChatBottomSheet>
    with TickerProviderStateMixin {
  List<Map<String, dynamic>> messages = [
    {"text": "Welcome to EV Homes!", "isBot": true},
    {
      "text": "Hello, How can I help you today!",
      "isBot": true,
      "showOptions": true, // Show main options under this message
    }
  ];

  final TextEditingController _controller = TextEditingController();
  bool _isTyping = false;
  late AnimationController _typingAnimationController;

  final Map<String, dynamic> botResponses = {
    "meeting": {
      "text": "Any Questions related to?",
      "options": ["Cost", "Flat No.", "Booking"]
    },
    "issue":
        "I'm sorry to hear you're experiencing an issue. Could you please provide more details about the problem?",
    "human":
        "I'll connect you with one of our customer service representatives right away. Please hold for a moment.",
    "default":
        "I apologize, I didn't quite understand that. Could you please choose one of the following options?",
  };

  final List<String> mainOptions = [
    "Meeting",
    "Report an issue",
    "Speak to a human agent",
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

    if (lowercaseMessage.contains("meeting") ||
        lowercaseMessage.contains("related")) {
      botReply = botResponses["meeting"];
      showOptions = true;
    } else if (lowercaseMessage.contains("issue") ||
        lowercaseMessage.contains("problem")) {
      botReply = botResponses["issue"];
    } else if (lowercaseMessage.contains("human") ||
        lowercaseMessage.contains("agent")) {
      botReply = botResponses["human"];
    } else if (lowercaseMessage.contains("cost")) {
      botReply = "As we discussed earlier, the Cost is 1.1 CR.";
    } else if (lowercaseMessage.contains("flat no")) {
      botReply = "As we discussed earlier, the Flat No. is 707.";
    } else if (lowercaseMessage.contains("booking")) {
      botReply =
          "For booking details, please contact our Sales team at sales@evhomes.com.";
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
          "options": botReply["options"] ?? [],
        });
      } else {
        messages.insert(0, {
          "text": botReply,
          "isBot": true,
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
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
                  backgroundColor: Colors.orange,
                  child: Icon(Icons.house, color: Colors.white),
                ),
              const SizedBox(width: 8),
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    color: isSentByUser
                        ? Colors.orange
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
                                            backgroundColor: Colors.orange,
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
                  backgroundColor: Colors.white70,
                  child: Icon(Icons.person, color: Colors.orange),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOptions(List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: options.map((option) {
        return Padding(
          padding: const EdgeInsets.only(top: 5),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _handleSubmitted(option),
              child: Text(option, style: const TextStyle(color: Colors.black)),
            ),
          ),
        );
      }).toList(),
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
                fillColor: Colors.black.withAlpha(50),
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
            backgroundColor: Colors.orange,
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
