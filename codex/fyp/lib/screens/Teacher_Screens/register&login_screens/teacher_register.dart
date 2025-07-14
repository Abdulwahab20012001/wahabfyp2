import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fyp/custom_widgets/container.dart';
import 'package:fyp/utils/app_colors.dart';
import 'package:fyp/view_model/controllers/Teacher_controllers/tsignup_controller.dart';

class TeacherRegister extends StatefulWidget {
  const TeacherRegister({Key? key}) : super(key: key);

  @override
  State<TeacherRegister> createState() => _TeacherRegisterState();
}

class _TeacherRegisterState extends State<TeacherRegister> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final educationController = TextEditingController();
  final cityController = TextEditingController();
  final stripeIdController = TextEditingController();
  File? certificateImage;

  Future<void> pickCertificate() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        certificateImage = File(pickedImage.path);
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    educationController.dispose();
    cityController.dispose();
    stripeIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignUpController(),
      child: Consumer<SignUpController>(
        builder: (context, signUpController, child) {
          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 243, 240, 240),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const mycontainer(
                    height: 90,
                    width: double.infinity,
                    borderRadius: 20,
                    color: Mycolors.primary_cyan,
                    child: Center(
                      child: Text(
                        'Teacher Register',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Mycolors.Text_white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          const Text(
                            'Welcome to App',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Mycolors.Text_black,
                              fontSize: 32,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'Enter your personal information to register your account',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Mycolors.Text_black,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 25),
                          buildTextField(
                              nameController, Icons.person, 'Enter Name'),
                          const SizedBox(height: 15),
                          buildTextField(
                              emailController, Icons.email, 'Enter Email'),
                          const SizedBox(height: 15),
                          buildTextField(
                              passwordController, Icons.lock, 'Enter Password',
                              isPassword: true),
                          const SizedBox(height: 15),
                          buildTextField(phoneController, Icons.phone,
                              'Enter Phone Number'),
                          const SizedBox(height: 15),
                          buildTextField(educationController, Icons.school,
                              'Enter Education'),
                          const SizedBox(height: 15),
                          buildTextField(cityController, Icons.location_city,
                              'Enter City'),
                          const SizedBox(height: 15),
                          buildTextField(stripeIdController, Icons.payment,
                              'Enter Stripe ID'),
                          const SizedBox(height: 15),
                          GestureDetector(
                            onTap: pickCertificate,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: certificateImage == null
                                    ? Colors.grey[200]
                                    : Colors.green[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    certificateImage == null
                                        ? "Upload Certificate"
                                        : "Certificate Uploaded",
                                    style: TextStyle(
                                      color: certificateImage == null
                                          ? Colors.black54
                                          : Colors.green,
                                    ),
                                  ),
                                  const Icon(Icons.upload_file),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: 200,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: signUpController.isLoading
                                  ? null
                                  : () async {
                                      if (formKey.currentState!.validate()) {
                                        if (certificateImage == null) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    "Please upload your certificate!")),
                                          );
                                          return;
                                        }
                                        bool isSuccess =
                                            await signUpController.signup(
                                          context,
                                          nameController.text.trim(),
                                          emailController.text.trim(),
                                          passwordController.text.trim(),
                                          phoneController.text.trim(),
                                          educationController.text.trim(),
                                          cityController.text.trim(),
                                          stripeIdController.text.trim(),
                                          certificateImage!,
                                        );
                                        if (isSuccess) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    "Registration successful!")),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    "Registration failed. Please try again.")),
                                          );
                                        }
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Mycolors.primary_cyan,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: signUpController.isLoading
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
                                      'Register',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Mycolors.Text_white,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 20),
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

  Widget buildTextField(
      TextEditingController controller, IconData icon, String hintText,
      {bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Mycolors.Text_black),
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $hintText';
        }
        return null;
      },
    );
  }
}
