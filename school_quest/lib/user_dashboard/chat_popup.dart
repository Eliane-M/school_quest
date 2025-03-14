import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChatPopup(),
    );
  }
}

class ChatPopup extends StatefulWidget {
  const ChatPopup({super.key});

  @override
  _ChatPopupState createState() => _ChatPopupState();
}

class _ChatPopupState extends State<ChatPopup> {

  void _showChatPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85, // 85% of screen height
          minChildSize: 0.7,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Status: Connected",
                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  // Chat Header
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      child: Icon(Icons.support_agent, color: Colors.black54),
                    ),
                    title: Text(
                      "Schoolquest support chat",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("Schoolquest Team"),
                  ),
                  SizedBox(height: 10),
                  // Chat Messages
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: [
                        _chatBubble("Thanks for contacting Unicash! This is Customer care, how can I help you?", false),
                        SizedBox(height: 15),
                        _faqSection(),
                        SizedBox(height: 15),
                        _chatBubble(
                          "Dear customer, if the above Answers didn’t solve your current problem, you can chat with customer service",
                          false,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  // Chat Input Field
                  _chatInputField(),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _chatBubble(String text, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.only(left: isUser ? 40 : 0, right: isUser ? 0 : 40),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(text, style: TextStyle(color: Colors.black)),
      ),
    );
  }

  Widget _faqSection() {
    List<String> faqItems = [
      "Best Schools in Rwanda",
      "How can I apply",
      "Which applications are open",
      "How to switch account",
      "Payment process",
      "About scholarships",
    ];

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("You may want to ask", style: TextStyle(fontWeight: FontWeight.bold)),
          ...faqItems.map((item) => ListTile(
                title: Text(item),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {}, // Add functionality here
              )),
        ],
      ),
    );
  }

  Widget _chatInputField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Type here",
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Colors.blue),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Support")),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showChatPopup(context),
          child: Text("Open Chat"),
        ),
      ),
    );
  }
  
}
