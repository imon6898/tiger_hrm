
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:tiger_erp_hrm/Coustom_widget/CustomDatePickerField.dart';
import 'package:tiger_erp_hrm/Coustom_widget/Textfield.dart';
import 'package:tiger_erp_hrm/Coustom_widget/coustom_text%20field.dart';
import 'package:tiger_erp_hrm/Coustom_widget/custom_text_field2.dart';
import 'package:tiger_erp_hrm/LoginApiController/loginController.dart';
import 'package:tiger_erp_hrm/pages/subPages/leave_approve/Components/Model/model.dart';
import 'dart:convert';

import 'leave_approved_api_service/leaveApproved_apiService.dart';


int leaveId=0;
String selectedOption = '';


class CustomTable extends StatefulWidget {
  //final String token;

  final String empCode;
  final String companyID;

  CustomTable({//required this.token,
    required this.empCode, required this.companyID});

  @override
  _CustomTableState createState() => _CustomTableState();
}

class _CustomTableState extends State<CustomTable> {

  List<LeaveDatafor> leaveDataList = [];

  bool isFetchingData = true;
  String selectedOption = '1';
  List<String> options = ['1', '0'];


  // Utility function to handle date conversion
  DateTime? parseApiDate(String dateString) {
    if (dateString == "0001-01-01T00:00:00") {
      return null; // Return null for the special case
    }
    return DateTime.parse(dateString);
  }


  TextEditingController forwardToIDController = TextEditingController();
  TextEditingController forwardToNameController = TextEditingController();
  TextEditingController forwardToDesignationController = TextEditingController();
  TextEditingController remarkController = TextEditingController();

  TextEditingController employeeId = TextEditingController();
  TextEditingController employeeName = TextEditingController();
  TextEditingController applied = TextEditingController();
  TextEditingController accept = TextEditingController();



  TextEditingController fromDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController applyDateController = TextEditingController();
  TextEditingController applideDayController = TextEditingController();
  TextEditingController applideDayChangeController = TextEditingController();
  TextEditingController updateLeaveDuration = TextEditingController();

  TextEditingController editEmployeeId = TextEditingController();
  TextEditingController editEmployeeName = TextEditingController();
  TextEditingController editapplyDateController = TextEditingController();
  TextEditingController editfromDateController = TextEditingController();
  TextEditingController editendDateController = TextEditingController();
  TextEditingController editApplideDayController = TextEditingController();
  TextEditingController editApplideDayChangeController = TextEditingController();
  TextEditingController editLeaveTypeController = TextEditingController();




  DateTime? fromDate;
  DateTime? endDate;




  void fetchDutiesEmployeeData(String empCode) async {
    empCode = empCode ?? 'defaultEmpCode';
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': '${BaseUrl.authorization}',
    };

