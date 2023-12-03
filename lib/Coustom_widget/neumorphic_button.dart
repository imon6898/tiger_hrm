import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

class NeumorphicButton extends StatefulWidget {
  final String imagePath;
  final String buttonText;
  final Function onTap;

  NeumorphicButton({
    Key? key,
    required this.imagePath,
    required this.buttonText,
    required this.onTap,
  }) : super(key: key);

  @override
  _NeumorphicButtonState createState() => _NeumorphicButtonState();
}

class _NeumorphicButtonState extends State<NeumorphicButton> {
  bool isPressed = true;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = const Color(0xFFFFFFFF);
    Offset distance = isPressed ? Offset(10, 10) : Offset(10, 10);
    double blur = isPressed ? 5.0 : 10.0;

    return GestureDetector(
      onTap: () {
        widget.onTap(); // Execute the provided onTap function
        setState(() => isPressed = !isPressed);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 20),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              blurRadius: 20.0,
              offset: distance,
              color: Color(0xFFA7A9AF),
              inset: isPressed,
            ),
            BoxShadow(
              blurRadius: 20.0,
              offset: -distance,
              color: Color(0xFFFFFFFF),
              inset: isPressed,
            ),
          ],
        ),
        child: SizedBox(
          height: 100,
          width: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 60,
                width: 60,
                child: Image.asset(widget.imagePath),
              ),
              SizedBox(height: 8),
              Text(
                widget.buttonText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}