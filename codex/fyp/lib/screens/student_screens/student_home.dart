import 'package:flutter/material.dart';
import 'package:fyp/screens/Course_Screens/Teacher_View/Add_Paycourse.dart';
import 'package:fyp/screens/Course_Screens/Teacher_View/Addfree_course.dart';
import 'package:fyp/screens/student_screens/StudentProfile_screens/student_profile.dart';
import 'package:fyp/screens/student_screens/student_dashboard.dart';
import 'package:fyp/screens/Teacher_Screens/teacher_gig.dart';
import 'package:fyp/screens/Teacher_Screens/teacher_inbox.dart';
import 'package:fyp/screens/Teacher_Screens/profile_screens/teacher_profile.dart';
import 'package:fyp/screens/student_screens/student_gigpage.dart';
import 'package:fyp/screens/student_screens/student_inbox.dart';
import 'package:fyp/utils/app_colors.dart';

// ignore: camel_case_types
class StudentHome extends StatefulWidget {
  const StudentHome({super.key});

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

// ignore: camel_case_types
class _StudentHomeState extends State<StudentHome> {
  int currentindex = 0;
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentscreen = StudentDashboardScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(bucket: bucket, child: currentscreen),
      bottomNavigationBar: BottomAppBar(
        // shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: IconButton(
                iconSize: 30.0,
                icon: Icon(
                  Icons.home,
                  color:
                      currentindex == 0 ? Mycolors.primary_cyan : Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    currentindex = 0;
                    currentscreen = StudentDashboardScreen();
                  });
                },
              ),
            ),
            Expanded(
              child: IconButton(
                iconSize: 30.0,
                icon: Icon(
                  Icons.dashboard,
                  color:
                      currentindex == 1 ? Mycolors.primary_cyan : Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    currentindex = 1;
                    currentscreen = StudentViewGigsScreen();
                  });
                },
              ),
            ),
            Expanded(
              child: IconButton(
                iconSize: 30.0,
                icon: Icon(
                  Icons.message,
                  color:
                      currentindex == 2 ? Mycolors.primary_cyan : Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    currentindex = 2;
                    currentscreen = StudentInboxScreen();
                  });
                },
              ),
            ),
            Expanded(
              child: IconButton(
                iconSize: 30.0,
                icon: Icon(
                  Icons.person,
                  color:
                      currentindex == 3 ? Mycolors.primary_cyan : Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    currentindex = 3;
                    currentscreen = const studentprofilescreen();
                  });
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Mycolors.bg_color,
    );
  }
}