    var response = await http.get(
      Uri.parse(
          '${BaseUrl.baseUrl}/api/${v.v1}/GetEmployment/$empCode/${widget.companyID}'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        // Assuming you want the first item from the list
        Map<String, dynamic> firstItem = data[0];
        setState(() {
          forwardToNameController.text = firstItem['empName'];
          forwardToDesignationController.text = firstItem['designation'];
        });
      }
    } else {
      print('Failed to fetch employee data: ${response.reasonPhrase}');
    }
  }

  Future<void> fetchRecommendLeave(int leaveId, String remark, String statusDate) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': '${BaseUrl.authorization}',
    };

    var request = http.Request(
      'POST',
      Uri.parse('${BaseUrl.baseUrl}/api/${v.v1}/UpdateRecommand'),
    );

    request.body = json.encode({
      "id": leaveId,
      "reqFrom": widget.empCode,
      "reqTo": forwardToIDController.text,
      "companyID": widget.companyID,
      "remarks": remark,
      "type": 1,
      "status": 0,


      // "id": 0,
      // "leaveID": leaveId,
      // "reqFrom": widget.empCode,
      // "reqTo": forwardToIDController.text,
      // "statusDate": statusDate,  // Use the provided statusDate parameter
      // "status": 1,
      // "companyID": 1,
      // "remarks": remark,
      // "type": 2,
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());

      // Show a SnackBar to indicate success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Leave application Forward successfully.'),
          backgroundColor: Colors.green,
        ),
      );

      // Refresh the page by re-fetching the leave applications
      await fetchGetWaitingLeaveForApprove();
    } else {
      print(response.reasonPhrase);

      // Show an error SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to Forward leave application: ${response.reasonPhrase}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> fetchPendingToApproveLeave(int leaveId, String remark, String statusDate) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': '${BaseUrl.authorization}',
    };

    var request = http.Request(
      'POST',
      Uri.parse('${BaseUrl.baseUrl}/api/${v.v1}/UpdateRecommand'),
    );

    request.body = json.encode({

      "id": leaveId,
      "reqFrom": widget.empCode,
      "reqTo": forwardToIDController.text,
      "companyID": widget.companyID,
      "remarks": remark,
      "type": 2,
      "status": 0,


      // "id": 0,
      // "leaveID": leaveId,
      // "reqFrom": widget.empCode,
      // "reqTo": forwardToIDController.text,
      // "statusDate": statusDate,  // Use the provided statusDate parameter
      // "status": 1,
      // "companyID": 1,
      // "remarks": remark,
      // "type": 1,
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());

      // Show a SnackBar to indicate success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Leave application Forward successfully.'),
          backgroundColor: Colors.green,
        ),
      );

      // Refresh the page by re-fetching the leave applications
      await fetchGetWaitingLeaveForApprove();
    } else {
      print(response.reasonPhrase);

      // Show an error SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to Forward leave application: ${response.reasonPhrase}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> fetchCancelLeave(
      int leaveId,
      String remark,
      String statusDate,
      String empName,
      String empEmail,
      String startDate,
      String endDate,
      String typeName,
      String payType,
      String days,
      String reportToEmpName
      ) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': '${BaseUrl.authorization}',
    };

    var request = http.Request(
      'POST',
      Uri.parse('${BaseUrl.baseUrl}/api/${v.v1}/UpdateRecommand'),
    );

    print("request.body : ${json.encode}");
    request.body = json.encode({

      "id": leaveId,
      "reqFrom": widget.empCode,
      "reqTo": forwardToIDController.text,
      "companyID": widget.companyID,
      "remarks": remark,
      "type": 3,
      "status": 0,



      // "id": 0,
      // "leaveID": leaveId,
      // "reqFrom": widget.empCode,
      // "reqTo": "",
      // "statusDate": statusDate,  // Use the provided statusDate parameter
      // "status": 1,
      // "companyID": 1,
      // "remarks": remark,
      // "type": 3,
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());

      // Show a SnackBar to indicate success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Leave application successfully canceled.'),
          backgroundColor: Colors.green,
        ),
      );

      ApiLeaveApproveBadgeService.fetchGetWaitingLeaveForApprove(
        companyID: widget.companyID,
        empCode: widget.empCode,
      );

      // Refresh the page by re-fetching the leave applications
      await fetchGetWaitingLeaveForApprove();

      await sendEmailForCancelLeavefromSup(
        empName,
        empEmail,
        startDate,
        endDate,
        typeName,
        payType,
        days,
        reportToEmpName,
      );

    } else {
      print(response.reasonPhrase);

      // Show an error SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to cancel leave application: ${response.reasonPhrase}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  Future<void> sendEmailForCancelLeavefromSup(
      String empName,
      String empEmail,
      String startDate,
      String endDate,
      String typeName,
      String payType,
      String days,
      String reportToEmpName
      ) async {

    print('Employee Name: $empName');
    print('Employee Email: $empEmail');
    print('Start Date: $startDate');
    print('End Date: $endDate');
    print('Type Name: $typeName');
    print('Pay Type: $payType');
    print('Days: $days');
    print('Report To Employee Name: $reportToEmpName');


    var headers = {
      'Authorization': '${BaseUrl.authorization}',
    };
    var request = http.MultipartRequest('POST', Uri.parse('${BaseUrl.baseUrl}/api/Email/Send'));
    request.fields.addAll({
      'ToEmail': empEmail, // Use reportToEmail here
      'Subject': '$reportToEmpName Cancel Your $typeName Application',
      'Body': '''Dear $empName,
      
      \nI hope this message finds you well. Unfortunately, $reportToEmpName has decided to cancel your $typeName application that was scheduled from $startDate to $endDate, which was initially recommended for $days Days.

      \nWe apologize for any inconvenience this may cause. If you have any questions or concerns, please feel free to reach out to us.
      
      \nThank you for your understanding and support.
      
      \nBest regards,
      \nDS HRMS''',
    });
    // for (var attachment in attachments) {
    //   request.files.add(await http.MultipartFile.fromPath('Attachments', attachment.path));
    // }

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }



  Color getRowColor(int index) {
    if (index % 3 == 0) {
      return Colors.orange;  // Black
    } else if (index % 3 == 1) {
      return Colors.yellow; // Yellow
    } else {
      return Colors.cyanAccent;  // Green
    }
  }






  @override
  void initState() {
    super.initState();
    fetchGetWaitingLeaveForApprove();
    applyDateController.text = DateTime.now().toString().split(" ")[0];
  }

  Future<void> fetchGetWaitingLeaveForApprove() async {
    var headers = {
      'Authorization': '${BaseUrl.authorization}',
    };
    var request = http.Request(
      'GET',
      Uri.parse('${BaseUrl.baseUrl}/api/${v.v1}/leave/GetWaitingLeaveForApprove/${widget.companyID}/2023/${widget.empCode}'),
    );
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    setState(() {
      isFetchingData = true;
    });

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final List<dynamic> data = json.decode(responseBody);
      print("this is get Data from::${data}");

      setState(() {
        leaveDataList = data.asMap().entries.map((entry) {
          final index = entry.key + 1; // Calculate the serial number
          final item = entry.value;
          leaveId = item['id'];
          print("this is leave Type id:$leaveId");

          return LeaveDatafor(
            empCode: item['empCode'] ?? '',
            empName: item['empName'] ?? '',
            empEmail: item['empEmail'] ?? '',
            designation: item['designation'] ?? '',
            department: item['department'] ?? '',
            typeName: item['typeName'] ?? '',
            applyDate: item['laDate'] ?? '',
            startDate: item['lsDate'] ?? '',
            endDate: item['leDate'] ?? '',
            days: item['accepteDuration'].toString(),
            payType: item['withpay'] ?? '',
            id: item['id'] ?? 0,
            reason: item['reason'] ?? '',
            emgContructNo: (item['emgContructNo'] ?? '').toString(),
            leaveTypedID: item['leaveTypedID'] ?? 0,
            unAccepteDuration:  (item['unAccepteDuration'] ?? '').toString(),
            referanceEmpcode: item['referanceEmpcode'] ?? '',
            grandtype: item['grandtype'] ?? '',
            appType: item['appType'] ?? '',
            companyID: item['companyID'] ?? 0,
            applyTo: item['applyTo'] ?? '',
            emgAddress: item['emgAddress'] ?? '',
            userName: item['userName'] ?? '',
            authorityEmpcode: item['authorityEmpcode'] ?? '',
            yyyymmdd: item['yyyymmdd'] ?? '', // Add yyyymmdd assignment
            recommandToEmail: item['recommandToEmail'] ?? '',
            recommandedName: item['recommandedName'] ?? '',
            reportToEmail: item['reportToEmail'] ?? '',
            reportToEmpName: item['reportToEmpName'] ?? '',
          );
        }).toList();
        isFetchingData = false;
      });
    } else {
      isFetchingData = false;
      throw Exception('Failed to load data from the API');
    }
  }


  @override
  Widget build(BuildContext context) {
    if (isFetchingData) {
      // Show loading indicator while fetching data
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (leaveDataList.isEmpty) {
      // Show default message when no data is available
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 200,
        child: Center(
          child:
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Lottie.asset(
              'lib/images/nodata.json', // Replace with the path to your Lottie animation file
            ),
          ),
        ),
      );
    } else {
      // Show the table with fetched data
      return DataTable(
        dataTextStyle: const TextStyle(
          fontSize: 16,
          color: Colors.black, // Text color for data cells
        ),
        // Define the table border
        border: TableBorder.all(
          color: Colors.black, // Border color
          width: 2.0, // Border width
          style: BorderStyle.solid, // Border style
        ),
        columns: [
          const DataColumn(label: Text('#SN')),
          const DataColumn(label: Text('E.Code')),
          const DataColumn(label: Text('Name')),
          const DataColumn(label: Text('Department')),
          const DataColumn(label: Text('Designation')),
          const DataColumn(label: Text('Apply Date')),
          const DataColumn(label: Text('Start Date')),
          const DataColumn(label: Text('End Date')),
          const DataColumn(label: Text('LeaveType')),
          const DataColumn(label: Text('Day(s)')),
          const DataColumn(label: Text('PayType')),
          //const DataColumn(label: Text('Recommend')),
          const DataColumn(label: Text('Approve')),
          const DataColumn(label: Text('Cancel')),
          const DataColumn(label: Text('Edit')),
        ],
        rows: leaveDataList
            .map((data) {
          final int index = leaveDataList.indexOf(data);
          final Color rowColor = getRowColor(index);
          // Parse the dates using the utility function
          final DateTime? applicationDate = parseApiDate(data.applyDate.toString());
          final DateTime? startDate = parseApiDate(data.startDate.toString());
          final DateTime? endDate = parseApiDate(data.endDate.toString());

          // Create the data rows
          return DataRow(
              color: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                return rowColor; // Set the background color based on row index
              }),
              cells: [
                DataCell(Text((index + 1).toString())),
                DataCell(Text(data.empCode)),
                DataCell(Text(data.empName)),
                DataCell(Text(data.department)),
                DataCell(Text(data.designation.toString())),
                DataCell(Text(DateFormat("yyyy-MM-dd").format(DateTime.parse("${data.applyDate}")))),
                DataCell(Text(DateFormat("yyyy-MM-dd").format(DateTime.parse("${data.startDate}")))),
                DataCell(Text(DateFormat("yyyy-MM-dd").format(DateTime.parse("${data.endDate}")))),
                DataCell(Text(data.typeName.toString())),
                DataCell(Text(data.days.toString())),
                DataCell(Text(data.payType.toString())),
                /*DataCell(
                  ElevatedButton(
                    onPressed: () {
                      // Set the selectedLeaveId when the button is clicked
                      setState(() {
                        leaveId = data.id;
                      });

                      // Add your action for "Recommend to" here
                      Get.defaultDialog(
                        title: 'Recommend To',
                        titlePadding: const EdgeInsets.all(5),
                        contentPadding: const EdgeInsets.all(10),
                        content: SingleChildScrollView(
                          child: Column(
                            children: [
                              const Text('Are you sure want to recommend?'),
                              const SizedBox(height: 10),
                              TextField(
                                controller: forwardToIDController,
                                onChanged: (value) {
                                  fetchDutiesEmployeeData(value);
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Forward to ID',
                                  border: OutlineInputBorder(), // Add a border to the TextField
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                controller: forwardToNameController,
                                enabled: false,
                                decoration: const InputDecoration(
                                  labelText: 'Name',
                                  border: OutlineInputBorder(), // Add a border to the TextField
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                controller: forwardToDesignationController,
                                enabled: false,
                                decoration: const InputDecoration(
                                  labelText: 'Designation',
                                  border: OutlineInputBorder(), // Add a border to the TextField
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                controller: remarkController,
                                decoration: const InputDecoration(
                                  labelText: 'Remark',
                                  border: OutlineInputBorder(), // Add a border to the TextField
                                ),
                              ),
                            ],
                          ),
                        ),
                        confirm: ElevatedButton(
                          onPressed: () {
                            // Call the fetchRecommendLeave function with the selectedLeaveId
                            fetchRecommendLeave(
                                leaveId,
                                remarkController.text,
                                DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now().toUtc())
                            );
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                          ),
                          child: const Text(
                            'Confirm',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                        cancel: ElevatedButton(
                          onPressed: () {
                            // Handle cancel button
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                          ),
                          child: const Text(
                            'Not Now',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      );
                    },
                    child: const Text("Recommend to", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff1c4d75),
                    ),
                  ),
                ),*/
                DataCell(
                  ElevatedButton(
                    onPressed: () {
                      // Set the selectedLeaveId when the button is clicked
                      setState(() {
                        leaveId = data.id;
                      });

                      // Add your action for "Pending, Recommended" here
                      Get.defaultDialog(
                        title: 'Approved Application',
                        titlePadding: const EdgeInsets.all(5),
                        contentPadding: const EdgeInsets.all(10),
                        content: Column(
                          children: [
                            const Text('Are you sure you want to Approve?'),
                            const SizedBox(height: 10),
                            TextField(
                              enabled: false,
                              decoration: InputDecoration(
                                labelText: (data.empCode.toString()),
                                border: const OutlineInputBorder(), // Add a border to the TextField
                              ),
                            ),
                            const SizedBox(height: 10),
                            const TextField(
                              decoration: InputDecoration(
                                labelText: 'Comments',
                                border: OutlineInputBorder(), // Add a border to the TextField
                              ),
                            ),
                            const SizedBox(height: 10),
                            const TextField(
                              decoration: InputDecoration(
                                labelText: 'Remark',
                                border: OutlineInputBorder(), // Add a border to the TextField
                              ),
                            ),
                          ],
                        ),
                        confirm: ElevatedButton(
                          onPressed: () {
                            // Retrieve the text entered in the TextFields
                            // You can use the values from the TextFields as needed
                            String comments = 'Get the text from the "Comments" TextField here';
                            String remark = 'Get the text from the "Remark" TextField here';

                            // Process the data as needed
                            print('Comments: $comments');
                            print('Remark: $remark');

                            fetchPendingToApproveLeave(leaveId, remark, DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now().toUtc()));
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green, // Change the button color to green
                          ),
                          child: const Text(
                            'Confirm',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                        cancel: ElevatedButton(
                          onPressed: () {
                            // Handle cancel button
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red, // Change the button color to red
                          ),
                          child: const Text(
                            'Not Now',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      );
                    },
                    child: const Text("Pending", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                    ),
                  ),
                ),
                DataCell(
                  ElevatedButton(
                    onPressed: () {
                      // Set the selectedLeaveId when the button is clicked
                      setState(() {
                        leaveId = data.id;
                      });

                      Get.defaultDialog(
                        title: 'Cancel Application',
                        titlePadding: const EdgeInsets.all(5),
                        contentPadding: const EdgeInsets.all(10),
                        content: Column(
                          children: [
                            const Text('Are you sure you want to Cancel ?'),
                            const SizedBox(height: 10),
                            TextField(
                              controller: remarkController,
                              decoration: const InputDecoration(
                                labelText: 'Remark',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                        confirm: ElevatedButton(
                          onPressed: () {
                            // Retrieve the text entered in the TextField
                            String remark = remarkController.text;

                            // Format the status date
                            String statusDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now().toUtc());

                            // Process the data as needed
                            print('Remark: $remark');
                            print('LeaveId: $leaveId');

                            // Call the fetchCancelLeave function with the selectedLeaveId
                            fetchCancelLeave(leaveId, remark, statusDate,
                              data.empName,
                              data.empEmail,

                                DateFormat("yyyy-MM-dd").format(DateTime.parse("${data.startDate}")),
                                DateFormat("yyyy-MM-dd").format(DateTime.parse("${data.endDate}")),
                              data.typeName,
                              data.payType,
                              data.days,
                              data.reportToEmpName
                            );

                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text(
                            'Confirm',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                        cancel: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text(
                            'Not Now',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      );
                    },
                    child: const Text("Cancel", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
                DataCell(
                  ElevatedButton(
                    onPressed: () {
                      // Set the selectedLeaveId when the button is clicked
                      setState(() {
                        leaveId = data.id;
                      });

                      // Call the handleEditButton function with the selectedLeaveId
                      handleEditButton(data);

                    },
                    child: const Text("Edit", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                  ),
                ),


              ]
          );
        })
            .toList(),
      );
    }
  }
  void handleEditButton(selectedLeave) {
    editEmployeeName.text = selectedLeave.empName;
    editapplyDateController.text = DateFormat("yyyy-MM-dd").format(DateTime.parse(selectedLeave.applyDate));
    editfromDateController.text = DateFormat("yyyy-MM-dd").format(DateTime.parse(selectedLeave.startDate));
    editendDateController.text = DateFormat("yyyy-MM-dd").format(DateTime.parse(selectedLeave.endDate));
    editApplideDayController.text = selectedLeave.days;
    editApplideDayChangeController.text = selectedLeave.days;
    editLeaveTypeController.text = selectedLeave.typeName.toString();
    forwardToIDController.text = selectedLeave.applyTo.toString();


    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: BoxDecoration(
            color: const Color(0xBCE8E8FF),
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListView(
            children: [
              const SizedBox(height: 10),
              const Center(
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 1.5,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Edit Application",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              CustomTextFields(
                labelText: 'Employee Name',
                hintText: 'Employee Name',
                borderColor: 0xFFBCC2C2,
                filled: true,
                disableOrEnable: false,
                controller: editEmployeeName,
              ),
              CustomTextFields(
                labelText: 'Leave Type',
                hintText: 'Leave Type',
                borderColor:  0xFFBCC2C2,
                filled: true,
                disableOrEnable: false,
                controller: editLeaveTypeController,
              ),
              CustomDatePickerField(
                controller: editapplyDateController,
                hintText: 'Select a date',
                labelText: 'Apply Date',
                disableOrEnable: false,
                borderColor: 0xFFBCC2C2,
                filled: true,
              ),
              CustomDatePickerField(
                controller: editfromDateController,
                hintText: 'Select a date',
                labelText: 'From Date',
                disableOrEnable: true,
                borderColor: 0xFFBCC2C2,
                filled: true,
                onTap: () => fromSelectDate(),
              ),
              CustomDatePickerField(
                controller: editendDateController,
                hintText: 'Select a date',
                labelText: 'End Date',
                disableOrEnable: true,
                borderColor: 0xFFBCC2C2,
                filled: true,
                onTap: () => endSelectDate(),
              ),
              Column(
                children: [
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        'Duration',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  CustomTextFields(
                    labelText: 'Applied',
                    hintText: 'Applied',
                    borderColor: 0xFFBCC2C2,
                    filled: false,
                    disableOrEnable: false,
                    controller: editApplideDayController,
                  ),

                  CustomTextFields(
                    labelText: 'Accept',
                    hintText: 'Accept',
                    borderColor: 0xFFBCC2C2,
                    filled: false,
                    disableOrEnable: false,
                    controller: editApplideDayChangeController,
                    onChanged: (value) {
                      _updateLeaveDuration();
                      print('Text changed: $value');
                    },
                  ),
                ],
              ),


              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: RadioOptions(
                    selectedOption: selectedLeave.payType,
                    leaveId: selectedLeave.id,
                    onOptionChanged: (option) {
                      selectedOption = option;
                    },
                  ),
                ),
              ),



              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: CustomTextField(
                  controller: forwardToIDController,
                  label: 'Forward To ID',
                  disableOrEnable: true,
                  hintText: 'Forward To ID',
                  onChanged: (value) {
                    fetchDutiesEmployeeData(value);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: CustomTextField(
                  controller: forwardToNameController,
                  label: 'Forward To Name',
                  disableOrEnable: true,
                  hintText: 'Forward To Name',
                  onChanged: (value) {
                    fetchDutiesEmployeeData(value);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () {

                        fetchRecommendLeaveEdit(
                          selectedLeave,
                          forwardToIDController.text,
                        );
                        fetchUpdateLeaveApprove(
                          editEmployeeName.text,
                          editLeaveTypeController.text,
                          editapplyDateController.text,
                          editfromDateController.text,
                          editendDateController.text,
                          editApplideDayController.text,
                          editApplideDayChangeController.text,
                          selectedOption,
                          selectedLeave,
                          forwardToIDController.text,
                        );

                        Navigator.pop(context);
                      },
                      child: const Text('Confirm'),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> fromSelectDate() async {
    DateTime initialDatePickerDate = editfromDateController.text.isEmpty
        ? DateTime.now()
        : DateTime.parse(editfromDateController.text);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDatePickerDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        fromDate = picked;
        editfromDateController.text = picked.toString().split(" ")[0];
        _updateLeaveDuration(); // Calculate and update Leave Duration
      });
    }
  }

  Future<void> endSelectDate() async {
    DateTime initialDatePickerDate = editendDateController.text.isEmpty
        ? DateTime.now()
        : DateTime.parse(editendDateController.text);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDatePickerDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        endDate = picked;
        editendDateController.text = picked.toString().split(" ")[0];
        _updateLeaveDuration(); // Calculate and update Leave Duration

        // Check if fromDate is null, show snackbar if true
        if (fromDate == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Please select From Date first.'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
      });
    }
  }



  void _updateLeaveDuration() {
    if (fromDate != null && endDate != null) {
      final duration = endDate!.difference(fromDate!).inDays + 1;
      editApplideDayChangeController.text = '$duration';
    } else {
      editApplideDayChangeController.text = '';
    }
  }


  Future<void> fetchRecommendLeaveEdit(
      LeaveDatafor selectedLeave,
      String forwardToID,
      ) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': '${BaseUrl.authorization}',
    };

    var request = http.Request(
      'POST',
      Uri.parse('${BaseUrl.baseUrl}/api/${v.v1}/UpdateRecommand'),
    );

    request.body = json.encode({
      "id": selectedLeave.id,
      "reqFrom": widget.empCode,
      "reqTo": "",
      "companyID": widget.companyID,
      "remarks":"",
      "type": 2,
      "status": 0,
    });
    print('Request Body: ${request.body}');

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());

      // Show a SnackBar to indicate success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Leave application Forward successfully.'),
          backgroundColor: Colors.green,
        ),
      );

      // Refresh the page by re-fetching the leave applications
      await fetchGetWaitingLeaveForApprove();
    } else {
      print(response.reasonPhrase);

      // Show an error SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to Forward leave application: ${response.reasonPhrase}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  Future<void> fetchUpdateLeaveApprove(
      String employeeName,
      String leaveType,
      String applyDate,
      String fromDate,
      String endDate,
      String appliedDays,
      String acceptedDays,
      String payType,
      LeaveDatafor selectedLeave,
      String forwardToID,
      ) async {
    // Print the data before constructing the request
    print('Employee Name: $employeeName');
    print('Leave Type: $leaveType');
    print('Apply Date: $applyDate');
    print('From Date: $fromDate');
    print('End Date: $endDate');
    print('Applied Days: $appliedDays');
    print('Accepted Days: $acceptedDays');
    print('Pay Type: $payType');
    print('Selected Leave ID: ${selectedLeave.id}');
    print('Selected Leave Employee Code: ${selectedLeave.empCode}');

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': '${BaseUrl.authorization}',
    };

    var request = http.Request(
      'POST',
      Uri.parse('${BaseUrl.baseUrl}/api/${v.v1}/leave/UpdateByAuthority'),
    );

    // Format dates using DateFormat
    final formattedStartDate = DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(DateTime.parse(fromDate));
    final formattedEndDate = DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(DateTime.parse(endDate));
    final formattedApplicationDate = DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(DateTime.parse(applyDate));

    request.body = json.encode(
      {
        "id": selectedLeave.id,
        "startDate": formattedStartDate,
        "endDate": formattedEndDate,
        "applicationDate": formattedApplicationDate,
        "accepteDuration": int.parse(acceptedDays),
        "leaveTypedID": selectedLeave.leaveTypedID,
        "unAccepteDuration": int.parse(appliedDays),
        //"grandtype": 1,
        "withpay": payType,
        "appType": selectedLeave.appType,
        "companyID": selectedLeave.companyID,
        "forwardEmpCode": forwardToID,
      },
    );

    request.headers.addAll(headers);

    // Print the JSON-encoded request body before sending the request
    print('Request Body: ${request.body}');

    http.StreamedResponse response = await request.send();

    String responseBody = await response.stream.bytesToString();
    print(responseBody);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Edit update successful"),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
      await fetchGetWaitingLeaveForApprove();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Edit update failed"),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
      print(response.reasonPhrase);
    }

  }



}



class RadioOptions extends StatefulWidget {
  final String selectedOption;
  final int leaveId;
  final Function(String) onOptionChanged;

  RadioOptions({required this.selectedOption, required this.onOptionChanged, required this.leaveId});

  @override
  _RadioOptionsState createState() => _RadioOptionsState();
}

class _RadioOptionsState extends State<RadioOptions> {
  late String selectedOption;

  @override
  void initState() {
    super.initState();
    selectedOption = widget.selectedOption;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        RadioListTile(
          title: Text('With Pay'),
          value: '1',
          groupValue: selectedOption,
          onChanged: (value) {
            setState(() {
              selectedOption = value ?? 'withpay';
              widget.onOptionChanged(selectedOption);
            });
          },
        ),
        RadioListTile(
          title: Text('Without Pay'),
          value: '0',
          groupValue: selectedOption,
          onChanged: (value) {
            setState(() {
              selectedOption = value ?? 'withoutpay';
              widget.onOptionChanged(selectedOption);
            });
          },
        ),
        Text('His/Her PayType: $selectedOption'),
        Text('leaveId: ${widget.leaveId}'),
      ],
    );
  }
}
