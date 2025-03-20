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
      home: SchoolsDashboard(),
    );
  }
}

class SchoolsDashboard extends StatelessWidget {
  const SchoolsDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F9FF), // Match background color
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Registered Schools Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Registered Schools",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16, // Reduced font size
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
                            horizontal: 12, // Reduced padding
                            vertical: 6, // Reduced padding
                          ),
                        ),
                        child: const Text(
                          "View All",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14, // Reduced font size
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // const SizedBox(width: 8),
                      // ElevatedButton(
                      //   onPressed: () {},
                      //   style: ElevatedButton.styleFrom(
                      //     backgroundColor: const Color(0xFFF9A86A), // Orange
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(12),
                      //     ),
                      //     padding: const EdgeInsets.symmetric(
                      //       horizontal: 12, // Reduced padding
                      //       vertical: 6, // Reduced padding
                      //     ),
                      //   ),
                      //   child: const Text(
                      //     "Add User",
                      //     style: TextStyle(
                      //       color: Colors.white,
                      //       fontSize: 14, // Reduced font size
                      //       fontWeight: FontWeight.bold,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // List of Schools
              ...List.generate(
                3,
                (index) => SchoolCard(
                  schoolName: index % 2 == 0
                      ? "Green Hills Academy"
                      : "Riviera High School",
                  description:
                      "A private school fostering excellence and innovation in education.",
                ),
              ),
              const SizedBox(height: 24),

              // Schools Payments Section
              const Text(
                "Schools Payments",
                style: TextStyle(
                  fontSize: 16, // Reduced font size to match
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
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

// School Card Widget
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

// Payment Row Widget
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

// Bottom Navigation Bar
class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

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
      items: const [
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
    );
  }
}
