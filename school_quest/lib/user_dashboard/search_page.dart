import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        '/userdashboard': (context) =>
            Scaffold(body: Center(child: Text('Home Page'))),
        '/search': (context) => SearchPage(),
        '/chatpopup': (context) =>
            Scaffold(body: Center(child: Text('Chat Page'))),
        '/profile': (context) =>
            Scaffold(body: Center(child: Text('Profile Page'))),
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
  int _currentIndex = 2;
  String? _username; // To store the username

  final List<String> _suggestedSearches = [
    "Green Hills Academy",
    "Lycée de Kigali",
    "Riviera High School",
    "Gashora Girls",
    "Glory Academy",
    "Mother Mary",
  ];

  List<String> get suggestedSearches => _suggestedSearches;

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

  void _onNavItemTapped(int index) {
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
          break;
        case 3:
          Navigator.pushReplacementNamed(context, '/helpcenter');
          break;
        case 4:
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
                  "Recent Searches",
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
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF003A5D), // Match ProfilePage
        selectedItemColor: const Color(0xFFF9A86A),
        unselectedItemColor: Colors.white,
        showUnselectedLabels: true,
        currentIndex: _currentIndex,
        onTap: _onNavItemTapped,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Overview',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              backgroundColor:
                  _currentIndex == 4 ? Color(0xFFF9A86A) : Colors.transparent,
              radius: 14,
              child: Text(
                _username?.isNotEmpty == true
                    ? _username![0].toUpperCase()
                    : "U",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}