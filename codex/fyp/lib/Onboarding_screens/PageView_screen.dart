import 'package:flutter/material.dart';
import 'package:fyp/Onboarding_screens/First_screen.dart';
import 'package:fyp/Onboarding_screens/Second_screen.dart';
import 'package:fyp/Onboarding_screens/Third_screen.dart';
import 'package:fyp/screens/Teacher_Screens/register&login_screens/teacher_login.dart';
import 'package:fyp/screens/Teacher_Screens/teacher_inbox.dart';
import 'package:fyp/screens/student_screens/student_login.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:fyp/custom_widgets/container.dart';
import 'package:fyp/utils/app_colors.dart';

class pageview extends StatelessWidget {
  pageview({super.key});

  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView(
            controller: pageController,
            children: [
              screen1(),
              screen2(),
              screen3(),
            ],
          ),
          Container(
            alignment: Alignment(0, 0.55),
            child: SmoothPageIndicator(
              controller: pageController,
              count: 3,
              effect: WormEffect(
                dotColor: Colors.grey,
                activeDotColor: Colors.cyan, // Change this to cyan
              ),
            ),
          ),
          Container(
            alignment: Alignment(0, 0.72),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const teacherlogin()));
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Mycolors.primary_cyan,
                ),
                height: 50,
                width: 200,
                child: Center(
                    child: Text(
                  'Join as a teacher',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
              ),
            ),
          ),
          Container(
            alignment: Alignment(0, 0.88),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Studentlogin()));
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Mycolors.primary_cyan,
                ),
                height: 50,
                width: 200,
                child: Center(
                    child: Text(
                  'Join as a Student',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
              ),
            ),
          )
        ],
      ),
    );
  }
}
