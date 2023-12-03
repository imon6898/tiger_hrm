import 'package:flutter/material.dart';

class CustomDropdownField extends StatefulWidget {
  final String hintText;
  final String labelText; // Add labelText property
  final List<String> items;
  final Function(String) onChanged;

  CustomDropdownField({
    Key? key,
    required this.hintText,
    required this.labelText, // Initialize labelText
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CustomDropdownFieldState createState() => _CustomDropdownFieldState();
}

class _CustomDropdownFieldState extends State<CustomDropdownField> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(30, 0, 30, 10),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Color(0xFFBCC2C2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.blueAccent),
          ),
          filled: true,
          hintText: widget.hintText,
          labelText: widget.labelText, // Set labelText
          fillColor: Color(0xffececec),
        ),
        items: widget.items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedValue = value;
            widget.onChanged(value!);
          });
        },
        style: TextStyle(color: Colors.black), // Set text color to black
      ),
    );
  }
}
