import 'package:flutter/material.dart';

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
        '/userdashboard': (context) => SchoolHomePage(),
        '/search': (context) => Scaffold(body: Center(child: Text('Search Page'))),
        '/chatpopup': (context) => Scaffold(body: Center(child: Text('Chat Page'))),
        '/profile': (context) => Scaffold(body: Center(child: Text('Profile Page'),),),
      },
      home: SchoolHomePage(),
    );
  }
}

class SchoolHomePage extends StatefulWidget {
  const SchoolHomePage({super.key});

  @override
  State<SchoolHomePage> createState() => _SchoolHomePageState();
}

class _SchoolHomePageState extends State<SchoolHomePage> {
  int _currentIndex = 0;

  // This handles navigation without actually pushing new routes
  void _onItemTapped(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });

      // Navigate based on the index
      switch (index) {
        case 0: // Home
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
      backgroundColor: const Color(0xFFE6F1FD), // Light blue background
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
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
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
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
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
                      "images/gha.png"),
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

      // Updated Bottom Navigation Bar with custom design
      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFF023652),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () => _onItemTapped(0),
              child: _buildNavItem(Icons.home, 'Home', _currentIndex == 0),
            ),
            GestureDetector(
              onTap: () => _onItemTapped(1),
              child: _buildNavItem(
                  Icons.dashboard_outlined, 'Overview', _currentIndex == 1),
            ),
            GestureDetector(
              onTap: () => _onItemTapped(2),
              child: _buildNavItem(Icons.search, 'Search', _currentIndex == 2),
            ),
            GestureDetector(
              onTap: () => _onItemTapped(3),
              child: _buildNavItem(
                  Icons.chat_bubble_outline, 'Chat', _currentIndex == 3),
            ),
            GestureDetector(
              onTap: () => _onItemTapped(4),
              child: _buildProfileNavItem(_currentIndex == 4),
            ),
          ],
        ),
      ),
    );
  }

  // Custom navigation item builder
  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: isSelected ? const Color(0xFFF9A86A) : Colors.white,
          size: 24,
        ),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFFF9A86A) : Colors.white,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  // Custom profile navigation item
  Widget _buildProfileNavItem(bool isSelected) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFF9A86A) : Colors.white,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              'K',
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF023652),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Text(
          'Profile',
          style: TextStyle(
            color: isSelected ? const Color(0xFFF9A86A) : Colors.white,
            fontSize: 10,
          ),
        ),
      ],
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
            child: Image.asset(imagePath,
                height: 100, width: double.infinity, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
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
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 4)),
                  child: const Text("Explore Now",
                      style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Function for Review Cards
  Widget reviewCard(
      String schoolName, String reviewer, String rating, String imagePath) {
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
          child:
              Image.asset(imagePath, width: 60, height: 60, fit: BoxFit.cover),
        ),
        title: Text(schoolName,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(reviewer, style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(Icons.star, color: Color(0xFFF9A86A), size: 16),
                const SizedBox(width: 5),
                Text(rating,
                    style:
                        const TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
