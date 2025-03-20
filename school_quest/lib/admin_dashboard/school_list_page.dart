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
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFE6F1FD),
      ),
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

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Navigation logic
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
            // Back Arrow
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 16.0),
              // child: IconButton(
              //   icon: const Icon(Icons.arrow_back, color: Colors.black),
              //   onPressed: () {},
              // ),
            ),
            // Registered Schools and Add User Button
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
                      backgroundColor: const Color(0xFFF9A86A), // Orange
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
            // School List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: schoolsList.length,
                itemBuilder: (context, index) {
                  final school = schoolsList[index];
                  return SchoolCard(school: school);
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
        items: const [
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
              backgroundColor: Colors.white,
              radius: 14,
              child: Text(
                'K',
                style: TextStyle(
                  color: const Color(0xFF003A5D),
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

final List<School> schoolsList = [
  School(
    name: 'Green Hills Academy',
    description:
        'Green Hills Academy nurtures a community of caring, inquisitive, and principled learners who pursue excellence and contribute to our equitable world.',
  ),
  School(
    name: 'Riviera High School',
    description:
        'Riviera High School delivers a rigorous combined education characterized by relentless teaching with bold thinking values.',
  ),
  School(
    name: 'Green Hills Academy',
    description:
        'Green Hills Academy nurtures a community of caring, inquisitive, and principled learners who pursue excellence and contribute to our equitable world.',
  ),
  School(
    name: 'Riviera High School',
    description:
        'Riviera High School delivers a rigorous combined education characterized by relentless teaching with bold thinking values.',
  ),
  School(
    name: 'Green Hills Academy',
    description:
        'Green Hills Academy nurtures a community of caring, inquisitive, and principled learners who pursue excellence and contribute to our equitable world.',
  ),
  School(
    name: 'Green Hills Academy',
    description:
        'Green Hills Academy nurtures a community of caring, inquisitive, and principled learners who pursue excellence and contribute to our equitable world.',
  ),
  School(
    name: 'Green Hills Academy',
    description:
        'Green Hills Academy nurtures a community of caring, inquisitive, and principled learners who pursue excellence and contribute to our equitable world.',
  ),
  School(
    name: 'Green Hills Academy',
    description:
        'Green Hills Academy nurtures a community of caring, inquisitive, and principled learners who pursue excellence and contribute to our equitable world.',
  ),
  School(
    name: 'Green Hills Academy',
    description:
        'Green Hills Academy nurtures a community of caring, inquisitive, and principled learners who pursue excellence and contribute to our equitable world.',
  ),
];

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