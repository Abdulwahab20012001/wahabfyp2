import 'package:flutter/material.dart';

class screen2 extends StatelessWidget {
  const screen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 120,
        ),
        Image.asset(
          "assets/onboarding2.png",
          height: 300,
          width: 310,
        ),
        const Text(
          "Sell Courses",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w600, fontSize: 25),
        ),
        const Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            "We can easily sell courses as a teacher using this user_friendly e_learning app.\nEmpower others with your knowledge & earn income by sharing your expertise a \nwith learners worldwide",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w200, fontSize: 16),
          ),
        )
      ],
    );
  }
}
