import 'package:flutter/material.dart';
import 'package:school_quest/authentication/auth.dart';
import 'package:school_quest/signin_page.dart';

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
        '/userdashboard': (context) =>
            Scaffold(body: Center(child: Text('Home Page'))),
        '/search': (context) =>
            Scaffold(body: Center(child: Text('Search Page'))),
        '/helpcenter': (context) =>
            Scaffold(body: Center(child: Text('Chat Page'))),
        '/profile': (context) => ProfilePage(),
        '/signin': (context) => SignInScreen(),
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
  int _currentIndex = 4;

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
            backgroundColor:
                _currentIndex == 4 ? Color(0xFFF9A86A) : Colors.transparent,
            radius: 14,
            child: Text("K",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          label: "Profile",
        ),
      ],
    );
  }
}

class ProfileContent extends StatefulWidget {
  const ProfileContent({super.key});

  @override
  State<ProfileContent> createState() => _ProfileContentState();
}

  class _ProfileContentState extends State<ProfileContent> {
  bool _isSigningOut = false; 
  final AuthService _authService = AuthService();

  // Logout function
  Future<void> _handleLogout() async {
    if (!mounted) {
    print("Widget is not mounted, aborting logout");
    return;
  }
    setState(() {
      _isSigningOut = true;
    });

    try {
      await _authService.signOut();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/signin',
          (route) => false,
        );
      }
    } catch (e) {
      setState(() {
        _isSigningOut = false;
      });
      // Optionally show an error message
      print('Logout error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
  }

  void showBottomSheet(BuildContext context, Widget child) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => child,
    );
  }

  void showLogoutBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent, // Makes background blend naturally
      isScrollControlled: true, // Allows full-height customization
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Logout",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003A5D)),
            ),
            SizedBox(height: 10),
            Text(
              "Are you sure you want to leave?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showSwitchAccountBottomSheet(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF003A5D),
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text("YES",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFF9A86A),
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text("CANCEL",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSwitchAccountBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent, // Makes background blend naturally
      isScrollControlled: true, // Allows full-height customization
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Mickie K",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Color(0xFFF9A86A),
                child: Text("M", style: TextStyle(color: Color(0xFF003A5D))),
              ),
              title: Text("mickie250@gmail.com"),
              trailing: Icon(Icons.circle, color: Colors.orange),
            ),
            SizedBox(height: 10),
            TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _showSwitchAsBottomSheet(context);
              },
              icon: Image.asset("images/switch_account.png", width: 45),
              label: Text(
                "Switch Account",
                style: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void _showSwitchAsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent, // Makes background blend naturally
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Switch As",
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width *
                    0.05, // Responsive font size (5% of screen width)
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double
                  .infinity, // Responsive button width (80% of screen width)
              child: ElevatedButton(
                onPressed: _isSigningOut ? null : _handleLogout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height *
                        0.02, // Responsive vertical padding
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "As User",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width *
                        0.04, // Responsive font size (4% of screen width)
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double
                  .infinity, // Responsive button width (80% of screen width)
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/admindashboard');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF003A5D),
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height *
                        0.02, // Responsive vertical padding
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "As Admin",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width *
                        0.04, // Responsive font size
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.015),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
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
                    Text(
                      "Milly K",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "khanah250@gmail.com",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    SizedBox(height: 30),
                    _buildCustomOption(
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
                            showLogoutBottomSheet(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF003A5D),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: _isSigningOut
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  "LOG OUT",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
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

  Widget _buildCustomOption(BuildContext context, IconData icon, String title) {
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
          Navigator.pushNamed(context, '/usereditprofile');
        },
      ),
    );
  }
}
