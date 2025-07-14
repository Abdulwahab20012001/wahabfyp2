import 'package:flutter/material.dart';

class screen1 extends StatelessWidget {
  const screen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 120,
        ),
        Image.asset(
          "assets/onboarding1.png",
          height: 300,
          width: 300,
        ),
        Text(
          "Buy Courses",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w600, fontSize: 25),
        ),
        const Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            "We can easily buy courses as a student using this user_friendly e_learning app.\nUnlock your potential and enhance your skills by accessing quality educational content anytime, anywhere.",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w200, fontSize: 16),
          ),
        )
      ],
    );
  }
}
