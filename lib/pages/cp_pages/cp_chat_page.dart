import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatScree extends StatefulWidget {
  final Function() goBack;

  const ChatScree({Key? key, required this.goBack}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScree   > {
  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _addBotMessage(
      "Welcome to EV Homes Partner Chat! How can I assist you today?",
      choices: [
        "New listing",
        "Client interested",
        "Commission rates",
        "Marketing materials",
        "Training sessions"
      ],
    );
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    _addMessage(text, isPartner: true);
    _simulateBotResponse(text);
  }

  void _addMessage(String text, {bool isPartner = false, List<String>? choices}) {
    setState(() {
      _messages.insert(0, ChatMessage(
        text: text,
        isPartner: isPartner,
        timestamp: DateTime.now(),
        choices: choices,
        onChoiceSelected: _handleSubmitted,
      ));
    });
    _scrollToBottom();
  }

  void _addBotMessage(String text, {List<String>? choices}) {
    _addMessage(text, isPartner: false, choices: choices);
  }

  void _simulateBotResponse(String text) {
    setState(() => _isTyping = true);
    Future.delayed(Duration(seconds: 1), () {
      setState(() => _isTyping = false);
      final response = _getBotResponse(text);
      _addBotMessage(response.text, choices: response.choices);
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        0.0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  BotResponse _getBotResponse(String message) {
    if (message.toLowerCase().contains('new listing')) {
      return BotResponse(
        "Excellent! Let's add a new property to our listings. What type of property is it?",
        choices: ["House", "Apartment", "Condo", "Land", "Commercial"]
      );
    } else if (message.toLowerCase().contains('client interested')) {
      return BotResponse(
        "That's great news! What kind of property is your client interested in?",
        choices: ["Residential", "Commercial", "Investment"]
      );
    } else if (message.toLowerCase().contains('commission')) {
      return BotResponse(
        "Our commission rates vary based on the property type and value. What specific information do you need?",
        choices: ["Standard rates", "Volume bonuses", "Luxury property rates"]
      );
    } else if (message.toLowerCase().contains('marketing')) {
      return BotResponse(
        "We offer various marketing materials. What type are you looking for?",
        choices: ["Brochures", "Virtual tours", "Social media content", "Email templates"]
      );
    } else if (message.toLowerCase().contains('training')) {
      return BotResponse(
        "We have several upcoming training sessions. Which topic interests you most?",
        choices: ["Home staging", "Virtual tours", "Negotiation techniques", "Market trends"]
      );
    } else {
      return BotResponse(
        "I'm here to help with any questions about EV Homes. What would you like to know more about?",
        choices: ["Properties", "Partner services", "Support", "Other"]
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EV Homes Partner Chat', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.orange[800],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: widget.goBack,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.orange[100]!, Colors.white],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                reverse: true,
                itemBuilder: (_, int index) => _messages[index],
                itemCount: _messages.length,
                controller: _scrollController,
              ),
            ),
            if (_isTyping) _buildTypingIndicator(),
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.green[700],
            radius: 16,
            child: Text('EV', style: TextStyle(color: Colors.white, fontSize: 12)),
          ),
          SizedBox(width: 8.0),
          Text('EV Homes is typing...', style: TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -2),
            blurRadius: 6.0,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration: InputDecoration(
                  hintText: "Type your message...",
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                ),
              ),
            ),
            SizedBox(width: 8.0),
            FloatingActionButton(
              onPressed: () => _handleSubmitted(_textController.text),
              child: Icon(Icons.send, color: Colors.white),
              backgroundColor: Colors.orange[800],
              elevation: 2,
              mini: true,
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isPartner;
  final DateTime timestamp;
  final List<String>? choices;
  final Function(String) onChoiceSelected;

  const ChatMessage({
    Key? key,
    required this.text,
    required this.isPartner,
    required this.timestamp,
    this.choices,
    required this.onChoiceSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: isPartner ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isPartner ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isPartner) _buildAvatar(),
              SizedBox(width: 8.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: isPartner ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: isPartner ? Colors.blue[100] : Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 2),
                            blurRadius: 4.0,
                            color: Colors.black.withOpacity(0.1),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      child: Text(
                        text,
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      DateFormat('HH:mm').format(timestamp),
                      style: TextStyle(fontSize: 12.0, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.0),
              if (isPartner) _buildAvatar(),
            ],
          ),
          if (choices != null && choices!.isNotEmpty)
            _buildChoices(),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      backgroundColor: isPartner ? Colors.blue[700] : Colors.green[700],
      radius: 16,
      child: Text(
        isPartner ? 'CP' : 'EV',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  Widget _buildChoices() {
    return Container(
      margin: EdgeInsets.only(top: 8.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: choices!.map((choice) => ElevatedButton(
          onPressed: () => onChoiceSelected(choice),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange[800],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            textStyle: TextStyle(fontSize: 14.0),
            elevation: 2,
          ),
          child: Text(choice, style: TextStyle(color: Colors.white)),
        )).toList(),
      ),
    );
  }
}

class BotResponse {
  final String text;
  final List<String>? choices;

  BotResponse(this.text, {this.choices});
}

