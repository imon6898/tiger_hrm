import 'package:flutter/material.dart';

class SingleMobileField extends StatelessWidget {
  final String hint;
  final String label;
  final String? Function(String?)? validator;
  final TextInputType textInputType;
  final TextEditingController controller;

  const SingleMobileField({
    Key? key,
    required this.hint,
    required this.label,
    this.validator,
    required this.textInputType,
    required this.controller, // Added controller parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller, // Assigning controller to TextFormField
      keyboardType: textInputType,
      decoration: InputDecoration(
        hintText: hint,
        labelText: label,
        prefixIcon: Icon(Icons.account_circle),
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
      validator: validator != null ? (value) => validator!(value) : null,
    );
  }
}
