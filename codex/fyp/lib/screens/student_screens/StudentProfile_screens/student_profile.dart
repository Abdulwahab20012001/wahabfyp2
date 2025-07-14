import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fyp/Onboarding_screens/First_screen.dart';
import 'package:fyp/Onboarding_screens/PageView_screen.dart';
import 'package:fyp/custom_widgets/container.dart';
import 'package:fyp/screens/Teacher_Screens/profile_screens/about_screen.dart';
import 'package:fyp/screens/Teacher_Screens/profile_screens/help_screen.dart';
import 'package:fyp/screens/student_screens/StudentProfile_screens/student_Account.dart';
import 'package:fyp/screens/student_screens/student_home.dart';
import 'package:fyp/utils/app_colors.dart';
import 'package:fyp/view_model/controllers/Student_controllers/Ssession_controller.dart';
import 'package:fyp/view_model/controllers/Student_controllers/spic&upd_controller.dart';
import 'package:fyp/view_model/controllers/Teacher_controllers/tsession_controller.dart';
import 'package:provider/provider.dart';

// ignore: camel_case_types
class studentprofilescreen extends StatefulWidget {
  const studentprofilescreen({Key? key}) : super(key: key);

  @override
  State<studentprofilescreen> createState() => _studentprofilescreen();
}

