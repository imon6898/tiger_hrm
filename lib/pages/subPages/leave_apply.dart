// ignore_for_file: prefer_const_constructors, prefer_final_fields, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:tiger_erp_hrm/Coustom_widget/coustom_text%20field.dart';
import 'package:tiger_erp_hrm/LoginApiController/loginController.dart';
import 'package:tiger_erp_hrm/LoginApiController/loginModel.dart';
import 'package:tiger_erp_hrm/test2.dart';

import '../../Coustom_widget/neumorphic_button.dart';
import 'approve_attend.dart';




class LeaveApplyPage extends StatefulWidget {
  final String userName;
  final String empCode;
  final String companyID;
  final String companyName;
  //final String token;
  const LeaveApplyPage({Key? key,
    required this.userName,
    required this.empCode,
    required this.companyID,
    required this.companyName,
    //required this.token,
  }) : super(key: key);

  @override
  State<LeaveApplyPage> createState() => _LeaveApplyPageState();
}
List<String> options = ['Active', 'Inactive'];
class _LeaveApplyPageState extends State<LeaveApplyPage> {

  TextEditingController employeeIdController = TextEditingController();
  TextEditingController employeeNameController = TextEditingController();
  TextEditingController designationController = TextEditingController();
  TextEditingController departmentController = TextEditingController();

  TextEditingController _fromDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  TextEditingController updateLeaveDuration = TextEditingController();

  TextEditingController _applyDateController = TextEditingController();
  TextEditingController _reasonController = TextEditingController();
  TextEditingController _emergencyContactNoController = TextEditingController();
  TextEditingController _emergencyAddressController = TextEditingController();
  String currentOptions = 'Active'; // Default value
  DateTime? fromDate;
  DateTime? endDate;
  List<String> options = ['Active', 'Inactive'];
  List<Map<String, dynamic>>? leaveTypes;

  TextEditingController applyToEmployeeIdController = TextEditingController();
  TextEditingController applyToEmployeeNameController = TextEditingController();
  TextEditingController applyToEmployeedesignationController = TextEditingController();

  TextEditingController dutiesEmployeeIdController = TextEditingController();
  TextEditingController dutiesEmployeeNameController = TextEditingController();
  TextEditingController dutiesEmployeeDesignationController = TextEditingController();





  void fetchEmployeeData() async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': BaseUrl.authorization,
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
          employeeNameController.text = firstItem['empName'];
          designationController.text = firstItem['designation'];
          departmentController.text = firstItem['department'];

