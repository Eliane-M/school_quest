import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      initialRoute: '/overview',
      routes: {
        '/overview': (context) => const OverviewScreen(),
        '/admindashboard': (context) =>
            Scaffold(body: Center(child: Text('Admin Dashboard'))),
        '/schools': (context) =>
            Scaffold(body: Center(child: Text('Schools Page'))),
        '/adminprofile': (context) =>
            Scaffold(body: Center(child: Text('Admin Profile Page'))),
      },
      home: const OverviewScreen(),
    );
  }
}

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  int _currentIndex = 2; // Analytics tab selected
  String _firstLetter = 'K'; // Default letter until username is fetched

  @override
  void initState() {
    super.initState();
    _fetchUsername();
  }

  Future<void> _fetchUsername() async {
    try {
      // Get the current user from Firebase Authentication
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Fetch the user's data from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          String? username = userDoc.get('name') as String?;
          if (username != null && username.isNotEmpty) {
            setState(() {
              _firstLetter = username[0].toUpperCase();
            });
          }
        }
      }
    } catch (e) {
      print('Error fetching username: $e');
      // Keep default letter if there's an error
    }
  }

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
        // Already on Analytics page, no navigation needed
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/adminprofile');
        break;
    }
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
              const Center(
                child: Text(
                  'Overview',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0C4B6E),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.monetization_on_outlined,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Money Earned',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            '\$192,043',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.school_outlined,
                              color: Colors.black,
                              size: 18,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Registered Schools',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            '240',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Spendings vs Earnings',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.arrow_back_ios,
                                  size: 14, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text('2024',
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 12)),
                            ],
                          ),
                          Text('1 month',
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 12)),
                          Row(
                            children: [
                              Text('2024',
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 12)),
                              const SizedBox(width: 4),
                              Icon(Icons.arrow_forward_ios,
                                  size: 14, color: Colors.grey[600]),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 200,
                        child: LineChartSample(),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF0C4B6E),
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text('Earnings',
                                  style: TextStyle(fontSize: 12)),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.orange,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text('Spendings',
                                  style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Users Engagement',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: 150,
                          child: PieChartSample(),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLegendItem('Kigali', '52.1%', Colors.black),
                            const SizedBox(height: 8),
                            _buildLegendItem(
                                'Musanze', '22.8%', Colors.grey.shade600),
                            const SizedBox(height: 8),
                            _buildLegendItem(
                                'Rwamagana', '13.9%', Colors.lightGreen),
                            const SizedBox(height: 8),
                            _buildLegendItem('Other', '11.2%', Colors.lightBlue),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Transaction Summary',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              _buildTransactionCard(
                  'You have received \$3000 from Green Hills.'),
              const SizedBox(height: 8),
              _buildTransactionCard(
                  'You have received \$2000 from Mother Mary.'),
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
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.school_outlined),
            label: 'Schools',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 14,
              child: Text(
                _firstLetter, // Dynamically set the first letter
                style: const TextStyle(
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

  Widget _buildLegendItem(String title, String percentage, Color color) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 12)),
        const Spacer(),
        Text(
          percentage,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildTransactionCard(String message) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.attach_money,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Line Chart Sample
class LineChartSample extends StatelessWidget {
  const LineChartSample({super.key});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 25,
          verticalInterval: 5,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.3),
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: value == 15
                  ? Colors.grey.withOpacity(0.8)
                  : Colors.grey.withOpacity(0.3),
              strokeWidth: value == 15 ? 1 : 0.5,
              dashArray: value == 15 ? [5, 5] : null,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                return SideTitleWidget(
                  fitInside: SideTitleFitInsideData.fromTitleMeta(meta),
                  space: 8,
                  meta: meta,
                  child: Text(
                    '${value.toInt()}%',
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                return SideTitleWidget(
                  fitInside: SideTitleFitInsideData.fromTitleMeta(meta),
                  space: 8,
                  meta: meta,
                  child: Text(
                    '${value.toInt()}%',
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: 30,
        minY: 0,
        maxY: 100,
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 30),
              FlSpot(5, 50),
              FlSpot(10, 40),
              FlSpot(15, 80),
              FlSpot(20, 45),
              FlSpot(25, 60),
              FlSpot(30, 70),
            ],
            isCurved: true,
            color: const Color(0xFF0C4B6E),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: const Color(0xFF0C4B6E).withOpacity(0.1),
            ),
          ),
          LineChartBarData(
            spots: const [
              FlSpot(0, 10),
              FlSpot(5, 20),
              FlSpot(10, 35),
              FlSpot(15, 40),
              FlSpot(20, 30),
              FlSpot(25, 40),
              FlSpot(30, 35),
            ],
            isCurved: true,
            color: Colors.orange.withOpacity(0.8),
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            dashArray: [5, 5],
          ),
        ],
      ),
    );
  }
}

// Pie Chart Sample
class PieChartSample extends StatelessWidget {
  const PieChartSample({super.key});

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sectionsSpace: 0,
        centerSpaceRadius: 30,
        sections: [
          PieChartSectionData(
            color: Colors.black,
            value: 52.1,
            title: '',
            radius: 40,
          ),
          PieChartSectionData(
            color: Colors.grey.shade600,
            value: 22.8,
            title: '',
            radius: 40,
          ),
          PieChartSectionData(
            color: Colors.lightGreen,
            value: 13.9,
            title: '',
            radius: 40,
          ),
          PieChartSectionData(
            color: Colors.lightBlue,
            value: 11.2,
            title: '',
            radius: 40,
          ),
        ],
      ),
    );
  }
}