// ignore: camel_case_types
class _studentprofilescreen extends State<studentprofilescreen> {
  final ref = FirebaseDatabase.instance.ref('student');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (_) => StudentProfileController(),
        child: Consumer<StudentProfileController>(
          builder: (context, provider, child) {
            return Stack(
              children: [
                Container(
                  color: const Color(0xffe0e0e0),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                ),
                Container(
                  color: Mycolors.primary_cyan,
                  height: 180,
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
                              builder: (context) => const StudentHome(),
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Mycolors.Text_white,
                            size: 40,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Profile',
                            style: TextStyle(
                              color: Mycolors.Text_white,
                              fontWeight: FontWeight.bold,
                              fontSize: 35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 30,
                  right: 30,
                  top:
                      120, // Adjust this value to change the position of the container
                  child: mycontainer(
                    borderRadius: 20,
                    color: Colors.white,
                    height: 545,
                    width: MediaQuery.of(context).size.width - 60,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: StreamBuilder(
                        stream: ref
                            .child(SSessionController.session.userid.toString())
                            .onValue,
                        builder: (context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasData) {
                            dynamic map = snapshot.data.snapshot.value;

                            return Column(children: [
                              Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  Container(
                                    height: 120,
                                    width: 120,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Mycolors.secondary_grey,
                                          width: 3),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(60),
                                      child: provider.image == null
                                          ? map['profile'].toString() == ""
                                              ? const Icon(
                                                  Icons.person,
                                                  size: 60,
                                                )
                                              : Image.network(
                                                  map['profile'].toString(),
                                                  fit: BoxFit.cover,
                                                )
                                          : Image.file(
                                              File(provider.image!.path)
                                                  .absolute,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      provider.pickImage(context);
                                    },
                                    child: const CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Mycolors.primary_cyan,
                                      child: Icon(
                                        Icons.add,
                                        size: 20,
                                        color: Mycolors.Text_white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              Text(
                                map['name'],
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                map['email'],
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Divider(
                                color: Mycolors.secondary_grey,
                                thickness: 1,
                                height: 30,
                              ),
                              buildProfileOption(
                                context,
                                icon: Icons.account_circle,
                                text: 'Account',
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          StudentAccountScreen()),
                                ),
                              ),
                              buildProfileOption(
                                context,
                                icon: Icons.info,
                                text: 'About',
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AboutScreen()),
                                ),
                              ),
                              buildProfileOption(
                                context,
                                icon: Icons.help,
                                text: 'Help',
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HelpScreen()),
                                ),
                              ),
                              buildProfileOption(
                                context,
                                icon: Icons.settings,
                                text: 'Settings',
                                onTap: () {},
                              ),
                              buildProfileOption(
                                context,
                                icon: Icons.logout,
                                text: 'Logout',
                                onTap: () {
                                  FirebaseAuth auth = FirebaseAuth.instance;
                                  auth.signOut().then((value) {
                                    SSessionController().userid = '';
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => pageview()),
                                    );
                                  });
                                },
                              ),
                              const SizedBox(
                                width: 90,
                                child: Divider(
                                  color: Mycolors.primary_cyan,
                                  thickness: 5,
                                ),
                              ),
                            ]);
                          } else {
                            return const Center(
                              child: Text(
                                'Something went wrong',
                                style: TextStyle(color: Colors.black),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildProfileOption(BuildContext context,
      {required IconData icon,
      required String text,
      required VoidCallback onTap}) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: 0), // Decreased vertical padding
      child: ListTile(
        leading: Icon(icon, color: Mycolors.primary_cyan),
        title: Text(
          text,
          style: const TextStyle(
            color: Mycolors.Text_black,
            fontSize: 18,
          ),
        ),
        onTap: onTap,
        trailing: const Icon(Icons.arrow_forward_ios,
            color: Mycolors.secondary_grey, size: 16),
      ),
    );
  }
}





// Previous deign code
/*
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fyp/custom_widgets/container.dart';
import 'package:fyp/screens/Teacher_Screens/teacher_homescreen.dart';
import 'package:fyp/screens/Other_screens/selectscreen.dart';
import 'package:fyp/screens/Teacher_Screens/profile_screens/about_screen.dart';
import 'package:fyp/screens/Teacher_Screens/profile_screens/account_screen.dart';
import 'package:fyp/screens/Teacher_Screens/profile_screens/help_screen.dart';
import 'package:fyp/utils/app_colors.dart';
import 'package:fyp/view_model/controllers/Teacher_controllers/tpic&upd_controller.dart';
import 'package:fyp/view_model/controllers/Teacher_controllers/tsession_controller.dart';
import 'package:provider/provider.dart';

class teacherprofilescreen extends StatefulWidget {
  const teacherprofilescreen({Key? key}) : super(key: key);

  @override
  State<teacherprofilescreen> createState() => _teacherprofilescreen();
}

class _teacherprofilescreen extends State<teacherprofilescreen> {
  final ref = FirebaseDatabase.instance.ref('teacher');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ChangeNotifierProvider(
            create: (_) => ProfileController(),
            child: Consumer<ProfileController>(
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
                                      builder: (context) => const home())),
                              child: const Icon(
                                Icons.arrow_back,
                                color: Mycolors.Text_white,
                                size: 40,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Profile',
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
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: StreamBuilder(
                                stream: ref
                                    .child(SessionController.session.userid
                                        .toString())
                                    .onValue,
                                builder: (context, AsyncSnapshot snapshot) {
                                  if (!snapshot.hasData) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasData) {
                                    print(
                                        "my data ${SessionController.session.userid.toString()
                                        }");

                                    dynamic map = snapshot.data.snapshot.value;

                                    return Row(
                                      children: [
                                        Stack(
                                          alignment: Alignment.topLeft,
                                          children: [
                                            Container(
                                              height: 102,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      color: Mycolors
                                                          .secondary_grey)),
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(80),
                                                  child: Provider.image == null
                                                      ? map['profile']
                                                                  .toString() ==
                                                              ""
                                                          ? const Icon(
                                                              Icons.person,
                                                              size: 35,
                                                            )
                                                          : Image(
                                                              fit: BoxFit.cover,
                                                              image:
                                                                  NetworkImage(
                                                                map['profile']
                                                                    .toString(),
                                                              ),
                                                            )
                                                      : Image.file(File(Provider
                                                              .image!.path)
                                                          .absolute)),
                                            ),
                                            Positioned(
                                              top: 76,
                                              left: 62,
                                              child: InkWell(
                                                onTap: () {
                                                  Provider.pickImage(context);
                                                },
                                                child: const CircleAvatar(
                                                  radius: 13,
                                                  backgroundColor:
                                                      Mycolors.primary_cyan,
                                                  child: Icon(
                                                    Icons.add,
                                                    size: 20,
                                                    color: Mycolors.Text_white,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                map['name'],
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                map['email'],
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 8,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
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
                              ),
                            ),
                            const Divider(
                              color: Mycolors.secondary_grey,
                              thickness: 1,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: InkWell(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AccountScreen())),
                                  child: const Text(
                                    'Account',
                                    style: TextStyle(
                                        color: Mycolors.Text_black,
                                        fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                            const Divider(
                              color: Mycolors.secondary_grey,
                              thickness: 1,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: InkWell(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AboutScreen())),
                                  child: const Text(
                                    'About',
                                    style: TextStyle(
                                        color: Mycolors.Text_black,
                                        fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                            const Divider(
                              color: Mycolors.secondary_grey,
                              thickness: 1,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: InkWell(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HelpScreen())),
                                  child: const Text(
                                    ' Help',
                                    style: TextStyle(
                                        color: Mycolors.Text_black,
                                        fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                            const Divider(
                              color: Mycolors.secondary_grey,
                              thickness: 1,
                            ),
                            const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Setting',
                                  style: TextStyle(
                                      color: Mycolors.Text_black, fontSize: 16),
                                ),
                              ),
                            ),
                            const Divider(
                              color: Mycolors.secondary_grey,
                              thickness: 1,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: InkWell(
                                  onTap: () {
                                    FirebaseAuth auth = FirebaseAuth.instance;
                                    auth.signOut().then((value) {
                                      SessionController().userid = '';
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const selectscreen()));
                                    });
                                  },
                                  child: const Text(
                                    'Logout',
                                    style: TextStyle(
                                        color: Mycolors.Text_black,
                                        fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                            const Divider(
                              color: Mycolors.secondary_grey,
                              thickness: 1,
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            const SizedBox(
                              width: 90,
                              child: Divider(
                                color: Mycolors.primary_cyan,
                                thickness: 5,
                              ),
                            ),
                          ],
                        ), // Add your widgets here
                      ),
                    ),
                  ],
                );
              },
            )));
  }
}
 */