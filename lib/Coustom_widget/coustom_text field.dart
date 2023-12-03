import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    this.controller,
    required this.label,
    required this.hintText,
    required this.disableOrEnable,
    this.textFieldHeight,
    this.prefixIcon,
    this.onTap,
    this.onChanged,
    this.filled = false,
  }) : super(key: key);

  final TextEditingController? controller; // Add TextEditingController
  final String label;
  final String hintText;
  final bool disableOrEnable;
  final bool filled;
  final double? textFieldHeight;
  final Icon? prefixIcon;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged; // Use ValueChanged<String>

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Readex Pro',
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
            Container(
              height: 50,
              child: GestureDetector(
                onTap: onTap,
                child: TextField(
                  textAlign: TextAlign.start,
                  controller: controller,
                  onChanged: onChanged, // Use onChanged here
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(width: 2, color: Color(0xFFBCC2C2)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(width: 2, color: Color(0xFFBCC2C2)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(width: 2, color: Color(0xFFBCC2C2)),
                    ),
                    enabled: disableOrEnable,
                    filled: filled,
                    fillColor: Color(0xfff6f3f3),
                    hintText: hintText,
                    prefixIcon: prefixIcon,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
