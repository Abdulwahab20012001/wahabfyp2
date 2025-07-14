import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fyp/custom_widgets/container.dart';
import 'package:fyp/screens/Teacher_Screens/profile_screens/teacher_profile.dart';
import 'package:fyp/screens/student_screens/StudentProfile_screens/student_profile.dart';
import 'package:fyp/utils/app_colors.dart';
import 'package:fyp/view_model/controllers/Student_controllers/Ssession_controller.dart';
import 'package:fyp/view_model/controllers/Student_controllers/spic&upd_controller.dart';
import 'package:fyp/view_model/controllers/Teacher_controllers/tpic&upd_controller.dart';
import 'package:fyp/view_model/controllers/Teacher_controllers/tsession_controller.dart';
import 'package:provider/provider.dart';

class StudentAccountScreen extends StatefulWidget {
  @override
  State<StudentAccountScreen> createState() => _StudentAccountScreenState();
}

class _StudentAccountScreenState extends State<StudentAccountScreen> {
  final ref = FirebaseDatabase.instance.ref('student');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // resizeToAvoidBottomInset: false,
        body: ChangeNotifierProvider(
      create: (_) => StudentProfileController(),
      child: Consumer<StudentProfileController>(
          builder: (context, Provider, child) {
        return Stack(
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
                              builder: (context) =>
                                  const studentprofilescreen())),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Mycolors.Text_white,
                        size: 40,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Account',
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
            Positioned(
              left: 30,
              top:
                  180, // Adjust this value to change the position of the container
              child: mycontainer(
                  borderRadius: 20,
                  color: Colors.white,
                  height: 480,
                  width: 300,
                  child: StreamBuilder(
                    stream: ref
                        .child(SSessionController.session.userid.toString())
                        .onValue,
                    builder: (context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasData) {
                        SSessionController.session.userid.toString();
                        dynamic map = snapshot.data.snapshot.value;

                        return Column(
                          children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: EdgeInsets.all(15.0),
                                      child: Text(
                                        'My Account Details',
                                        style: TextStyle(
                                            color: Mycolors.Text_black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Provider.UpdateUserName(
                                          context, map['name']);
                                    },
                                    child: ProfileDataBox(
                                        title: 'Username',
                                        value: map['name'],
                                        iconData: Icons.person_2_outlined),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Provider.UpdateEmail(
                                          context, map['email']);
                                    },
                                    child: ProfileDataBox(
                                        title: 'Email',
                                        value: map['email'],
                                        iconData: Icons.person_2_outlined),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Provider.UpdatePhone(
                                          context, map['phone']);
                                    },
                                    child: ProfileDataBox(
                                        title: 'Phone no',
                                        value: map['phone'],
                                        iconData: Icons.phone),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Provider.Updateeducation(
                                          context, map['education']);
                                    },
                                    child: ProfileDataBox(
                                        title: 'Education',
                                        value: map['education'],
                                        iconData: Icons.class_outlined),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Provider.Updatecity(context, map['city']);
                                    },
                                    child: ProfileDataBox(
                                        title: 'City',
                                        value: map['city'],
                                        iconData: Icons.location_city_outlined),
                                  ),
                                  /*   const Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.email_outlined),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        'Email',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Mycolors.Text_black),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 18.0),
                                  child: Text(
                                    map['email'],
                                    style: const TextStyle(
                                        fontSize: 15, color: Colors.black),
                                  ),
                                ),*/
                                ]),
                            const SizedBox(
                              height: 24,
                            ),
                            const SizedBox(
                              width: 90,
                              child: Divider(
                                color: Mycolors.primary_cyan,
                                thickness: 5,
                              ),
                            ),
                          ],
                        );
                      } else {
                        return const Center(
                            child: Text(
                          'Something went wrong',
                          style: TextStyle(color: Colors.black),
                        ));
                      }
                    },
                  )),
            ),
          ],
        );
      }),
    ));
  }
}

class ProfileDataBox extends StatelessWidget {
  final String title, value;
  final IconData iconData;

  const ProfileDataBox(
      {super.key,
      required this.title,
      required this.value,
      required this.iconData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            title,
            style: const TextStyle(fontSize: 14),
          ),
          leading: Icon(iconData),
          trailing: Text(
            value,
            style: const TextStyle(fontSize: 14),
          ),
        ),
        const Divider(
          color: Mycolors.secondary_grey,
          thickness: 1,
        ),
      ],
    );
  }
}
