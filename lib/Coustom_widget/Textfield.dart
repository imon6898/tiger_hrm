import 'package:flutter/material.dart';

class CustomTextFields extends StatelessWidget {
  const CustomTextFields({
    Key? key,
    this.controller,
    this.initialValue,
    required this.hintText,
    required this.disableOrEnable,
    required this.labelText,
    required this.borderColor,
    required this.filled,
    this.onChanged,
    this.suffixIcon, // Added suffixIcon property
  });

  final controller;
  final initialValue;
  final String hintText;
  final String labelText;
  final bool disableOrEnable;
  final int borderColor;
  final bool filled;
  final void Function(String)? onChanged;
  final Widget? suffixIcon; // Added suffixIcon property

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(30, 0, 30, 10),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: const Color(0xFFBCC2C2)),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Color(borderColor)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.blueAccent),
          ),
          enabled: disableOrEnable,
          filled: filled,
          hintText: hintText,
          labelText: labelText,
          fillColor: const Color(0xffececec),
          suffixIcon: suffixIcon, // Set the suffixIcon
        ),
        style: const TextStyle(color: Colors.black),
        maxLines: 1000,
        minLines: 1,
      ),
    );
  }
}