          applyToEmployeeIdController.text = firstItem['reportTo'];
          applyToEmployeeNameController.text = firstItem['reportToEmpName'];
          applyToEmployeedesignationController.text = firstItem['reportToDesignation'];
        });
      }
    } else {
      print('Failed to fetch employee data: ${response.reasonPhrase}');
    }
  }

  Future<void> submitLeaveApplication(int leaveTypeId) async {
    final uri = Uri.parse('${BaseUrl.baseUrl}/api/v1/leave/leave-apply');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic SFJEb3ROZXRBcHA6aHJAMTIzNA==',
    };

    final requestBody = {

      "id": 1,
      "empCode": employeeIdController.text,
      "startDate": _fromDateController.text,
      "endDate": _endDateController.text,
      "applicationDate": _applyDateController.text,
      "accepteDuration": int.parse(updateLeaveDuration.text),
      "leaveTypedID": leaveTypeId,
      "unAccepteDuration": 0,
      "referanceEmpcode": dutiesEmployeeIdController.text,
      "grandtype": "string",
      "yyyymmdd": _applyDateController.text,
      "withpay": currentOptions == 'Active' ? "1" : "0",
      "appType": "0",
      "companyID": widget.companyID,
      "applyTo": applyToEmployeeIdController.text,
      "reason": _reasonController.text,
      "emgContructNo": _emergencyContactNoController.text,
      "emgAddress": _emergencyAddressController.text,
      "userName": employeeNameController.text,
      "authorityEmpcode": "0"

      // "id": 0,
      // "empCode": "465",//employeeIdController.text,
      // "startDate": "2023-11-16T04:48:31.524Z",//_fromDateController.text,
      // "endDate": "2023-11-16T04:48:31.524Z",//_endDateController.text,
      // "applicationDate": "2023-11-16T04:48:31.524Z",//_applyDateController.text,
      // "accepteDuration": 1,//int.parse(updateLeaveDuration.text),
      // "leaveTypedID": 2,//leaveTypeId,
      // "unAccepteDuration": 0,
      // "referanceEmpcode": dutiesEmployeeIdController.text,
      // "yyyymmdd": _applyDateController.text,
      // "withpay": currentOptions == 'Active' ? "1" : "0",
      // "appType": "0",
      // "companyID": widget.companyID,
      // "applyTo": applyToEmployeeIdController.text,
      // "reason": _reasonController.text,
      // "emgContructNo": _emergencyContactNoController.text,
      // "emgAddress": _emergencyAddressController.text,
      // "userName": employeeNameController.text,
      // "authorityEmpcode": "0"
    };

    try {
      final response = await http.post(
        uri,
        headers: headers,
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Leave application submitted successfully.'),
            backgroundColor: Colors.green,
          ),
        );

        print(await response.body);
        // Handle the response data here
      } else {
        // Show a failure message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Leave application submission failed.'),
            backgroundColor: Colors.red,
          ),
        );

        print('Request failed with status: ${response.statusCode}');
        print(response.reasonPhrase);
        // Handle error accordingly
      }
    } catch (error) {
      // Show a failure message for any errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $error'),
          backgroundColor: Colors.red,
        ),
      );

      print('Error: $error');
      // Handle the error accordingly
    }
  }


  void fetchDutiesEmployeeData(String empCode) async {
    empCode = empCode ?? 'defaultEmpCode';
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic SFJEb3ROZXRBcHA6aHJAMTIzNA==',
    };

    var response = await http.get(
      Uri.parse(
          '${BaseUrl.baseUrl}/api/v1/GetEmployment/$empCode/${widget.companyID}'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        // Assuming you want the first item from the list
        Map<String, dynamic> firstItem = data[0];
        setState(() {
          dutiesEmployeeNameController.text = firstItem['empName'];
          dutiesEmployeeDesignationController.text = firstItem['designation'];
        });
      }
    } else {
      print('Failed to fetch employee data: ${response.reasonPhrase}');
    }
  }



  Future<void> _fromSelectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        fromDate = picked;
        _fromDateController.text = picked.toString().split(" ")[0];
        _updateLeaveDuration(); // Calculate and update Leave Duration
      });
    }
  }

  Future<void> _endSelectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        endDate = picked;
        _endDateController.text = picked.toString().split(" ")[0];
        _updateLeaveDuration(); // Calculate and update Leave Duration
      });
    }
  }

  void _updateLeaveDuration() {
    if (fromDate != null && endDate != null) {
      final duration = endDate!.difference(fromDate!).inDays;
      updateLeaveDuration.text = '$duration';
    } else {
      updateLeaveDuration.text = '';
    }
  }

  String? selectedLeaveType;
  bool isDropdownVisible = false;

  Future<void> fetchLeaveTypes() async {
    try {
      var url = '${BaseUrl.baseUrl}/api/v1/leave/get-leave-type/2/1';
      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Basic SFJEb3ROZXRBcHA6aHJAMTIzNA==',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          // Update the state with the fetched leave types
          leaveTypes = List<Map<String, dynamic>>.from(json.decode(response.body));
        });
      } else {
        // Handle API error
        print('API Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      // Handle exceptions
      print('Error: $e');
    }
  }
  @override
  void initState() {
    super.initState();
    fetchLeaveTypes();

    fetchEmployeeData();

    // Set _applyDateController to today's date when the page is loaded
    _applyDateController.text = DateTime.now().toString().split(" ")[0];

  }
  @override
  void dispose() {
    _reasonController.dispose(); // Dispose of the Reason controller when the widget is disposed
    super.dispose();
  }


  bool? isChecked = false;
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    return WillPopScope(
      onWillPop: () async {
        // Perform custom logic here if needed
        // Return true to allow the back button, or false to prevent it
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
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
            'Leave Apply',
            textAlign: TextAlign.center,
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
                color: Color(0xFFDBDDE1),
              child: Column(
               children: [
                  SizedBox(height: 10,),
                 CustomTextField(
                   controller: employeeIdController,
                   label: 'Employee ID',
                   disableOrEnable: false,
                   hintText: '',

                   ),

                   CustomTextField(
                     controller: employeeNameController,
                     label: 'Employee Name',
                     disableOrEnable: false,
                     hintText: '',

                   ),
                   CustomTextField(
                     controller: designationController,
                     label: 'Designation',
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
                   children: [
                     Expanded(
                       child: Divider(
                         thickness: 1.5,
                       ),
                     ),
                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Text('Apply To',style: TextStyle(fontSize: 16)),
                     ),
                     Expanded(
                       child: Divider(
                         thickness: 1.5,
                       ),
                     ),
                   ],
                 ),

                 CustomTextField(
                   controller: applyToEmployeeIdController,
                   label: 'Employee ID',
                   disableOrEnable: false,
                   hintText: '',

                 ),
                 CustomTextField(
                   controller: applyToEmployeeNameController,
                   label: 'Employee Name',
                   disableOrEnable: false,
                   hintText: '',

                 ),
                 CustomTextField(
                   controller: applyToEmployeedesignationController,
                   label: 'Employee Designation',
                   disableOrEnable: false,
                   hintText: '',

                 ),

                 Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 1.5,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Application',style: TextStyle(fontSize: 16)),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 1.5,
                      ),
                    ),
                  ],
                ),

                 Container(
                   margin: EdgeInsets.symmetric(horizontal: 10),
                   decoration: BoxDecoration(
                     color: Colors.white,
                     borderRadius: BorderRadius.circular(10),
                   ),
                   child: Padding(
                     padding: const EdgeInsets.all(10),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text(
                           '*Leave Type',
                           style: TextStyle(
                             fontFamily: 'Readex Pro',
                             fontWeight: FontWeight.w500,
                             fontSize: 20,
                           ),
                         ),
                         GestureDetector(
                           onTap: () {
                             setState(() {
                               isDropdownVisible = !isDropdownVisible;
                             });
                           },
                           child: Container(
                             height: 50,
                             decoration: BoxDecoration(
                               border: Border.all(width: 2, color: Color(0xFFBCC2C2)),
                               borderRadius: BorderRadius.circular(10),
                             ),
                             child: Row(
                               children: [
                                 Expanded(
                                   child: Padding(
                                     padding: const EdgeInsets.symmetric(horizontal: 12),
                                     child: selectedLeaveType != null
                                         ? Text(
                                       selectedLeaveType!,
                                       style: TextStyle(color: Colors.black),
                                     )
                                         : Text(
                                       'Select Leave Type',
                                       style: TextStyle(color: Colors.grey),
                                     ),
                                   ),
                                 ),
                                 Icon(isDropdownVisible ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                               ],
                             ),
                           ),
                         ),
                         if (isDropdownVisible)
                           Container(
                             height: 150, // Set the maximum height for the dropdown
                             decoration: BoxDecoration(
                               border: Border.all(width: 2, color: Color(0xFFBCC2C2)),
                               borderRadius: BorderRadius.circular(10),
                             ),
                             child: ListView.builder(
                               itemCount: leaveTypes?.length ?? 0,
                               itemBuilder: (BuildContext context, int index) {
                                 return ListTile(
                                   title: Text(leaveTypes![index]['typeName']),
                                   onTap: () {
                                     setState(() {
                                       selectedLeaveType = leaveTypes![index]['typeName'];
                                       isDropdownVisible = false;
                                     });
                                   },
                                 );
                               },
                             ),
                           ),
                       ],
                     ),
                   ),
                 ),
                 SizedBox(height: 10,),

                 CustomTextField(
                   controller: _fromDateController,
                   label: '*From Date',
                   disableOrEnable: false,
                   hintText: '${now.year}-${now.month}-${now.day}',
                   onTap: () {
                     _fromSelectDate();
                   },
                   prefixIcon: Icon(Icons.calendar_today),
                 ),

                 CustomTextField(
                   controller: _endDateController,
                   label: '*End Date',
                   disableOrEnable: false,
                   hintText: '${now.year}-${now.month}-${now.day}',
                   onTap: () {
                     _endSelectDate();
                   },
                   prefixIcon: Icon(Icons.calendar_today),
                 ),

                 CustomTextField(
                   label: 'Leave Duration',
                   disableOrEnable: false,
                   hintText: fromDate != null && endDate != null
                       ? '${endDate!.difference(fromDate!).inDays}'
                       : 'Leave Duration',
                 ),

                 CustomTextField(
                   controller: _applyDateController,
                   label: 'Apply Date',
                   disableOrEnable: false,
                   hintText: '${now.year}-${now.month}-${now.day}',
                   onTap: () {
                     setState(() {
                       _applyDateController.text =
                       DateTime.now().toString().split(" ")[0];
                     });
                   },
                   prefixIcon: Icon(Icons.calendar_today),
                 ),

                 CustomTextField(
                   controller: _reasonController,
                   label: 'Reason',
                   disableOrEnable: true,
                   hintText: 'Reason',
                 ),
                 CustomTextField(
                   controller: _emergencyContactNoController,
                   label: 'Emergency Contact No.',
                   disableOrEnable: true,
                   hintText: 'Emergency Contact',
                 ),

                 CustomTextField(
                   controller: _emergencyAddressController,
                   label: 'Address',
                   disableOrEnable: true,
                   hintText: 'Your Address',
                 ),


                 Container(
                   margin: EdgeInsets.symmetric(horizontal: 10),
                   decoration: BoxDecoration(
                     color: Colors.white,
                     borderRadius: BorderRadius.circular(10)
                   ),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       ListTile(
                         title: const Text('With Pay'),
                         leading: Radio(
                           value: 'Active',
                           groupValue: currentOptions,
                           onChanged: (value) {
                             setState(() {
                               currentOptions = value.toString();
                             });
                           },
                         ),
                       ),
                       ListTile(
                         title: const Text('Without Pay'),
                         leading: Radio(
                           value: 'Inactive',
                           groupValue: currentOptions,
                           onChanged: (value) {
                             setState(() {
                               currentOptions = value.toString();
                             });
                           },
                         ),
                       ),
                     ],
                   ),
                 ),




                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 1.5,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Duties will be performed by:',style: TextStyle(fontSize: 16)),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 1.5,
                      ),
                    ),
                  ],
                ),








                 CustomTextField(
                   controller: dutiesEmployeeIdController,
                   label: 'Duties Employee ID',
                   disableOrEnable: true,
                   hintText: 'Duties Employee ID',
                   onChanged: (value){
                     fetchDutiesEmployeeData(value);
                   },
                 ),

                 CustomTextField(
                   controller: dutiesEmployeeNameController,
                   label: 'Duties Employee Name',
                   disableOrEnable: false,
                   hintText: 'Duties Employee Name',
                 ),
                 CustomTextField(
                   controller: dutiesEmployeeDesignationController,
                   label: 'Duties Employee Designation',
                   disableOrEnable: false,
                   hintText: 'Duties Employee Designation',

                 ),



                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Padding(
                       padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 5),
                       child: ElevatedButton(
                         onPressed: () {
                           //submitLeaveApplication();
                           if (leaveTypes != null && leaveTypes!.isNotEmpty) {
                             int selectedLeaveTypeId = leaveTypes![0]['typeee'] as int; // Use 'as int' to specify the type
                             submitLeaveApplication(selectedLeaveTypeId);
                           } else {
                             // Handle the case where leaveTypes is null or empty
                           }
                         },
                         style: ElevatedButton.styleFrom(
                           backgroundColor: Colors.green,
                           shape: StadiumBorder(), // Background color
                         ),
                         child: Row(
                           children: [
                             Padding(
                               padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                               child: Icon(Icons.save_as_outlined, color: Colors.white,),
                             ),
                             Text(
                               'Apply',
                               style: TextStyle(fontSize: 20, color: Colors.white),
                             )
                           ],
                         ),
                       ),
                     ),
                     Padding(
                       padding: const EdgeInsetsDirectional.fromSTEB(5, 0, 5, 5),
                       child: ElevatedButton(
                         onPressed: () {
                           // Reset form
                           _fromDateController.clear();
                           _endDateController.clear();
                           updateLeaveDuration.clear();
                           _applyDateController.clear();
                           _applyDateController.clear();
                           _reasonController.clear();
                           _emergencyContactNoController.clear();
                           _emergencyAddressController.clear();
                           setState(() {
                             currentOptions = options[0]; // Reset to default value
                             fromDate = null;
                             endDate = null;
                           });


                           dutiesEmployeeIdController.clear();
                           dutiesEmployeeNameController.clear();
                           dutiesEmployeeDesignationController.clear();
                         },
                         style: ElevatedButton.styleFrom(
                           backgroundColor: Colors.blueAccent,
                           shape: StadiumBorder(), // Background color
                         ),
                         child: Row(
                           children: [
                             Padding(
                               padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                               child: Icon(Icons.restart_alt, color: Colors.white,),
                             ),
                             Text(
                               'Reset',
                               style: TextStyle(fontSize: 20, color: Colors.white),
                             )
                           ],
                         ),
                       ),
                     ),
                   ],
                 )
          ],
        ),
            )),
      ),
    );
  }

}


