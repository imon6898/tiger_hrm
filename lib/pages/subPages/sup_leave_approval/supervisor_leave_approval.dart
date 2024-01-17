// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tiger_erp_hrm/LoginApiController/loginController.dart';

import '../../../Coustom_widget/coustom_text field.dart';
import 'Components/custom_edit_table_sup.dart';
import '../../../test2.dart';

class SupApproveLeavesPage extends StatefulWidget {

  final String userName;
  final String empCode;
  final String companyID;
  final String companyName;
  //final String token;
  const SupApproveLeavesPage({super.key,
    required this.userName,
    required this.empCode,
    required this.companyID,
    required this.companyName,
    //required this.token,
  });

  @override
  State<SupApproveLeavesPage> createState() => _SupApproveLeavesPageState();
}

class _SupApproveLeavesPageState extends State<SupApproveLeavesPage> {
  TextEditingController forwardToIDController = TextEditingController();
  TextEditingController forwardToNameController = TextEditingController();
  TextEditingController forwardToDesignationController = TextEditingController();
  TextEditingController remarkController = TextEditingController();

  // Utility function to handle date conversion
  DateTime? parseApiDate(String dateString) {
    if (dateString == "0001-01-01T00:00:00") {
      return null; // Return null for the special case
    }
    return DateTime.parse(dateString);
  }






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
          'Supervisor By Leave Approv',
          textAlign: TextAlign.center,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: CustomTableSup(
                      //token: widget.token,
                      empCode: widget.empCode,
                      companyID: widget.companyID,
                    ),
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
