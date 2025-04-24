import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
 final String label;
  final Color color;
  final Color borderColor; // معامل اختياري
  final Color labelColor;
  void Function() onPressed; // معامل اختياري

   CustomButton({
    super.key,
    required this.label,
    required this.color,
   required this.borderColor, // معامل اختياري
   required this.labelColor, 
   required this.onPressed,// معامل اختياري
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color:borderColor),
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
