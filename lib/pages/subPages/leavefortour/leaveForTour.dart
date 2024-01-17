import 'package:flutter/material.dart';

class LeaveforTour extends StatefulWidget {
  const LeaveforTour({super.key});

  @override
  State<LeaveforTour> createState() => _LeaveforTourState();
}

class _LeaveforTourState extends State<LeaveforTour> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe9f0fd),
      appBar: AppBar(
        backgroundColor: const Color(0xff162b4a),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white,),
        ),
        title: const Text(
          style:
          TextStyle(color: Colors.white, fontSize: 30, fontFamily: 'Kanit'),
          'Leave For Tour',
          textAlign: TextAlign.center,
        ),
      ),

      body: SingleChildScrollView(

      ),
    );
  }
}
