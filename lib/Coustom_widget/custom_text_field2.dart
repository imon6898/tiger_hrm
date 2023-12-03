import 'package:flutter/material.dart';

class CustomTextField2 extends StatelessWidget {
  const CustomTextField2({super.key, this.controller, required this.hintText, required this.label, required this.disableOrEnable, required this.labelText, required this.borderColor, required this.filled});

  final controller;
  final String hintText;
  final String labelText;
  final String label;
  final bool disableOrEnable;
  final int borderColor;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(30, 10, 20, 5),
            child: Text(
              label,
              style: TextStyle(
                  fontFamily: 'Readex Pro',
                  fontWeight: FontWeight.w500,
                  fontSize: 20),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(30, 0, 30, 10),
          child: TextField(
            controller: controller,
            maxLines: 1000, // <-- SEE HERE
            minLines: 1,
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(

                    borderSide:
                    BorderSide(width: 2, color: Color(0xFFBCC2C2))),
                disabledBorder: OutlineInputBorder(

                    borderSide:
                    BorderSide(width: 2, color: Color(borderColor))),
                focusedBorder: OutlineInputBorder(

                    borderSide:
                    BorderSide(width: 2, color: Colors.blueAccent)),
                enabled: disableOrEnable,
                filled: filled,

                hintText: hintText,
                label: Text(labelText),
                fillColor: Color(0xffececec)),
          ),
        ),

      ],
    );
  }
}