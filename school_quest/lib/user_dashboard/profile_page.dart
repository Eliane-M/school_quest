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
      initialRoute: '/profile',
      routes: {
        '/userdashboard': (context) => Scaffold(body: Center(child: Text('Home Page'))),
        '/search': (context) => Scaffold(body: Center(child: Text('Search Page'))),
        '/helpcenter': (context) => Scaffold(body: Center(child: Text('Chat Page'))),
        '/profile': (context) => ProfilePage(),
      },
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _currentIndex = 4; // Profile tab selected by default

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
          Navigator.pushReplacementNamed(context, '/search');
          break;
        case 3:
          Navigator.pushReplacementNamed(context, '/helpcenter');
          break;
        case 4:
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
        ),
      ),
      body: ProfileContent(),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      backgroundColor: Color(0xFF003A5D),
      selectedItemColor: const Color(0xFFF9A86A),
      unselectedItemColor: Colors.white,
      showUnselectedLabels: true,
      currentIndex: _currentIndex,
      onTap: _onNavItemTapped,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined),
          label: "Overview",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: "Search",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          label: "Chat",
        ),
        BottomNavigationBarItem(
          icon: CircleAvatar(
            backgroundColor: _currentIndex == 4 ? Color(0xFFF9A86A) : Colors.transparent,
            radius: 14,
            child: Text("K", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
          label: "Profile",
        ),
      ],
    );
  }
}


class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile Card with Account Options Inside
          Stack(
            alignment: Alignment.topCenter,
            children: [
              // Extended Profile Box
              Container(
                margin: EdgeInsets.only(top: 70),
                padding:
                    EdgeInsets.only(top: 50, bottom: 30, left: 20, right: 20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    // Profile Name
                    Text(
                      "Milly K",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    // Profile Email
                    Text(
                      "khanah250@gmail.com",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    SizedBox(height: 30),

                    // Account Options Inside the Box
                    _buildAccountOption(
                        context, Icons.person_outline, "Edit Profile"),
                    SizedBox(height: 15),
                    _buildAccountOption(
                        context, Icons.lock_outline, "Update Password"),

                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 64),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF003A5D),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            "LOG OUT",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),

              // Profile Picture Positioned at the Top Center
              Positioned(
                top: 30,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: const Color(0xFFF9A86A),
                  child: Text(
                    "K",
                    style: TextStyle(
                        fontSize: 50,
                        color: Color(0xFF003A5D),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildAccountOption(
      BuildContext context, IconData icon, String title) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.black),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        trailing: Icon(Icons.chevron_right, size: 20),
        onTap: () {
          Navigator.pushNamed(context, '/forgotpassword');
        },
      ),
    );
  }
}
