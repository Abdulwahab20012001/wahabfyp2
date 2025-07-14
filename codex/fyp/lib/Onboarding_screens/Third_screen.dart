import 'package:flutter/material.dart';

class screen3 extends StatelessWidget {
  const screen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 120,
        ),
        Image.asset(
          "assets/onboarding3.png",
          height: 300,
          width: 300,
        ),
        Text(
          "Chatting Feature",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w600, fontSize: 25),
        ),
        const Padding(
          padding: EdgeInsets.all(19.0),
          child: Text(
            "StudyBuddy supports a chatting feature between student and tutor through gigs.\nEnhance learning experience through an instant communication & collaborations \nwith peers.",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w200, fontSize: 16),
          ),
        )
      ],
    );
  }
}
