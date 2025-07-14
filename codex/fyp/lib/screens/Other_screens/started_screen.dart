// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fyp/Onboarding_screens/PageView_screen.dart';
import 'package:fyp/custom_widgets/container.dart';

import 'package:fyp/utils/app_assets.dart';
import 'package:fyp/utils/app_colors.dart';

class startedscreen extends StatelessWidget {
  const startedscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(children: [
          Stack(
            children: [
              Container(
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width,
                  // color: Color.fromARGB(255, 18, 16, 43),
                  decoration: const BoxDecoration(
                    // borderRadius: BorderRadius.only(topLeft: Radius.circular(100)),
                    color: Mycolors.Text_white,
                  )),
              Container(
                // ignore: sort_child_properties_last
                child: Image(
                  image: AssetImage(MyAssets.started_pic),
                  height: 450,
                  width: 450,
                ),
                decoration: const BoxDecoration(
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(100)),
                  color: Mycolors.primary_cyan,
                ),
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                // color: Color.fromARGB(255, 18, 16, 43),
                decoration: const BoxDecoration(
                  //  BorderRadius.only(topLeft: Radius.circular(100)),
                  color: Mycolors.primary_cyan,
                )),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              // color: Color.fromARGB(255, 18, 16, 43),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(100)),
                color: Colors.white,
              ),

              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 80,
                    ),
                    Text(
                      'Lets Connect',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Mycolors.Text_black,
                          fontSize: 35),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'With each other!',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Mycolors.Text_black,
                          fontSize: 30),
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => pageview())),
                      child: mycontainer(
                        borderRadius: 20,
                        color: Mycolors.primary_cyan,
                        height: 50,
                        width: 200,
                        child: Center(
                            child: Text(
                          'Lets Started',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

/*
Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Column(
        children: [
          Container(
            child: Image(
              image: AssetImage('assets/e1.png'),
              height: 250,
              width: 250,
            ),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(80)),
              color: Colors.white,
            ),
            height: 380,
            width: 500,
          ),
          Container(
            height: 400,
            width: 500,
            // color: Color.fromARGB(255, 18, 16, 43),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(100)),
              color: Color.fromARGB(255, 18, 16, 43),
            ),
          )
        ],
      ),
    );
 */