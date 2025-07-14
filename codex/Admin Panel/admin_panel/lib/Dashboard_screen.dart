import 'package:admin_panel/Teacher/Teacher.dart';
import 'package:flutter/material.dart';
import 'package:admin_panel/Students.dart';
import 'package:admin_panel/Teacher/Teachers.dart';
import 'package:admin_panel/Courses/courses.dart';
import 'package:admin_panel/gigs.dart';
import 'package:admin_panel/Payments.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0), // Reduced padding
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10, // Reduced space between columns
          mainAxisSpacing: 10, // Reduced space between rows
          childAspectRatio: 3, // Adjusted aspect ratio for smaller items
          children: [
            _buildDashboardTile(
              context,
              icon: Icons.school,
              title: 'Teachers',
              color: Colors.blue,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TeacherScreen()));
              },
            ),
            _buildDashboardTile(
              context,
              icon: Icons.person,
              title: 'Students',
              color: Colors.purple,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => StudentScreen()));
              },
            ),
            _buildDashboardTile(
              context,
              icon: Icons.book,
              title: 'Courses',
              color: Colors.orange,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CourseScreen()));
              },
            ),
            _buildDashboardTile(
              context,
              icon: Icons.video_library,
              title: 'Free Courses',
              color: Colors.green,
              onTap: () {
                // Add your action for free courses
              },
            ),
            _buildDashboardTile(
              context,
              icon: Icons.work,
              title: 'Gigs',
              color: Colors.red,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => GigScreen()));
              },
            ),
            _buildDashboardTile(
              context,
              icon: Icons.monetization_on,
              title: 'Transactions',
              color: Colors.teal,
              onTap: () {
                // Add your action for transactions
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AdminPaymentsScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardTile(BuildContext context,
      {required IconData icon,
      required String title,
      required Color color,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius:
              BorderRadius.circular(15), // Slightly reduced border radius
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50, // Reduced icon size
              color: color,
            ),
            const SizedBox(height: 8), // Reduced space between icon and text
            Text(
              title,
              style: const TextStyle(
                fontSize: 16, // Reduced text size
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
