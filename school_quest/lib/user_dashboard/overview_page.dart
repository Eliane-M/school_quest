import 'package:flutter/material.dart';

class SchoolListingPage extends StatefulWidget {
  const SchoolListingPage({super.key});

  @override
  State<SchoolListingPage> createState() => _SchoolListingPageState();
}

class _SchoolListingPageState extends State<SchoolListingPage> {
  // Current index set to 1 for Overview page
  int _currentIndex = 1;
  
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
        case 1: // Overview - Already here
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
      backgroundColor: const Color(0xFFECF4FB),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search bar
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search School here...',
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 20,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Table headers
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: const [
                          Expanded(
                            flex: 3,
                            child: Text(
                              'School',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Location',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Admission',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Action',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 10),
                    
                    // School list
                    Expanded(
                      child: ListView(
                        children: const [
                          SchoolCard(
                            name: 'Green Hills Academy',
                            location: 'Kigali',
                            isOpen: true,
                          ),
                          SchoolCard(
                            name: 'FAWE Girls School',
                            location: 'Gisozi',
                            isOpen: false,
                          ),
                          SchoolCard(
                            name: 'Riviera High School',
                            location: 'Kabuga',
                            isOpen: false,
                          ),
                          SchoolCard(
                            name: 'Lycee de Kigali',
                            location: 'Kigali',
                            isOpen: true,
                          ),
                          SchoolCard(
                            name: 'King David Academy',
                            location: 'Kigali',
                            isOpen: true,
                          ),
                          SchoolCard(
                            name: 'Maranyundo Girls School',
                            location: 'Bugesera',
                            isOpen: false,
                          ),
                          SchoolCard(
                            name: 'Green Hills Academy',
                            location: 'Kigali',
                            isOpen: true,
                          ),
                          SchoolCard(
                            name: 'Petit Seminaire',
                            location: 'Gahanga',
                            isOpen: false,
                          ),
                          SchoolCard(
                            name: 'Sainte Bernadette Save',
                            location: 'Gisagara',
                            isOpen: false,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Updated Bottom navigation bar
            Container(
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
}

class SchoolCard extends StatelessWidget {
  final String name;
  final String location;
  final bool isOpen;
  
  const SchoolCard({
    super.key,
    required this.name,
    required this.location,
    required this.isOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              location,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              isOpen ? 'Open' : 'Closed',
              style: TextStyle(
                color: isOpen ? Colors.green : Colors.red,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'View',
              style: TextStyle(
                color: Colors.blue[700],
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}