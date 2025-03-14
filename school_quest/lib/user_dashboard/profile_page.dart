import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {}, // Add navigation logic
        ),
        title: Text("Profile", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.blueGrey[50],
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.orange,
                  child: Text(
                    "K",
                    style: TextStyle(fontSize: 40, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10),
                Text("Milly K", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                Text("khanah250@gmail.com", style: TextStyle(color: Colors.grey)),
                SizedBox(height: 20),
              ],
            ),
          ),
          SizedBox(height: 20),
          _buildProfileOption(Icons.person, "Edit Profile"),
          _buildProfileOption(Icons.lock, "Update Password"),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {}, // Add logout logic
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueGrey[900],
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text("LOG OUT", style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
          Spacer(),
          _buildBottomNavBar(),
        ],
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: ListTile(
          leading: Icon(icon, color: Colors.black),
          title: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
          trailing: Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {}, // Add navigation logic
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.blueGrey[900],
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.white,
      showUnselectedLabels: true,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Overview"),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
        BottomNavigationBarItem(
          icon: CircleAvatar(
            backgroundColor: Colors.orange,
            child: Icon(Icons.person, color: Colors.black),
          ),
          label: "Profile",
        ),
      ],
    );
  }
}
