import 'package:flutter/material.dart';
import 'package:fyp/custom_widgets/Textformfield.dart';
import 'package:fyp/custom_widgets/container.dart';
import 'package:fyp/view_model/controllers/fgpass_controller.dart';
import 'package:provider/provider.dart';
import '../../../utils/app_colors.dart';

class ForgetPasswordScreen extends StatefulWidget {
  ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final emailcontroler = TextEditingController();
  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
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
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(
          height: 60,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  child: Form(
                    key: formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'Forget Password?',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                              color: Mycolors.Text_black),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          'Please enter a email associated.',
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                              color: Mycolors.secondary_grey),
                        ),
                        const Text(
                          'We will send you reset instruction',
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 15,
                              color: Mycolors.secondary_grey),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        myfield(
                          controller: emailcontroler,
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
                              return 'Enter Email';
                            }
                            return null;
                          },
                          obscureText: false,
                          hintText: 'Enter Email',
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ChangeNotifierProvider(
                            create: (_) => ForgetpasswordController(),
                            child: Consumer<ForgetpasswordController>(
                                builder: (context, Provider, child) {
                              return InkWell(
                                onTap: () {
                                  if (formkey.currentState!.validate()) {
                                    Provider.Forgetpassword(
                                      context,
                                      emailcontroler.text,
                                    );
                                  }
                                },
                                child: mycontainer(
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
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
      ]),
    );
  }
}
