// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiger_erp_hrm/Coustom_widget/coustom_text%20field.dart';
import 'package:tiger_erp_hrm/LoginApiController/loginController.dart';
import 'package:tiger_erp_hrm/pages/subPages/apply_attendence/subScreen/FirstScreen.dart';
import 'package:tiger_erp_hrm/pages/subPages/apply_attendence/subScreen/SecondScreen.dart';
import 'package:http/http.dart' as http;


class AttendancePage extends StatefulWidget {
  final String empCode;
  final String companyID;
  final String companyName;
  final String userName;
  const AttendancePage(
      {
        super.key,
        required this.empCode,
        required this.companyID,
        required this.companyName,
        required this.userName
      });

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {


  TextEditingController employeeIdController = TextEditingController();
  TextEditingController officeBranchController = TextEditingController();
  TextEditingController departmentController = TextEditingController();


  void fetchEmployeeData() async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic SFJEb3ROZXRBcHA6aHJAMTIzNA==',
    };

    var response = await http.get(
      Uri.parse(
          '${BaseUrl.baseUrl}/api/v1/GetEmployment/${widget.empCode}/${widget.companyID}'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        // Assuming you want the first item from the list
        Map<String, dynamic> firstItem = data[0];
        setState(() {
          employeeIdController.text = firstItem['empCode'];
          officeBranchController.text = firstItem['empName'];
          // designationController.text = firstItem['designation'];
          departmentController.text = firstItem['department'];
          //
          // applyToEmployeeIdController.text = firstItem['reportTo'];
          // applyToEmployeeNameController.text = firstItem['reportToEmpName'];
          // applyToEmployeedesignationController.text = firstItem['reportToDesignation'];
        });
      }
    } else {
      print('Failed to fetch employee data: ${response.reasonPhrase}');
    }
  }


  @override
  void initState() {
    super.initState();
    fetchEmployeeData();

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff162b4a),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_rounded),
        ),
        title: const Text(
          style:
          TextStyle(color: Colors.white, fontSize: 30, fontFamily: 'Kanit'),
          'Apply Attendance',
          textAlign: TextAlign.center,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Divider(
                    thickness: 1.5,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Employee Information',style: TextStyle(fontSize: 16)),
                ),
                Expanded(
                  child: Divider(
                    thickness: 1.5,
                  ),
                ),
              ],
            ),
            Column(
              children: [

                CustomTextField(
                  controller: employeeIdController,
                  label: 'Employee ID',
                  disableOrEnable: false,
                  hintText: '',

                )
              ],
            ),
            CustomTextField(
              controller: officeBranchController,
              label: 'Office Branch',
              disableOrEnable: false,
              hintText: '',

            ),
            CustomTextField(
              controller: departmentController,
              label: 'Department',
              disableOrEnable: false,
              hintText: '',

            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 5),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: Size(44, 40),

                        shape: StadiumBorder()// Background color
                    ),
                    child: Row(children: [
                      Padding(
                        padding:
                        const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                        child: Icon(Icons.supervised_user_circle_rounded),
                      ),
                      Text(
                        'Show Employee',
                        style: TextStyle(fontSize: 20),
                      )
                    ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(5, 0, 5, 5),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        minimumSize: Size(34, 40),

                        shape: StadiumBorder()// Background color
                    ),
                    child: Row(children: [
                      Padding(
                        padding:
                        const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                        child: Icon(Icons.restart_alt),
                      ),
                      Text(
                        'Reset',
                        style: TextStyle(fontSize: 20),
                      )
                    ]),
                  ),
                ),

              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan,
                        minimumSize: Size(34, 40),
                        shape: StadiumBorder()// Background color
                    ),
                    child: Row(children: [
                      Padding(
                        padding:
                        const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                        child: Icon(CupertinoIcons.profile_circled),
                      ),
                      Text(
                        'Show Attendance Data',
                        style: TextStyle(fontSize: 20),
                      )
                    ]),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
                height: 420,
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  //color: Colors.yellow,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: DefaultTabController(
                  length: 2, // Number of tabs (screens)
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Tab Bar
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xff162b4a),
                          //color: Colors.red,
                        ),
                        constraints: const BoxConstraints.expand(height: 50),
                        child: TabBar(
                          labelPadding: EdgeInsets.zero,
                          //indicatorPadding: EdgeInsets.zero,
                          onTap: (index) {
                            setState(() {
                            });
                          },
                          tabs: [
                            // Tab for FirstScreen
                            Container(
                              constraints: const BoxConstraints.expand(height: 50,width: double.infinity),
                              child: const Tab(
                                child: Text("Arrive Time"),
                              ),
                            ),
                            // Tab for SecondScreen
                            Container(
                              constraints: const BoxConstraints.expand(height: 50,width: double.infinity),
                              child: const Tab(
                                child: Text("Leave Time"),
                              ),
                            ),
                          ],
                          indicator: BoxDecoration(
                            color: const Color(0xff162b4a),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.white, // Border color
                              width: 4.0,           // Border width
                            ),
                          ),
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.white,
                        ),
                      ),

                      // Tab Views
                       Expanded(
                        child: TabBarView(
                          //physics: NeverScrollableScrollPhysics(), // Disable swipe to change tabs
                          children: [
                            ArriveOfficeTime(), // FirstScreen content
                            LeaveOfficeTime(), // SecondScreen content
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                ),
          ],
        ),
      ),
    );
  }
}
