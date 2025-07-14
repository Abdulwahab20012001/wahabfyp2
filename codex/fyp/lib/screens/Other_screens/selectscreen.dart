import 'package:flutter/material.dart';
import 'package:fyp/custom_widgets/container.dart';
import 'package:fyp/screens/Teacher_Screens/register&login_screens/teacher_login.dart';
import 'package:fyp/screens/student_screens/student_login.dart';
//import 'package:study_buddy/Auth_screens/student_login.dart';
import 'package:fyp/screens/student_screens/student_register.dart';
//import 'package:study_buddy/Auth_screens/teacher_login.dart';
import 'package:fyp/screens/Teacher_Screens/register&login_screens/teacher_register.dart';
import 'package:fyp/utils/app_assets.dart';
import 'package:fyp/utils/app_colors.dart';

// ignore: camel_case_types
class selectscreen extends StatelessWidget {
  const selectscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color.fromARGB(255, 243, 240, 240),
      child: Column(
        children: [
          Container(
            height: 120,
            width: 450,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
                color: Mycolors.primary_cyan),
            child: const Center(
              child: Text(
                'Study Buddy',
                style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(
            height: 120,
          ),
          GestureDetector(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const teacherlogin())),
            child: Card(
              color: Mycolors.primary_cyan,
              elevation: 5,
              child: mycontainer(
                borderRadius: 20,
                color: Mycolors.primary_cyan,
                height: 170,
                width: 300,
                child: Center(
                  child: Row(
                    children: [
                      Image(
                        // color: Colors.red,
                        image: AssetImage(MyAssets.teacher_pic),
                        height: 100,
                        width: 90,
                      ),
                      const Text(
                        "Join as a Teacher",
                        style: TextStyle(
                            color: Mycolors.Text_white,
                            fontWeight: FontWeight.bold,
                            fontSize: 25),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Studentlogin())),
            child: Card(
              elevation: 5,
              color: Mycolors.primary_cyan,
              child: mycontainer(
                borderRadius: 20,
                color: Mycolors.primary_cyan,
                height: 170,
                width: 300,
                //color: const Color.fromARGB(255, 145, 28, 168),

                child: Center(
                    child: Row(
                  children: [
                    Image(
                      //   color: Colors.red,
                      image: AssetImage(MyAssets.student_pic),
                      height: 100,
                      width: 90,
                    ),
                    const Text(
                      "Join as a Student",
                      style: TextStyle(
                          color: Mycolors.Text_white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25),
                    ),
                  ],
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
