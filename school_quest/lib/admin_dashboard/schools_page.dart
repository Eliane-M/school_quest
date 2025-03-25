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
      initialRoute: '/schoolsdashboard',
      routes: {
        '/schoolsdashboard': (context) => SchoolsDashboard(),
        '/schoollist': (context) =>
            Scaffold(body: Center(child: Text('School List Page'))),
        '/admindashboard': (context) =>
            Scaffold(body: Center(child: Text('Admin Dashboard'))),
        '/analytics': (context) =>
            Scaffold(body: Center(child: Text('Analytics Page'))),
        '/adminprofile': (context) =>
            Scaffold(body: Center(child: Text('Admin Profile Page'))),
      },
      home: SchoolsDashboard(),
    );
  }
}

class SchoolsDashboard extends StatefulWidget {
  const SchoolsDashboard({super.key});

  @override
  State<SchoolsDashboard> createState() => _SchoolsDashboardState();
}

class _SchoolsDashboardState extends State<SchoolsDashboard> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F9FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Registered Schools",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/schoollist');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF003A5D),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                        ),
                        child: const Text(
                          "View All",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('schools')
                    .limit(3) // Limiting to 3 schools like the original
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

                  return Column(
                    children: schools.map((schoolDoc) {
                      final school = schoolDoc.data() as Map<String, dynamic>;
                      return SchoolCard(
                        schoolName: school['name'] ?? 'Unknown School',
                        description: school['description'] ??
                            'No description available',
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 24),
              const Text(
                "Schools Payments",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
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
                child: Column(
                  children: [
                    PaymentRow("Green Hills", "\$942.00", "In Progress"),
                    PaymentRow("Riviera", "\$881.00", "Complete"),
                    PaymentRow("Glory", "\$409.00", "Pending"),
                    PaymentRow("LDC", "\$953.00", "In Progress"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(username: _username),
    );
  }
}

class SchoolCard extends StatelessWidget {
  final String schoolName;
  final String description;

  const SchoolCard({
    super.key,
    required this.schoolName,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
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
                  schoolName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
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
                  "View details",
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

class PaymentRow extends StatelessWidget {
  final String school;
  final String amount;
  final String status;

  const PaymentRow(this.school, this.amount, this.status, {super.key});

  Color getStatusColor(String status) {
    switch (status) {
      case "Complete":
        return Colors.green;
      case "In Progress":
        return Colors.orange;
      case "Pending":
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                ),
              ),
              Text(
                school,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: getStatusColor(status).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: getStatusColor(status),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomNavBar extends StatefulWidget {
  final String? username;

  const BottomNavBar({super.key, this.username});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/admindashboard');
        break;
      case 1:
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
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF003A5D),
      selectedItemColor: const Color(0xFFF9A86A),
      unselectedItemColor: Colors.white,
      showUnselectedLabels: true,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school_outlined),
          label: "Schools",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.analytics_outlined),
          label: "Analytics",
        ),
        BottomNavigationBarItem(
          icon: CircleAvatar(
            backgroundColor:
                _selectedIndex == 3 ? Color(0xFFF9A86A) : Colors.transparent,
            radius: 14,
            child: Text(
              widget.username?.isNotEmpty == true
                  ? widget.username![0].toUpperCase()
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
    );
  }
}