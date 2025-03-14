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
      initialRoute: '/search',
      routes: {
        '/userdashboard': (context) => Scaffold(body: Center(child: Text('Home Page'))),
        '/search': (context) => SearchPage(),
        '/chatpopup': (context) => Scaffold(body: Center(child: Text('Chat Page'))),
        '/profile': (context) => Scaffold(body: Center(child: Text('Profile Page'))),
      },
      home: SearchPage(),
    );
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // Current index set to 2 for Search page
  int _currentIndex = 2;
  
  final List<String> _suggestedSearches = [
    "Green Hills Academy",
    "Lycée de Kigali",
    "Riviera High School",
    "Gashora Girls",
    "Glory Academy",
    "Mother Mary",
  ];

  List<String> get suggestedSearches => _suggestedSearches;
  
  // Navigation function
  void _onNavItemTapped(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });
      
      // Navigate based on index
      switch (index) {
        case 0: // Home
          Navigator.pushReplacementNamed(context, '/userdashboard');
          break;
        case 1: // Overview
          Navigator.pushReplacementNamed(context, '/overview');
          break;
        case 2: // Search - Already here
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
      backgroundColor: const Color(0xFFECF4FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recently Searches",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Delete All",
                  style: TextStyle(color: Colors.blue, fontSize: 14),
                ),
              ],
            ),
            SizedBox(height: 5),
            Text("No recent searches have been found.",
                style: TextStyle(color: Colors.grey)),
            SizedBox(height: 20),
            Text(
              "Suggested searches",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 20,
              runSpacing: 10,
              children: suggestedSearches
                  .map(
                    (search) => Chip(
                      label:
                          Text(search, style: TextStyle(color: Colors.white)),
                      backgroundColor: Colors.blueGrey[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
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
              onTap: () => _onNavItemTapped(0),
              child: _buildNavItem(Icons.home, 'Home', _currentIndex == 0),
            ),
            GestureDetector(
              onTap: () => _onNavItemTapped(1),
              child: _buildNavItem(Icons.dashboard_outlined, 'Overview', _currentIndex == 1),
            ),
            GestureDetector(
              onTap: () => _onNavItemTapped(2),
              child: _buildNavItem(Icons.search, 'Search', _currentIndex == 2),
            ),
            GestureDetector(
              onTap: () => _onNavItemTapped(3),
              child: _buildNavItem(Icons.chat_bubble_outline, 'Chat', _currentIndex == 3),
            ),
            GestureDetector(
              onTap: () => _onNavItemTapped(4),
              child: _buildProfileNavItem(_currentIndex == 4),
            ),
          ],
        ),
      ),
    );
  }
  
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
                color: isSelected ? Colors.white : Colors.blueGrey[900],
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
}