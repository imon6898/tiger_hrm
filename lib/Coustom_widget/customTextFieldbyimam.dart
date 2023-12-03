import 'package:flutter/material.dart';

class CustomTextFieldbyimam extends StatelessWidget {
  const CustomTextFieldbyimam({
    Key? key,
    this.controller,
    required this.hintText,
    required this.disableOrEnable,
    this.textFieldHeight,
    this.textFieldWidth,
    this.prefixIcon,
    this.onTap,
    this.onChanged,
    this.filled = false,
    this.labelText = '',
    this.suffixIcon,
  }) : super(key: key);

  final TextEditingController? controller;
  final String hintText;
  final String labelText;
  final bool disableOrEnable;
  final bool filled;
  final double? textFieldHeight;
  final double? textFieldWidth;
  final FloatingActionButton? prefixIcon;
  final FloatingActionButton? suffixIcon;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: textFieldHeight,
            width: textFieldWidth,
            child: TextField(
              textAlign: TextAlign.start,
              controller: controller,
              onChanged: onChanged,
              style: TextStyle(
                color: Color(0xff646464),
              ),
              decoration: InputDecoration(
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Color(0xFFBCC2C2)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Color(0xFFBCBEC2)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Color(0xFFBCC2C2)),
                ),
                enabled: disableOrEnable,
                filled: filled,
                fillColor: Color(0xffececec),
                hintText: hintText,
                label: Text(labelText),
                prefixIcon: prefixIcon,
                suffixIcon: suffixIcon,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
