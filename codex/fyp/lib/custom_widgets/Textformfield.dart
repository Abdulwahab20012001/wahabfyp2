import 'package:flutter/material.dart';
import 'package:fyp/utils/app_colors.dart';

// ignore: must_be_immutable
class myfield extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  Widget? prefixIcon;
  Widget? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;

  myfield({
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    required this.validator,
    required this.obscureText,
    required this.keyboardType,
    this.onChanged,
    required InputDecoration decoration,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(
        color: Colors.black,
        height: 0.80,
      ),
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        fillColor: Mycolors.Text_white,
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: Divider.createBorderSide(context)),
        filled: true,
      ),
      validator: validator,
    );
  }
}
