// Import necessary packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fyp/Auth_services/googlservice.dart';
import 'package:fyp/custom_widgets/container.dart';
import 'package:fyp/screens/Teacher_Screens/teacher_homescreen.dart';
import 'package:fyp/screens/Teacher_Screens/register&login_screens/teacher_fgpass.dart';
import 'package:fyp/screens/Teacher_Screens/register&login_screens/teacher_register.dart';
import 'package:fyp/utils/app_assets.dart';
import 'package:fyp/utils/app_colors.dart';
import 'package:fyp/view_model/controllers/Teacher_controllers/tlogin_controllers.dart';

class teacherlogin extends StatefulWidget {
  const teacherlogin({super.key});

  @override
  State<teacherlogin> createState() => _TeacherLoginState();
}

// Changed class name to follow Dart naming conventions
class _TeacherLoginState extends State<teacherlogin> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  google g = google();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginController(),
      child: Consumer<LoginController>(
        builder: (context, loginController, child) {
          return Material(
            color: const Color.fromARGB(255, 243, 240, 240),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const mycontainer(
                    height: 90,
                    width: double.infinity,
                    borderRadius: 20,
                    color: Mycolors.primary_cyan,
                    child: Center(
                      child: Text(
                        'Teacher Login',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Mycolors.Text_white),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 100),
                          const Text(
                            'Welcome to App',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Mycolors.Text_black,
                                fontSize: 32),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'Enter your email address\n to connect your account ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Mycolors.Text_black,
                                fontSize: 16),
                          ),
                          const SizedBox(height: 50),
                          TextFormField(
                            style: const TextStyle(color: Mycolors.Text_black),
                            controller: emailController,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              hintText: 'Enter Email',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      Divider.createBorderSide(context)),
                              filled: true,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              // Add more validation if needed
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            style: const TextStyle(color: Mycolors.Text_black),
                            controller: passwordController,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              hintText: 'Enter password',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      Divider.createBorderSide(context)),
                              filled: true,
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              // Add more validation if needed
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
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
                          const SizedBox(height: 40),
                          SizedBox(
                            width: 200,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: loginController.isLoading
                                  ? null
                                  : () {
                                      if (formKey.currentState!.validate()) {
                                        loginController.login(
                                            context,
                                            emailController.text.trim(),
                                            passwordController.text.trim());
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Mycolors.primary_cyan,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: loginController.isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      'Login',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Mycolors.Text_white,
                                          fontSize: 16),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const SizedBox(width: 50),
                              const Text(
                                "Do you want an account?",
                                style: TextStyle(color: Colors.black),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const TeacherRegister())),
                                child: const Text(
                                  "Signup",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Mycolors.primary_cyan),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
