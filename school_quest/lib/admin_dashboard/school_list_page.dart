import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFE6F1FD),
      ),
      initialRoute: '/schools',
      routes: {
        '/admindashboard': (context) =>
            Scaffold(body: Center(child: Text('Admin Dashboard'))),
        '/schools': (context) => const SchoolListScreen(),
        '/analytics': (context) =>
            Scaffold(body: Center(child: Text('Analytics Page'))),
        '/adminprofile': (context) =>
            Scaffold(body: Center(child: Text('Admin Profile Page'))),
        '/usermanagement': (context) =>
            Scaffold(body: Center(child: Text('User Management Page'))),
      },
      home: const SchoolListScreen(),
    );
  }
}

class SchoolListScreen extends StatefulWidget {
  const SchoolListScreen({super.key});

  @override
  State<SchoolListScreen> createState() => _SchoolListScreenState();
}

class _SchoolListScreenState extends State<SchoolListScreen> {
  int _currentIndex = 1; // Schools tab selected
  String? _username; // To store the username

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
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/admindashboard');
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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 16.0),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Registered Schools',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/usermanagement');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF9A86A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    child: const Text(
                      'Add User',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('schools')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('Error loading schools'));
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final schools = snapshot.data!.docs;

                  if (schools.isEmpty) {
                    return const Center(child: Text('No schools found'));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: schools.length,
                    itemBuilder: (context, index) {
                      final schoolData =
                          schools[index].data() as Map<String, dynamic>;
                      final school = School(
                        name: schoolData['name'] ?? 'Unknown School',
                        description: schoolData['description'] ??
                            'No description available',
                      );
                      return SchoolCard(school: school);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF003A5D),
        selectedItemColor: const Color(0xFFF9A86A),
        unselectedItemColor: Colors.white,
        showUnselectedLabels: true,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school_outlined),
            label: 'Schools',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              backgroundColor:
                  _currentIndex == 3 ? Color(0xFFF9A86A) : Colors.transparent,
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
            label: 'Admin Profile',
          ),
        ],
      ),
    );
  }
}

class School {
  final String name;
  final String description;

  School({
    required this.name,
    required this.description,
  });
}

class SchoolCard extends StatelessWidget {
  final School school;

  const SchoolCard({
    Key? key,
    required this.school,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  school.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  school.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Row(
              children: [
                Text(
                  'View details',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 14,
                  ),
                ),
                Icon(
                  Icons.arrow_forward,
                  color: Colors.blue,
                  size: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}