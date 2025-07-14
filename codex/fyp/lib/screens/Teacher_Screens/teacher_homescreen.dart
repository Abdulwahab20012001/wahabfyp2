import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fyp/Gig_screens/Teacher_View/Add_gig.dart';
//import 'package:fyp/Gig_screens/Teacher_Screens/teacher_gig.dart';
import 'package:fyp/screens/Course_Screens/Teacher_View/Add_Paycourse.dart';
import 'package:fyp/screens/Course_Screens/Teacher_View/Addfree_course.dart';
import 'package:fyp/screens/Teacher_Screens/teacher_dashboard.dart';
import 'package:fyp/screens/Teacher_Screens/teacher_gig.dart';
import 'package:fyp/screens/Teacher_Screens/teacher_inbox.dart';
import 'package:fyp/screens/Teacher_Screens/profile_screens/teacher_profile.dart';
import 'package:fyp/utils/app_colors.dart';

// ignore: camel_case_types
class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

// ignore: camel_case_types
class _homeState extends State<home> {
  int currentindex = 0;
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentscreen = TeacherDashboard();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(bucket: bucket, child: currentscreen),
      // Use a 'SizedBox' to add whitespace to a layout.
//Try using a 'SizedBox' rather than a 'Container'
      floatingActionButton: SizedBox(
        height: 55.0,
        width: 65.0,
        child: FittedBox(
          child: FloatingActionButton(
            backgroundColor: Mycolors.primary_cyan,
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text(
                      'Choose an option:',
                      style: TextStyle(color: Mycolors.Text_black),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: const Icon(Icons.video_library),
                          title: const Text('Add Pay Course'),
                          onTap: () {
                            // Add Pay Course functionality
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddCourseScreen()));
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.payment),
                          title: const Text('Add Free Course'),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AddFreeCourseScreen()));
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.create),
                          title: const Text('Create Gig'),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddGigScreen()));
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
          //  color: Mycolors.Text_white,
          shape: const CircularNotchedRectangle(),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                iconSize: 30.0,
                padding: const EdgeInsets.only(left: 28.0),
                icon: const Icon(Icons.home),
                onPressed: () {
                  setState(() {
                    currentindex = 0;
                    currentscreen = TeacherDashboard();
                  });
                },
              ),
              IconButton(
                iconSize: 30.0,
                padding: const EdgeInsets.only(right: 28.0),
                icon: const Icon(Icons.dashboard),
                onPressed: () {
                  setState(() {
                    currentindex = 1;
                    currentscreen = ViewGigsScreen();
                  });
                },
              ),
              IconButton(
                iconSize: 30.0,
                padding: const EdgeInsets.only(left: 28.0),
                icon: const Icon(Icons.message),
                onPressed: () {
                  setState(() {
                    currentindex = 2;
                    currentscreen = TeacherInboxScreen();
                  });
                },
              ),
              IconButton(
                iconSize: 30.0,
                padding: const EdgeInsets.only(right: 28.0),
                icon: const Icon(Icons.person),
                onPressed: () {
                  setState(() {
                    currentindex = 3;
                    currentscreen = TeacherProfileScreen();
                  });
                },
              )
            ],
          )),
      backgroundColor: Mycolors.bg_color,
    );
  }
}
