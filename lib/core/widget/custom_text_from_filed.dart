import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextFromFiled extends StatelessWidget {
  String lable;
  TextEditingController? controller;
  bool obscureText;
  String? Function(String?)? validator;

  CustomTextFromFiled({super.key, required this.lable, this.controller, this.obscureText = false, this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        hintText: lable,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black26),
          borderRadius: BorderRadius.circular(15),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black26),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
