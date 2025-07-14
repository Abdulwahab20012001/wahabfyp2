import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fyp/custom_widgets/container.dart';
import 'package:fyp/screens/Teacher_Screens/profile_screens/teacher_profile.dart';
import 'package:fyp/utils/app_colors.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: const Color(0xffe0e0e0),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          Container(
            color: Mycolors.primary_cyan,
            height: 250,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 60.0),
              child: Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TeacherProfileScreen())),
                    // ignore: prefer_const_constructors
                    child: Icon(
                      Icons.arrow_back,
                      color: Mycolors.Text_white,
                      size: 40,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'About',
                      style: TextStyle(
                          color: Mycolors.Text_white,
                          fontWeight: FontWeight.bold,
                          fontSize: 35),
                    ),
                  )
                ],
              ),
            ),
          ),
          const Positioned(
            left: 30,
            top:
                180, // Adjust this value to change the position of the container
            child: mycontainer(
                borderRadius: 20,
                color: Colors.white,
                height: 480,
                width: 300,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'About Your App',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Mycolors.Text_black),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Your e-learning app is designed to provide a platform for teachers to sell courses, offer tutoring services, and for students to purchase courses and access free courses.',
                            style: TextStyle(
                                fontSize: 16, color: Mycolors.Text_black),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Features:',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Mycolors.Text_black),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '- Teachers can create and upload courses.',
                            style: TextStyle(
                                fontSize: 16, color: Mycolors.Text_black),
                          ),
                          SizedBox(height: 5),
                          Text(
                            '- Students can able to purchase courses.',
                            style: TextStyle(
                                fontSize: 16, color: Mycolors.Text_black),
                          ),
                          SizedBox(height: 5),
                          Text(
                            '- Students can access free courses.',
                            style: TextStyle(
                                fontSize: 16, color: Mycolors.Text_black),
                          ),
                          SizedBox(height: 5),
                          Text(
                            '- Teachers can offer tutoring services.',
                            style: TextStyle(
                                fontSize: 16, color: Mycolors.Text_black),
                          ),
                          SizedBox(height: 5),
                          Text(
                            '- Students can easily find a experienced tutor.',
                            style: TextStyle(
                                fontSize: 16, color: Mycolors.Text_black),
                          ),
                          SizedBox(height: 5),
                          Text(
                            '- User-friendly interface for easy navigation.',
                            style: TextStyle(
                                fontSize: 16, color: Mycolors.Text_black),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 90,
                      child: Divider(
                        color: Mycolors.primary_cyan,
                        thickness: 5,
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
