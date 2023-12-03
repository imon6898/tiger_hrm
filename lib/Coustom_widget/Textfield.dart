import 'package:flutter/material.dart';

class CustomTextFields extends StatelessWidget {
  const CustomTextFields({
    super.key,
    this.controller,
    this.initialValue,
    required this.hintText,
    required this.disableOrEnable,
    required this.labelText,
    required this.borderColor,
    required this.filled,

  });

  final controller;
  final initialValue;
  final String hintText;
  final String labelText;


  final bool disableOrEnable;
  final int borderColor;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(30, 0, 30, 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical:10,horizontal: 20),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Color(0xFFBCC2C2)),
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
          label: Text(labelText),
          fillColor: Color(0xffececec),
        ),
        style: TextStyle(color: Colors.black), // Set text color to black
        maxLines: 1000,
        minLines: 1,
      ),
    );
  }
}
