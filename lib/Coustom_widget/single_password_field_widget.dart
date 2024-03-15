import 'package:flutter/material.dart';

class SinglePasswordField extends StatefulWidget {
  final String hint;
  final String label;
  final String? Function(String?)? validator;
  final TextEditingController? controller; // Add controller parameter
  const SinglePasswordField({
    Key? key,
    required this.hint,
    required this.label,
    this.validator,
    this.controller, // Initialize controller parameter
  }) : super(key: key);

  @override
  State<SinglePasswordField> createState() => _SinglePasswordFieldState();
}

class _SinglePasswordFieldState extends State<SinglePasswordField> {
  late TextEditingController _textEditingController;
  bool _obscureText = true; // Add a state variable to track password visibility

  @override
  void initState() {
    super.initState();
    _textEditingController = widget.controller ?? TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _textEditingController,
      obscureText: _obscureText, // Use the state variable to toggle visibility
      validator: widget.validator,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        hintText: widget.hint,
        labelText: widget.label,
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        prefixIcon: Icon(Icons.lock),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText; // Toggle the visibility state
            });
          },
          icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off), // Change icon based on visibility state
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _textEditingController.dispose();
    }
    super.dispose();
  }
}

