import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fyp/screens/Other_screens/started_screen.dart';
import 'package:fyp/utils/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 1),
      () {
        setState(() {
          _opacity = 1.0;
        });
      },
    );

    Timer(
      const Duration(seconds: 4),
      () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const startedscreen()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Mycolors.Text_white,
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(seconds: 3),
          child: const Image(
            image: AssetImage("assets/fyp_logo.png"),
            height: 500,
            width: 350,
          ),
        ),
      ),
    );
  }
}
