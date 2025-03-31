import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: HelpCenterPage()));
}

class HelpCenterPage extends StatefulWidget {
  const HelpCenterPage({super.key});

  @override
  State<HelpCenterPage> createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends State<HelpCenterPage> {
  int _currentIndex = 3;
  String? _username; // To store the username
  final List<String> helpTopics = [
    "Best Schools in Rwanda",
    "How can I apply",
    "Which applications are open",
    "How to switch accounts",
    "Payment process",
    "About scholarships",
  ];

  // Example data for schools
  final Map<String, String> schoolDetails = {
    "Best Schools in Rwanda":
        "These are the top-rated schools in Rwanda based on academic performance and facilities.",
    "How can I apply":
        "You can apply through the official SchoolQuest platform by filling out the application form.",
    "Which applications are open":
        "Currently, applications are open for primary and secondary schools.",
    "How to switch accounts":
        "Go to the profile section and select 'Switch Account' to log in with a different account.",
    "Payment process":
        "Payments can be made via mobile money or bank transfer through the SchoolQuest platform.",
    "About scholarships":
        "Scholarships are available for top-performing students. Check the scholarships section for more details.",
  };

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Load user data from Firebase Authentication
  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _username = user.displayName ?? "Unknown User";
      });
    }
  }

  void _onItemTapped(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });

      switch (index) {
        case 0:
          Navigator.pushReplacementNamed(context, '/userdashboard');
          break;
        case 1:
          Navigator.pushReplacementNamed(context, '/overview');
          break;
        case 2:
          Navigator.pushReplacementNamed(context, '/search');
          break;
        case 3:
          break;
        case 4:
          Navigator.pushReplacementNamed(context, '/profile');
          break;
      }
    }
  }

  void _showContactForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFE6F1FD),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.7,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey.shade200)),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.grey.shade700),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 20),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.transparent,
                            backgroundImage:
                                AssetImage('images/email_support.png'),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Email",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  )),
                              SizedBox(height: 8),
                              TextField(
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.email),
                                  hintText: "name@example.com",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Full name",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  )),
                              SizedBox(height: 8),
                              TextField(
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.person),
                                  hintText: "Your name",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Message",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  )),
                              SizedBox(height: 8),
                              TextField(
                                maxLines: 2,
                                decoration: InputDecoration(
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.only(bottom: 18),
                                    child: Icon(Icons.message),
                                  ),
                                  hintText: "Describe your issue here..",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                // Perform form submission logic
                                print("Form submitted!");

                                // Show a success message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        "Your message has been sent successfully!"),
                                    duration: Duration(seconds: 2),
                                  ),
                                );

                                // Close the modal bottom sheet
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF00427A),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                "Submit",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
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
          },
        );
      },
    );
  }

  void _showChatPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.7,
          maxChildSize: 0.90,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey.shade200)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.grey.shade700),
                          onPressed: () => Navigator.pop(context),
                        ),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey.shade800),
                            children: [
                              TextSpan(
                                text: "Status:  ",
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500),
                              ),
                              TextSpan(
                                text: "Connected",
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 40),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.transparent,
                          backgroundImage:
                              AssetImage('images/chat_support.png'),
                        ),
                        SizedBox(width: 12),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey.shade800),
                            children: [
                              TextSpan(
                                text: "Schoolquest ",
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w800),
                              ),
                              TextSpan(
                                text: "Team",
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      "9:51 AM",
                      style:
                          TextStyle(color: Colors.grey.shade500, fontSize: 12),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.only(bottom: 16),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            constraints: BoxConstraints(maxWidth: 280),
                            child: Text(
                              "Thanks for contacting Unicash! This is Customer care, how can I help you?",
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 16),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "You may want to ask",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              SizedBox(height: 12),
                              _faqItem("Best Schools in Rwanda"),
                              _faqItem("How can I apply"),
                              _faqItem("Which applications are open"),
                              _faqItem("How to switch account"),
                              _faqItem("Payment process"),
                              _faqItem("About scholarships"),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.only(bottom: 16),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            constraints: BoxConstraints(maxWidth: 280),
                            child: Text(
                              "Dear customer, if the above Answers didn't solve your current problem, you can chat with customer service",
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      border:
                          Border(top: BorderSide(color: Colors.grey.shade200)),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.more_horiz,
                              color: Colors.grey.shade500),
                          onPressed: () {},
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Type here",
                                hintStyle:
                                    TextStyle(color: Colors.grey.shade500),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.send, color: Colors.blue),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 5,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Help Center",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF9A86A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "How can we help?",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Search help",
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Help topics",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.blueGrey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: helpTopics.map((topic) {
                  return ExpansionTile(
                    title: Text(
                      topic,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF003A5D), // Darker tone for text
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_drop_down,
                      color: Color(
                          0xFFF9A86A), // Highlight color for the dropdown icon
                    ),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset:
                                  Offset(0, 3), // Subtle shadow for elevation
                            ),
                          ],
                          border: Border.all(
                            color: Color(0xFFF9A86A), // Highlight border color
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          schoolDetails[topic] ?? "No details available.",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF003A5D), // Darker tone for text
                            height: 1.5, // Line height for better readability
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 30),
            Text(
              "Do you need additional assistance?",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              "Our friendly support team is here to help.",
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blueGrey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () => _showContactForm(context),
                    child: Column(
                      children: [
                        Icon(Icons.email, size: 40, color: Colors.black),
                        SizedBox(height: 5),
                        Text("Email"),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showChatPopup(context),
                    child: Column(
                      children: [
                        Icon(Icons.chat, size: 40, color: Colors.black),
                        SizedBox(height: 5),
                        Text("Chat"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF003A5D), // Match ProfilePage color
      selectedItemColor: const Color(0xFFF9A86A),
      unselectedItemColor: Colors.white,
      showUnselectedLabels: true,
      currentIndex: _currentIndex,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined),
          label: "Overview",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: "Search",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          label: "Chat",
        ),
        BottomNavigationBarItem(
          icon: CircleAvatar(
            backgroundColor:
                _currentIndex == 4 ? Color(0xFFF9A86A) : Colors.transparent,
            radius: 14,
            child: Text(
              _username?.isNotEmpty == true ? _username![0].toUpperCase() : "U",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          label: "Profile",
        ),
      ],
    );
  }

  Widget _faqItem(String text) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: TextStyle(fontSize: 14)),
          Icon(Icons.chevron_right, color: Colors.grey.shade700),
        ],
      ),
    );
  }
}
