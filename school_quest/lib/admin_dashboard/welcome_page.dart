import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/adminhomepage',
      routes: {
        '/adminhomepage': (context) => const AdminHomePage(),
        '/schools': (context) =>
            Scaffold(body: Center(child: Text('Schools Page'))),
        '/analytics': (context) =>
            Scaffold(body: Center(child: Text('Analytics Page'))),
        '/adminprofile': (context) =>
            Scaffold(body: Center(child: Text('Admin Profile Page'))),
      },
      home: const AdminHomePage(),
    );
  }
}

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _currentIndex = 0;
  String _firstLetter = 'U'; // Default letter until username is fetched

  @override
  void initState() {
    super.initState();
    _fetchUsername();
  }

  Future<void> _fetchUsername() async {
    try {
      // Get the current user from Firebase Authentication
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Fetch the user's data from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          String? username = userDoc.get('name') as String?;
          if (username != null && username.isNotEmpty) {
            setState(() {
              _firstLetter = username[0].toUpperCase();
            });
          }
        }
      }
    } catch (e) {
      print('Error fetching username: $e');
      // Keep default letter if there's an error
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/schools');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/analytics');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/adminprofile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F9FF),
        title: const Text(""),
      ),
      body: const WelcomePageContent(),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF003A5D),
      selectedItemColor: const Color(0xFFF9A86A),
      unselectedItemColor: Colors.white,
      showUnselectedLabels: true,
      currentIndex: _currentIndex,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: "Home",
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.school_outlined),
          label: "Schools",
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.analytics_outlined),
          label: "Analytics",
        ),
        BottomNavigationBarItem(
          icon: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 14,
            child: Text(
              _firstLetter, // Dynamically set the first letter
              style: const TextStyle(
                color: Color(0xFF003A5D),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          label: 'Admin Profile',
        ),
      ],
    );
  }
}

class WelcomePageContent extends StatelessWidget {
  const WelcomePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height, // Ensure full height
      child: Container(
        color: const Color(0xFFF2F9FF),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: const Color(0xFF023652),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Welcome Admin!',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Here's a summary of today's activity.",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: _buildStatsCard(
                          'Views', '7,265', '+11.01%', const Color(0xFFF9A86A)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildStatsCard(
                          'Visits', '3,671', '-0.03%', const Color(0xFF023652)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: _buildStatsCard('New Users', '256', '+15.03%',
                          const Color(0xFF023652)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildStatsCard('Active Users', '2,318',
                          '+6.08%', const Color(0xFFF9A86A)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Money Flow',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text('Graph Placeholder'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCard(
      String title, String value, String change, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            change,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}