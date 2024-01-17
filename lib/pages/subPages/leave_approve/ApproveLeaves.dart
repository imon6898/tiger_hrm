// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tiger_erp_hrm/LoginApiController/loginController.dart';

import '../../../Coustom_widget/coustom_text field.dart';
import 'Components/custom_edit_table.dart';
import '../../../test2.dart';

class ApproveLeavesPage extends StatefulWidget {

  final String userName;
  final String empCode;
  final String companyID;
  final String companyName;
  //final String token;
  const ApproveLeavesPage({super.key,
    required this.userName,
    required this.empCode,
    required this.companyID,
    required this.companyName,
    //required this.token,
  });

  @override
  State<ApproveLeavesPage> createState() => _ApproveLeavesPageState();
}

class _ApproveLeavesPageState extends State<ApproveLeavesPage> {
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




  void fetchDutiesEmployeeData(String empCode) async {
    empCode = empCode ?? 'defaultEmpCode';
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': BaseUrl.authorization,
    };

    var response = await http.get(
      Uri.parse(
          '${BaseUrl.baseUrl}/api/${v.v1}/GetEmployment/$empCode/${widget.companyID}'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        Map<String, dynamic> firstItem = data[0];
        setState(() {
          forwardToNameController.text = firstItem['empName'];
          forwardToDesignationController.text = firstItem['designation'];
          String applicationDate = firstItem['applicationDate'];
          String startDate = firstItem['startDate'];
          String endDate = firstItem['endDate'];

          DateTime? parsedApplicationDate = parseApiDate(applicationDate);
          DateTime? parsedStartDate = parseApiDate(startDate);
          DateTime? parsedEndDate = parseApiDate(endDate);
        });
      }
    } else {
      print('Failed to fetch employee data: ${response.reasonPhrase}');
    }
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
          'Leave Approval',
          textAlign: TextAlign.center,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10,),

            CustomTextField(
              controller: forwardToIDController,
              label: 'Forward To ID',
              disableOrEnable: true,
              hintText: 'Forward To ID',
              onChanged: (value){
                fetchDutiesEmployeeData(value);
              },
            ),

            CustomTextField(
              controller: forwardToNameController,
              label: 'Name',
              disableOrEnable: false,
              hintText: 'Name',
            ),
            CustomTextField(
              controller: forwardToDesignationController,
              label: 'Designation',
              disableOrEnable: false,
              hintText: 'Designation',

            ),

            CustomTextField(
              controller: remarkController,
              label: 'Remarks',
              disableOrEnable: true,
              hintText: 'Remarks',

            ),







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
                    child: CustomTable(
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
