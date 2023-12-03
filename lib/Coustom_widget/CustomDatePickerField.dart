import 'package:flutter/material.dart';

class CustomDatePickerField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final bool disableOrEnable;
  final int borderColor;
  final bool filled;
  final VoidCallback? onTap; // Make onTap optional

  CustomDatePickerField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    required this.disableOrEnable,
    required this.borderColor,
    required this.filled,
    this.onTap, // Make onTap optional by adding a '?' here
  }) : super(key: key);

  @override
  _CustomDatePickerFieldState createState() => _CustomDatePickerFieldState();
}

class _CustomDatePickerFieldState extends State<CustomDatePickerField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(30, 0, 30, 10),
      child: TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          suffixIcon: Padding(
            padding: EdgeInsets.all(0.0),
            child: Icon(
              Icons.calendar_month_outlined,
              color: Colors.grey,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Color(0xFFBCC2C2)),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Color(widget.borderColor)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.blueAccent),
          ),
          enabled: widget.disableOrEnable,
          filled: widget.filled,
          hintText: widget.hintText,
          labelText: widget.labelText,
          fillColor: Color(0xffececec),
        ),
        style: TextStyle(color: Colors.black),
        maxLines: 1,
        minLines: 1,
        readOnly: true, // Prevent manual text input
        onTap: widget.onTap, // Use the onTap property directly
      ),
    );
  }
}
