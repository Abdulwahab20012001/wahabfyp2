import 'dart:typed_data';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fyp/Auth_services/googlservice.dart';
import 'package:fyp/custom_widgets/Textformfield.dart';
import 'package:fyp/custom_widgets/container.dart';
import 'package:fyp/screens/Teacher_Screens/register&login_screens/teacher_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp/screens/Teacher_Screens/teacher_homescreen.dart';
import 'package:fyp/utils/app_assets.dart';
import 'package:fyp/utils/app_colors.dart';
import 'package:fyp/view_model/controllers/Student_controllers/ssignup_controller.dart';
import 'package:fyp/view_model/controllers/Teacher_controllers/tsignup_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Studentregister extends StatefulWidget {
  const Studentregister({super.key});

  @override
  State<Studentregister> createState() => _StudentregisterState();
}

class _StudentregisterState extends State<Studentregister> {
  final formkey = GlobalKey<FormState>();
  final namecontroler = TextEditingController();
  final emailcontroler = TextEditingController();
  final passwordcontroler = TextEditingController();
  final phonecontroler = TextEditingController();
  final educationcontroler = TextEditingController();
  final citycontroler = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref().child('student');

  @override
  Widget build(BuildContext context) {
    google g = google();
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 243, 240, 240),
        body: Column(children: [
          mycontainer(
            height: 90,
            width: 450,
            borderRadius: 20,
            color: Mycolors.primary_cyan,
            child: Center(
              child: Text(
                'Student Register',
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Mycolors.Text_white),
              ),
            ),
          ),
          const SizedBox(height: 50),
          ChangeNotifierProvider(
            create: (_) => SSignUpController(),
            child: Consumer<SSignUpController>(
                builder: (context, Provider, child) {
              return Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Form(
                        key: formkey,
                        child: Column(children: [
                          TextFormField(
                            controller: namecontroler,
                            style: const TextStyle(
                              color: Colors.black,
                              height: 0.80,
                            ),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.person,
                                size: 28,
                                color: Colors.grey,
                              ),
                              fillColor: Colors.white,
                              hintText: 'Enter Name',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      Divider.createBorderSide(context)),
                              filled: true,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter Name';
                              }
                              return null;
                            },
                            obscureText: false,
                          ),
                          /* myfield(
                            controller: namecontroler,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              suffixIcon: Icon(
                                Icons.man_rounded,
                                size: 28,
                                color: Colors.grey,
                              ),
                              prefixIcon: Icon(
                                Icons.man_2,
                                size: 34,
                                color: Colors.grey,
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter name';
                              }
                              return null;
                            },
                            obscureText: false,
                            hintText: 'Enter Name',
                          ),*/
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: emailcontroler,
                            style: const TextStyle(
                              color: Colors.black,
                              height: 0.80,
                            ),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.email,
                                size: 28,
                                color: Colors.grey,
                              ),
                              fillColor: Colors.white,
                              hintText: ' Enter Email',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      Divider.createBorderSide(context)),
                              filled: true,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter email';
                              }
                              return null;
                            },
                            obscureText: false,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: passwordcontroler,
                            style: const TextStyle(
                                height: 0.80, color: Colors.black),
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.password,
                                size: 28,
                                color: Colors.grey,
                              ),
                              fillColor: Colors.white,
                              hintText: 'Enter password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              filled: true,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return ' Please Enter password';
                              }
                              return null;
                            },
                            obscureText: true,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: phonecontroler,
                            style: const TextStyle(
                              color: Colors.black,
                              height: 0.80,
                            ),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.phone,
                                size: 28,
                                color: Colors.grey,
                              ),
                              fillColor: Colors.white,
                              hintText: ' Enter phone number',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      Divider.createBorderSide(context)),
                              filled: true,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter Phoneno';
                              }
                              return null;
                            },
                            obscureText: false,
                          ),
                          const SizedBox(
                            height: 15,
                          ),

                          TextFormField(
                            controller: educationcontroler,
                            style: const TextStyle(
                              color: Colors.black,
                              height: 0.80,
                            ),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.cast_for_education,
                                size: 28,
                                color: Colors.grey,
                              ),
                              fillColor: Colors.white,
                              hintText: 'Enter Education',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      Divider.createBorderSide(context)),
                              filled: true,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter Education';
                              }
                              return null;
                            },
                            obscureText: false,
                          ),
                          const SizedBox(
                            height: 15,
                          ),

                          TextFormField(
                            controller: citycontroler,
                            style: const TextStyle(
                              color: Colors.black,
                              height: 0.80,
                            ),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.location_city,
                                size: 28,
                                color: Colors.grey,
                              ),
                              fillColor: Colors.white,
                              hintText: ' Enter City',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      Divider.createBorderSide(context)),
                              filled: true,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter City';
                              }
                              return null;
                            },
                            obscureText: false,
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          InkWell(
                            onTap: () {
                              if (formkey.currentState!.validate()) {
                                Provider.Studentsignup(
                                  context,
                                  namecontroler.text,
                                  emailcontroler.text,
                                  passwordcontroler.text,
                                  phonecontroler.text,
                                  educationcontroler.text,
                                  citycontroler.text,
                                );
                              }
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20)),
                                color: Mycolors.primary_cyan,
                              ),
                              height: 50,
                              width: 200,
                              child: const Center(
                                  child: Text(
                                'Register',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Text(
                            'or',
                            style: TextStyle(color: Colors.black),
                          ),

                          // ignore: prefer_const_constructors
                          Row(
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              const SizedBox(
                                width: 50,
                              ),
                              const Text(
                                "Do you have an account?",
                                style: TextStyle(color: Mycolors.Text_black),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const teacherlogin())),
                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Mycolors.primary_cyan),
                                ),
                              )
                            ],
                          ),
                        ]),
                      )),
                ),
              );
            }),
          )
        ]));
  }
}
