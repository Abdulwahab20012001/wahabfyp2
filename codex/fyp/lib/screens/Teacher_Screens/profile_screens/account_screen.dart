import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fyp/custom_widgets/container.dart';
import 'package:fyp/screens/Teacher_Screens/profile_screens/teacher_profile.dart';
import 'package:fyp/utils/app_colors.dart';
import 'package:fyp/view_model/controllers/Teacher_controllers/tpic&upd_controller.dart';
import 'package:fyp/view_model/controllers/Teacher_controllers/tsession_controller.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final ref = FirebaseDatabase.instance.ref('teacher');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (_) => ProfileController(),
        child: Consumer<ProfileController>(
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
                  height: 250,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 60.0),
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const TeacherProfileScreen(),
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
                            'Account',
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
                  top: 180,
                  child: mycontainer(
                    borderRadius: 20,
                    color: Colors.white,
                    height: 480,
                    width: 300,
                    child: StreamBuilder(
                      stream: ref
                          .child(SessionController.session.userid.toString())
                          .onValue,
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return const Center(
                            child: Text('Error fetching data',
                                style: TextStyle(color: Colors.red)),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data.snapshot.value == null) {
                          return const Center(
                              child: Text('No data found',
                                  style: TextStyle(color: Colors.black)));
                        } else {
                          dynamic map = snapshot.data.snapshot.value;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                      fontSize: 25,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              InkWell(
                                onTap: () {
                                  provider.updateUserName(
                                      context, map['name'] ?? 'No Name');
                                },
                                child: ProfileDataBox(
                                  title: 'Username',
                                  value: map['name'] ?? 'No Name',
                                  iconData: Icons.person_2_outlined,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  provider.updateEmail(
                                      context, map['email'] ?? 'No Email');
                                },
                                child: ProfileDataBox(
                                  title: 'Email',
                                  value: map['email'] ?? 'No Email',
                                  iconData: Icons.email_outlined,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  provider.updatePhone(
                                      context, map['phone'] ?? 'No Phone');
                                },
                                child: ProfileDataBox(
                                  title: 'Phone no',
                                  value: map['phone'] ?? 'No Phone',
                                  iconData: Icons.phone,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  provider.updateEducation(context,
                                      map['education'] ?? 'No Education');
                                },
                                child: ProfileDataBox(
                                  title: 'Education',
                                  value: map['education'] ?? 'No Education',
                                  iconData: Icons.school_outlined,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  provider.updateCity(
                                      context, map['city'] ?? 'No City');
                                },
                                child: ProfileDataBox(
                                  title: 'City',
                                  value: map['city'] ?? 'No City',
                                  iconData: Icons.location_city_outlined,
                                ),
                              ),
                              const SizedBox(height: 24),
                              const SizedBox(
                                width: 90,
                                child: Divider(
                                  color: Mycolors.primary_cyan,
                                  thickness: 5,
                                ),
                              ),
                            ],
                          );
                        }
                      },
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
}

class ProfileDataBox extends StatelessWidget {
  final String title, value;
  final IconData iconData;

  const ProfileDataBox({
    super.key,
    required this.title,
    required this.value,
    required this.iconData,
  });

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
