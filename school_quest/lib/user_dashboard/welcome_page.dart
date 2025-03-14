import 'package:flutter/material.dart';
import 'package:school_quest/user_dashboard/search_page.dart';
import 'overview_page.dart';
import 'help_center_page.dart';
import 'chat_popup.dart';
import 'email_popup.dart';
import 'profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/userdashboard',
      routes: {
        '/userdashboard': (context) => const SchoolHomePage(),
        '/overview': (context) => SchoolListingPage(),
        '/search': (context) => SearchPage(),
        '/helpcenter': (context) => HelpCenterPage(),
        '/chatpopup': (context) => ChatPopup(),
        '/emailpopup': (context) => ContactPopup(),
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}

// Convert to StatefulWidget to manage navigation state
class SchoolHomePage extends StatefulWidget {
  const SchoolHomePage({super.key});

  @override
  State<SchoolHomePage> createState() => _SchoolHomePageState();
}

class _SchoolHomePageState extends State<SchoolHomePage> {
  int _currentIndex = 0;
  
  // This handles navigation without actually pushing new routes
  void _onItemTapped(int index, BuildContext context) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });
      
      // Navigate based on the index
      switch (index) {
        case 0: // Home - we're already here, so no navigation needed
          break;
        case 1: // Overview
          Navigator.pushReplacementNamed(context, '/overview');
          break;
        case 2: // Search
          Navigator.pushReplacementNamed(context, '/search');
          break;
        case 3: // Chat
          Navigator.pushReplacementNamed(context, '/helpcenter');
          break;
        case 4: // Profile
          Navigator.pushReplacementNamed(context, '/profile');
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF3FC), // Light blue background
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFFFB87A), // Orange background
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Let's get started,",
                    style: TextStyle(fontSize: 18, color: Color(0xFF0D577F)),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Education is the key to unlocking the world, a passport to freedom.\n– Oprah Winfrey",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: "Search School here...",
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        contentPadding: EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Recommended Schools Section
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Recommended Schools",
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  // Fixed horizontal scrolling
                  SizedBox(
                    height: 250,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        schoolCard("Green Hills Academy", "images/gha.png"),
                        schoolCard("Riviera High School", "images/rivi.png"),
                        schoolCard("Green Hills Academy", "images/gha.png"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Students & Parents Review Section
                  const Text(
                    "Students & Parents Review",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  reviewCard(
                    "Green Hills Academy",
                    "The teachers are very supportive, and the extracurricular activities are amazing. Aline M., Parent",
                    "4.5 (123 Reviews)",
                    "images/gha.png"
                  ),
                  reviewCard(
                    "Riviera High School",
                    "Great academic programms and leadership training. I loved my expereience here. Kevin N., Former Student",
                    "4.3 (152 Reviews)",
                    "images/rivi.png"),
                ],
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar with route integration
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF023652),
        selectedItemColor: Color(0xFFF9A86A),
        unselectedItemColor: Colors.white,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        currentIndex: _currentIndex,
        onTap: (index) => _onItemTapped(index, context),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Overview"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  // Function for School Cards
  Widget schoolCard(String title, String imagePath) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.asset(imagePath, height: 100, width: double.infinity, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                const Text(
                  "One of the top schools offering excellent education.",
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const SizedBox(height: 5),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFF9A86A),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 4)
                  ),
                  child: const Text("Explore Now", style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Function for Review Cards
  Widget reviewCard(String schoolName, String reviewer, String rating, String imagePath) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1),
        ],
      ),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(imagePath, width: 60, height: 60, fit: BoxFit.cover),
        ),
        title: Text(schoolName, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(reviewer, style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(Icons.star, color: Color(0xFFF9A86A), size: 16),
                const SizedBox(width: 5),
                Text(rating, style: const TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}