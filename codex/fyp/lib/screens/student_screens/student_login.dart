// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:fyp/Auth_services/googlservice.dart';
import 'package:fyp/custom_widgets/container.dart';
import 'package:fyp/screens/Teacher_Screens/teacher_homescreen.dart';
import 'package:fyp/screens/Teacher_Screens/register&login_screens/teacher_fgpass.dart';
import 'package:fyp/screens/Teacher_Screens/register&login_screens/teacher_register.dart';
import 'package:fyp/screens/student_screens/student_register.dart';
import 'package:fyp/utils/app_assets.dart';
import 'package:fyp/utils/app_colors.dart';
import 'package:fyp/view_model/controllers/Student_controllers/slogin_controller.dart';
import 'package:fyp/view_model/controllers/Teacher_controllers/tlogin_controllers.dart';
import 'package:provider/provider.dart';

class Studentlogin extends StatefulWidget {
  const Studentlogin({super.key});

  @override
  State<Studentlogin> createState() => _StudentloginState();
}

// ignore: camel_case_types
class _StudentloginState extends State<Studentlogin> {
  final formkey = GlobalKey<FormState>();
  final emailcontroler = TextEditingController();
  final passwordcontroler = TextEditingController();
  google g = google();
  @override
  Widget build(BuildContext context) {
    return Material(
        color: const Color.fromARGB(255, 243, 240, 240),
        child: Column(children: [
          const mycontainer(
            height: 90,
            width: 450,
            borderRadius: 20,
            color: Mycolors.primary_cyan,
            child: Center(
              child: Text(
                'Student Login',
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Mycolors.Text_white),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Form(
                      key: formkey,
                      child: Column(children: [
                        const SizedBox(
                          height: 100,
                        ),
                        const Text(
                          'Welcome to App',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Mycolors.Text_black,
                              fontSize: 32),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          'Enter your email address\n to connect your account ',
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Mycolors.Text_black,
                              fontSize: 16),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        TextFormField(
                          style: const TextStyle(color: Mycolors.Text_black),
                          controller: emailcontroler,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            // fillColor: Color.fromARGB(255, 212, 195, 195),
                            hintText: 'Enter Email',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: Divider.createBorderSide(context)),
                            filled: true,
                          ),
                          obscureText: false,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          style: const TextStyle(color: Mycolors.Text_black),
                          controller: passwordcontroler,
                          decoration: InputDecoration(
                            fillColor: Mycolors.Text_white,
                            hintText: 'Enter password',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: Divider.createBorderSide(context)),
                            filled: true,
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 185.0),
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ForgetPasswordScreen())),
                            child: const Text(
                              'Forget Password',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Mycolors.Text_black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        ChangeNotifierProvider(
                            create: (_) => LLoginController(),
                            child: Consumer<LLoginController>(
                                builder: (context, Provider, child) {
                              return InkWell(
                                onTap: () {
                                  if (formkey.currentState!.validate()) {
                                    Provider.studentLogin(
                                        context,
                                        emailcontroler.text,
                                        passwordcontroler.text);
                                  }
                                },
                                child: const mycontainer(
                                  borderRadius: 20,
                                  color: Mycolors.primary_cyan,
                                  height: 50,
                                  width: 200,
                                  child: Center(
                                      child: Text(
                                    'Login',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                                ),
                              );
                            })),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            const SizedBox(
                              width: 50,
                            ),
                            const Text(
                              "Do you want an account?",
                              style: TextStyle(color: Colors.black),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const Studentregister())),
                              child: const Text(
                                "Signup",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Mycolors.primary_cyan),
                              ),
                            )
                          ],
                        ),
                      ]),
                    ))),
          )
        ]));
  }
}
