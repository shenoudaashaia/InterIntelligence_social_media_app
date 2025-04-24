// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final Color color;
  final Color borderColor;
  final Color labelColor;
  void Function() onPressed;

  CustomButton({
    Key? key,
    required this.label,
    required this.color,
    required this.borderColor,
    required this.labelColor,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(25),
        color: color,
      ),

      width: double.infinity,
      child: TextButton(
        onPressed: onPressed,
        child: Text(label, style: TextStyle(color: labelColor)),
      ),
    );
  }
}
