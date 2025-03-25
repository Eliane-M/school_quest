import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

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
      initialRoute: '/usermanagement',
      routes: {
        '/admindashboard': (context) =>
            Scaffold(body: Center(child: Text('Admin Dashboard'))),
        '/schools': (context) =>
            Scaffold(body: Center(child: Text('Schools Page'))),
        '/analytics': (context) =>
            Scaffold(body: Center(child: Text('Analytics Page'))),
        '/adminprofile': (context) =>
            Scaffold(body: Center(child: Text('Admin Profile Page'))),
        '/usermanagement': (context) => const UserManagementScreen(),
      },
      home: const UserManagementScreen(),
    );
  }
}

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  _UserManagementScreenState createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  int _currentIndex = 1;

  // Text controllers for Add School
  final TextEditingController _schoolNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Image and dropdown variables
  File? _image;
  bool? _admissions;

  // Text controllers for Remove School
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _removeNameController = TextEditingController();
  final TextEditingController _removeLocationController = TextEditingController();

  // Firebase instances
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

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

  // Function to pick image
  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Function to add school to Firestore
  Future<void> _addSchool() async {
    // Basic validation for required fields (image is optional)
    if (_schoolNameController.text.isEmpty ||
        _locationController.text.isEmpty ||
        _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    try {
      // Log the school name to debug
      print('School Name from controller: ${_schoolNameController.text}');

      String? imageUrl;
      if (_image != null) {
        // Upload image to Firebase Storage if provided
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference ref = _storage.ref().child('school_images/$fileName');
        UploadTask uploadTask = ref.putFile(_image!);
        TaskSnapshot snapshot = await uploadTask;
        imageUrl = await snapshot.ref.getDownloadURL();
      }

      // Prepare the data to be saved
      Map<String, dynamic> schoolData = {
        'name': _schoolNameController.text.trim(),
        'image': imageUrl, // Will be null if no image is provided
        'admissions': _admissions ?? false,
        'location': _locationController.text.trim(),
        'description': _descriptionController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
      };

      // Log the data before saving
      print('Data to be saved: $schoolData');

      await _firestore.collection('schools').add(schoolData);

      // Clear fields after successful save
      _schoolNameController.clear();
      _locationController.clear();
      _descriptionController.clear();
      setState(() {
        _image = null;
        _admissions = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('School added successfully')),
      );

      // Navigate to /schools page after successful save
      Navigator.pushReplacementNamed(context, '/schools');
    } catch (e) {
      print('Error adding school: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding school: $e')),
      );
    }
  }

  // Function to remove school from Firestore
  Future<void> _removeSchool() async {
    try {
      QuerySnapshot query = await _firestore
          .collection('schools')
          .where('schoolName', isEqualTo: _removeNameController.text.trim())
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        // If the school has an image, delete it from Firebase Storage
        DocumentSnapshot schoolDoc = query.docs.first;
        String? imageUrl = schoolDoc.get('imageUrl') as String?;
        if (imageUrl != null) {
          try {
            await _storage.refFromURL(imageUrl).delete();
          } catch (e) {
            print('Error deleting image: $e');
          }
        }

        // Delete the school document
        await schoolDoc.reference.delete();

        _searchController.clear();
        _removeNameController.clear();
        _removeLocationController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('School removed successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('School not found')),
        );
      }
    } catch (e) {
      print('Error removing school: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error removing school: $e')),
      );
    }
  }

  @override
  void dispose() {
    _schoolNameController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _searchController.dispose();
    _removeNameController.dispose();
    _removeLocationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F1FD),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Add School',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      TextField(
                        controller: _schoolNameController,
                        decoration: InputDecoration(
                          hintText: 'School Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Image Upload Field (Optional)
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: _image == null
                                ? Text(
                                    'Tap to upload image (optional)',
                                    style: TextStyle(color: Colors.grey.shade400),
                                  )
                                : Image.file(_image!, fit: BoxFit.cover),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Admissions Dropdown
                      DropdownButtonFormField<bool>(
                        value: _admissions,
                        decoration: InputDecoration(
                          hintText: 'Admissions',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                        items: const [
                          DropdownMenuItem(value: true, child: Text('True')),
                          DropdownMenuItem(value: false, child: Text('False')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _admissions = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _locationController,
                        decoration: InputDecoration(
                          hintText: 'Location',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _descriptionController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Description',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 120,
                        child: ElevatedButton(
                          onPressed: _addSchool,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF9A86A),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Add School'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Remove School',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 12),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'search',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          suffixIcon:
                              Icon(Icons.search, color: Colors.grey.shade400),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _removeNameController,
                        decoration: InputDecoration(
                          hintText: 'School Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _removeLocationController,
                        decoration: InputDecoration(
                          hintText: 'Location',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 120,
                        child: ElevatedButton(
                          onPressed: _removeSchool,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Delete'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
                  color: Color(0xFF003A5D),
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