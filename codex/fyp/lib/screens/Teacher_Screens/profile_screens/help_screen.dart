import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fyp/custom_widgets/container.dart';
import 'package:fyp/screens/Teacher_Screens/profile_screens/teacher_profile.dart';
import 'package:fyp/utils/app_colors.dart';

class HelpScreen extends StatelessWidget {
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
                    child: const Icon(
                      Icons.arrow_back,
                      color: Mycolors.Text_white,
                      size: 40,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Help',
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
                            'Welcome to the Help and Support section!',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Here, you can find assistance for any issues you encounter while using our app. Whether you have questions about how to navigate the app, need help with account settings, or encounter technical difficulties, were here to help you every step of the way.Our dedicated support team is available to assist you.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Contact Information:',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'If you need further assistance, please don\'t hesitate to contact us:',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Email: minhasrafey@example.com\n'
                            'Phone: 03065005421',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Address: cityxyz\n',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 6,
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
