import 'package:flutter/material.dart';
import 'package:admin_panel/Courses/Approved_courses.dart';
import 'package:admin_panel/Courses/Pending_Courses.dart';
import 'package:admin_panel/Courses/Reject_Courses.dart';

class CourseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Course Management',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade200, Colors.teal.shade500],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCourseOption(
              context,
              title: 'Pending Courses',
              description: 'Review and approve or reject pending courses',
              icon: Icons.hourglass_empty,
              color: Colors.orangeAccent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PendingCoursesScreen(),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            _buildCourseOption(
              context,
              title: 'Approved Courses',
              description: 'View all approved courses',
              icon: Icons.check_circle_outline,
              color: Colors.greenAccent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ApprovedCoursesScreen(),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            _buildCourseOption(
              context,
              title: 'Rejected Courses',
              description: 'View all rejected courses',
              icon: Icons.cancel_outlined,
              color: Colors.redAccent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RejectedCoursesScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // A reusable widget to build each course option card
  Widget _buildCourseOption(BuildContext context,
      {required String title,
      required String description,
      required IconData icon,
      required Color color,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.white.withOpacity(0.5),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 6),
              blurRadius: 6,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
              color: color,
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 30,
              color: Colors.black54,
            ),
          ],
        ),
      ),
    );
  }
}
