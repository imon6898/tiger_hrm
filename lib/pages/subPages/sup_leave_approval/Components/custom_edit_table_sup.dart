
import 'dart:io';

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
import 'package:tiger_erp_hrm/controller/dashboard_controller.dart';
import 'dart:convert';

import 'Model/model_sup.dart';


int leaveId=0;
String selectedOption = '';


class CustomTableSup extends StatefulWidget {
  //final String token;

  final String empCode;
  final String companyID;

  CustomTableSup({//required this.token,
    required this.empCode, required this.companyID});

  @override
  _CustomTableSupState createState() => _CustomTableSupState();
}

class _CustomTableSupState extends State<CustomTableSup> {

  List<LeaveDataforSup> leaveDataList = [];

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
  TextEditingController leDateController = TextEditingController();
  TextEditingController laDateController = TextEditingController();
  TextEditingController applideDayController = TextEditingController();
  TextEditingController applideDayChangeController = TextEditingController();
  TextEditingController updateLeaveDuration = TextEditingController();

  TextEditingController editEmployeeId = TextEditingController();
  TextEditingController editEmployeeName = TextEditingController();
  TextEditingController editEmployeeEmail = TextEditingController();
  TextEditingController editSupEmployeeName = TextEditingController();
  TextEditingController editSupEmployeeEmail = TextEditingController();
  TextEditingController editReporterEmployeeName = TextEditingController();
  TextEditingController editReporterEmployeeEmail = TextEditingController();
  TextEditingController editlaDateController = TextEditingController();
  TextEditingController editfromDateController = TextEditingController();
  TextEditingController editleDateController = TextEditingController();
  TextEditingController editApplideDayController = TextEditingController();
  TextEditingController editApplideDayChangeController = TextEditingController();
  TextEditingController editLeaveTypeController = TextEditingController();




  DateTime? fromDate;
  DateTime? leDate;




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

  Future<void> fetchRecommendLeave(
      int leaveId,
      String forwardToID,
      String empCode,
      String empName,
      String empEmail,
      String days,
      String typeName,
      String reportToEmail,
      String reportToEmpName,
      String recommandToEmail,
      String recommandedName,
      String remark,
      String lsDate,
      String leDate,
      String statusDate,
      BuildContext context,
      ) async {
    try {

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
        "reqTo": forwardToIDController.text,
        "reqFrom": widget.empCode,
        "remarks": remark,
        "companyID": widget.companyID,
        "type": 1,
        "status": 2,
      });

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Leave application Forward successfully.'),
            backgroundColor: Colors.green,
          ),
        );

        // Refresh the page by re-fetching the leave applications
        await fetchGetWaitingLeaveForApproveSup();

        await sendEmailforRecommendLeave(
          reportToEmail,
          recommandedName,
          empName,
          empCode,
          typeName,
          lsDate,
          leDate,
          days,
          remark,
          reportToEmpName,
        );


        await sendEmailforRecommendLeavefromSup(
          reportToEmail,
          recommandedName,
          empName,
          empEmail,
          empCode,
          typeName,
          lsDate,
          leDate,
          days,
          remark,
          reportToEmpName,
        );
        var controller = Get.put(DashboardController());
        controller.fetchLeaveApprovalBadgeCount();
        controller.fetchLeaveApprovalByHrBadgeCount();
        controller.fetchLeaveApprovalSupBadgeCount();
      } else {
        print(response.reasonPhrase);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to Forward leave application.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      print('Error recommending leave: $error');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error recommending leave. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> sendEmailforRecommendLeave(
      String reportToEmail,
      String recommandedName,
      String empName,
      String empCode,
      String typeName,
      String lsDate,
      String leDate,
      String days,
      String remark,
      String reportToEmpName,
      ) async {

    var headers = {
      'Authorization': '${BaseUrl.authorization}',
    };
    var request = http.MultipartRequest('POST', Uri.parse('${BaseUrl.baseUrl}/api/Email/Send'));
    request.fields.addAll({
      'ToEmail': reportToEmail, // Use reportToEmail here
      'Subject': '$recommandedName Recommended $typeName Application',
      'Body': '''Dear $reportToEmpName,
      
      \nI hope this message finds you well. $recommandedName This Recomanded $empName(ID: $empCode) Apply to request $typeName from $lsDate to $leDate due to $days Days. $remark.
      
      \nThank you for your understanding and support. Please let me know if there are any additional steps I should take.
      
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

  Future<void> sendEmailforRecommendLeavefromSup(
      String reportToEmail,
      String recommandedName,
      String empName,
      String empEmail,
      String empCode,
      String typeName,
      String lsDate,
      String leDate,
      String days,
      String remark,
      String reportToEmpName,
      ) async {

    var headers = {
      'Authorization': '${BaseUrl.authorization}',
    };
    var request = http.MultipartRequest('POST', Uri.parse('${BaseUrl.baseUrl}/api/Email/Send'));
    request.fields.addAll({
      'ToEmail': empEmail, // Use reportToEmail here
      'Subject': '$recommandedName Recommended Your $typeName Application',
      'Body': '''Dear $empName,
      
      \nI hope this message finds you well. $recommandedName already Recomanded This Application $empName(ID: $empCode) Apply to request $typeName from $lsDate to $leDate due to $days Days.
      
      \nThank you for your understanding and support. Please let me know if there are any additional steps I should take.
      
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


  Future<void> sendEmailForCancelLeavefromSup(
      String reportToEmail,
      String recommandedName,
      String empName,
      String empEmail,
      String empCode,
      String typeName,
      String lsDate,
      String leDate,
      String days,
      String remark,
      String reportToEmpName,
      ) async {

    var headers = {
      'Authorization': '${BaseUrl.authorization}',
    };
    var request = http.MultipartRequest('POST', Uri.parse('${BaseUrl.baseUrl}/api/Email/Send'));
    request.fields.addAll({
      'ToEmail': empEmail, // Use reportToEmail here
      'Subject': '$recommandedName Cancel Your $typeName Application',
      'Body': '''Dear $empName,
      
      \nI hope this message finds you well. Unfortunately, $recommandedName has decided to cancel your $typeName application that was scheduled from $lsDate to $leDate, which was initially recommended for $days Days.

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




  Future<void> fetchPendingToApproveLeave(int leaveId, String remark, String statusDate, {String applyTo = ''}) async {
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
      "reqTo": applyTo,
      "reqFrom": widget.empCode,
      "remarks": remark,
      "companyID": widget.companyID,
      "type": 1,
      "status": 0,
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());

      // Show a SnackBar to indicate success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Leave application Approved successfully.'),
          backgroundColor: Colors.green,
        ),
      );

      // Refresh the page by re-fetching the leave applications
      await fetchGetWaitingLeaveForApproveSup();
    } else {
      print(response.reasonPhrase);

      // Show an error SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to Approved leave application: ${response.reasonPhrase}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

/*  Future<void> fetchPendingToApproveLeave(int leaveId, String remark, String statusDate) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': '${BaseUrl.authorization},
    };

    var request = http.Request(
      'POST',
      Uri.parse('${BaseUrl.baseUrl}/api/${v.v1}/leave/UpdateLeaveInfoStatus'),
    );

    request.body = json.encode({
      "id": 0,
      "leaveID": leaveId,
      "reqFrom": widget.empCode,
      "reqTo": forwardToIDController.text,
      "statusDate": statusDate,  // Use the provided statusDate parameter
      "status": 2,
      "companyID": 1,
      "remarks": remark,
      "type": 2,
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
      await fetchGetWaitingLeaveForApproveSup();
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
  }*/

  Future<void> fetchCancelLeave(
      int leaveId,
      String forwardToID,
      String empCode,
      String empName,
      String empEmail,
      String days,
      String typeName,
      String reportToEmail,
      String reportToEmpName,
      String recommandToEmail,
      String recommandedName,
      String remark,
      String lsDate,
      String leDate,
      String statusDate,
      BuildContext context,

      ) async {
    try {
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
        "reqTo": "String", // Replace with the actual value or remove if not needed
        "companyID": widget.companyID,
        "remarks": remark,
        "type": 3,
        "status": 0,
      });

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());

        // Show a SnackBar to indicate success

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Leave application successfully canceled.'),
            backgroundColor: Colors.green,
          ),
        );

        // Refresh the page by re-fetching the leave applications
        await fetchGetWaitingLeaveForApproveSup();

        await sendEmailForCancelLeavefromSup(
          reportToEmail,
          recommandedName,
          empName,
          empEmail,
          empCode,
          typeName,
          lsDate,
          leDate,
          days,
          remark,
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
    } catch (error) {
      print('Error canceling leave: $error');
      // Show an error SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error canceling leave. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
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
    fetchGetWaitingLeaveForApproveSup();
    laDateController.text = DateTime.now().toString().split(" ")[0];
  }

  Future<void> fetchGetWaitingLeaveForApproveSup() async {
    var headers = {
      'Authorization': '${BaseUrl.authorization}',
    };
    var request = http.Request(
      'GET',
        Uri.parse('${BaseUrl.baseUrl}/api/${v.v1}/GetWaitingLeaveForRecommend/${widget.companyID}/${widget.empCode}'),
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

          return LeaveDataforSup(
            empCode: item['empCode'] ?? '',
            empName: item['empName'] ?? '',
            empEmail: item['empEmail'] ?? '',
            designation: item['designation'] ?? '',
            department: item['department'] ?? '',
            typeName: item['typeName'] ?? '',
            laDate: item['laDate'] ?? '',
            lsDate: item['lsDate'] ?? '',
            leDate: item['leDate'] ?? '',
            days: item['accepteDuration'].toString(),
            payType: item['withpay'] ?? '',
            id: item['id'] ?? 0,
            reason: item['reason'] ?? '',
            emgContructNo: (item['emgContructNo'] ?? '').toString(),
            leaveTypedID: item['leaveTypedID'] ?? 0,
            unAccepteDuration:  (item['unAccepteDuration'] ?? '').toString(),
            referanceEmpcode: item['referanceEmpcode'] ?? '',
            grandtype: item['grandtype'] ?? 0,
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
          const DataColumn(label: Text('Recommend')),
          //const DataColumn(label: Text('Approve')),
          const DataColumn(label: Text('Cancel')),
          const DataColumn(label: Text('Edit')),

        ],
        rows: leaveDataList
            .map((data) {
          final int index = leaveDataList.indexOf(data);
          final Color rowColor = getRowColor(index);
          // Parse the dates using the utility function
          final DateTime? laDate = parseApiDate(data.laDate.toString());
          final DateTime? lsDate = parseApiDate(data.lsDate.toString());
          final DateTime? leDate = parseApiDate(data.leDate.toString());

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
                DataCell(Text(DateFormat("yyyy-MM-dd").format(DateTime.parse("${data.laDate}")))),
                DataCell(Text(DateFormat("yyyy-MM-dd").format(DateTime.parse("${data.lsDate}")))),
                DataCell(Text(DateFormat("yyyy-MM-dd").format(DateTime.parse("${data.leDate}")))),
                DataCell(Text(data.typeName.toString())),
                DataCell(Text(data.days.toString())),
                DataCell(Text(data.payType.toString())),
                DataCell(
                  ElevatedButton(
                    onPressed: () {
                      forwardToIDController.text = data.applyTo.toString();
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
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                controller: forwardToNameController,
                                enabled: false,
                                decoration: const InputDecoration(
                                  labelText: 'Name',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                controller: forwardToDesignationController,
                                enabled: false,
                                decoration: const InputDecoration(
                                  labelText: 'Designation',
                                  border: OutlineInputBorder(),
                                ),
                              ),
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
                        ),
                        confirm: ElevatedButton(
                          onPressed: () {
                            // Check if forwardToIDController.text is not empty before recommending
                            if (forwardToIDController.text.isNotEmpty) {
                              // Pass leaveId, remark, and statusDate to the recommendation function
                              fetchRecommendLeave(
                                data.id,
                                forwardToIDController.text, // Add the forwardToID parameter
                                data.empCode,
                                data.empName,
                                data.empEmail,
                                data.days.toString(), // Convert days to String
                                data.typeName,
                                data.reportToEmail,
                                data.reportToEmpName,
                                data.recommandToEmail,
                                data.recommandedName,
                                remarkController.text,
                                DateFormat("yyyy-MM-dd").format(DateTime.parse("${data.lsDate}")),
                                DateFormat("yyyy-MM-dd").format(DateTime.parse("${data.leDate}")),
                                DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now().toUtc()),
                                context, // Pass the context parameter
                              );

                              Navigator.pop(context);
                            } else {
                              // Show an error message if forwardToID is empty
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Please enter a valid Forward to ID.'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
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
                ),
                /*DataCell(
                  ElevatedButton(
                    onPressed: () {
                      // Create a TextEditingController
                      TextEditingController remarkController = TextEditingController();

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
                                border: const OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Use the TextEditingController for the TextField
                            TextField(
                              controller: remarkController,
                              decoration: InputDecoration(
                                labelText: 'Remark',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                        confirm: ElevatedButton(
                          onPressed: () {
                            print('Remark: ${remarkController.text}');
                            // Pass applyTo and leaveId to the approval function
                            fetchPendingToApproveLeave(
                              data.id,
                              remarkController.text,
                              DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now().toUtc()),
                              applyTo: data.applyTo, // Pass applyTo data to the function
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
                    child: const Text("Pending", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                    ),
                  ),
                ),*/
                DataCell(
                  ElevatedButton(
                    onPressed: () {
                      Get.defaultDialog(
                        title: 'Cancel Application',
                        titlePadding: const EdgeInsets.all(5),
                        contentPadding: const EdgeInsets.all(10),
                        content: Column(
                          children: [
                            Text('Are you sure you want to Cancel ${data.id}?'),
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
                            fetchCancelLeave(
                              data.id,
                              forwardToIDController.text, // Add the forwardToID parameter
                              data.empCode,
                              data.empName,
                              data.empEmail,
                              data.days.toString(), // Convert days to String
                              data.typeName,
                              data.reportToEmail,
                              data.reportToEmpName,
                              data.recommandToEmail,
                              data.recommandedName,
                              remarkController.text,
                              DateFormat("yyyy-MM-dd").format(DateTime.parse("${data.lsDate}")),
                              DateFormat("yyyy-MM-dd").format(DateTime.parse("${data.leDate}")),
                              DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now().toUtc()),
                              context,
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
                      handleEditButton(data); // Pass the leaveId to the function
                    },
                    child: const Text(
                      "Edit",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
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
    editlaDateController.text = DateFormat("yyyy-MM-dd").format(DateTime.parse(selectedLeave.laDate));
    editfromDateController.text = DateFormat("yyyy-MM-dd").format(DateTime.parse(selectedLeave.lsDate));
    editleDateController.text = DateFormat("yyyy-MM-dd").format(DateTime.parse(selectedLeave.leDate));
    editApplideDayController.text = selectedLeave.days;
    editApplideDayChangeController.text = selectedLeave.days;
    editLeaveTypeController.text = selectedLeave.typeName.toString();
    forwardToIDController.text = selectedLeave.applyTo.toString();

    editEmployeeEmail.text = selectedLeave.empEmail;
    editSupEmployeeName.text = selectedLeave.recommandedName;
    editSupEmployeeEmail.text = selectedLeave.recommandToEmail;
    editReporterEmployeeName.text = selectedLeave.reportToEmpName;
    editReporterEmployeeEmail.text = selectedLeave.reportToEmail;

    print('Employee Name: ${editEmployeeName.text}');
    print('Leave Type: ${editLeaveTypeController.text}');
    print('Apply Date: ${editlaDateController.text}');
    print('From Date: ${editfromDateController.text}');
    print('End Date: ${editleDateController.text}');
    print('Applied Days: ${editApplideDayController.text}');
    print('Accept Days: ${editApplideDayChangeController.text}');
    print('Selected Option: $selectedOption');

    print('Employee Email: ${editEmployeeEmail.text}');
    print('Sup Employee Name: ${editSupEmployeeName.text}');
    print('Sup Employee Email: ${editSupEmployeeEmail.text}');
    print('Reporter Employee Name: ${editReporterEmployeeName.text}');
    print('Reporter Employee Emaill: ${editReporterEmployeeEmail.text}');


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
                controller: editlaDateController,
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
                controller: editleDateController,
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


                        fetchUpdateLeaveApprove(
                          editEmployeeName.text,
                          editLeaveTypeController.text,
                          editlaDateController.text,
                          editfromDateController.text,
                          editleDateController.text,
                          editApplideDayController.text,
                          editApplideDayChangeController.text,
                          selectedOption,
                          selectedLeave,
                          forwardToIDController.text,

                            editEmployeeEmail.text,
                            editSupEmployeeName.text,
                            editSupEmployeeEmail.text,
                            editReporterEmployeeName.text,
                            editReporterEmployeeEmail.text,
                        );

                        fetchRecommendEdit(
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
    DateTime initialDatePickerDate = editleDateController.text.isEmpty
        ? DateTime.now()
        : DateTime.parse(editleDateController.text);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDatePickerDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        leDate = picked;
        editleDateController.text = picked.toString().split(" ")[0];
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
    if (fromDate != null && leDate != null) {
      final duration = leDate!.difference(fromDate!).inDays + 1;
      print('Duration: $duration'); // Add this line for debugging
      editApplideDayChangeController.text = '$duration';
    } else {
      editApplideDayChangeController.text = '';
    }
  }

  Future<void> fetchUpdateLeaveApprove(
      String employeeName,
      String leaveType,
      String laDate,
      String fromDate,
      String leDate,
      String appliedDays,
      String acceptedDays,
      String payType,
      LeaveDataforSup selectedLeave,
      String forwardToID,

      String employeeEmail,
      String supEmployeeName,
      String supEmployeeEmail,
      String reporterEmployeeName,
      String reporterEmployeeEmail,
      ) async {
    print('Employee Name: $employeeName');
    print('Leave Type: $leaveType');
    print('Apply Date: $laDate');
    print('From Date: $fromDate');
    print('End Date: $leDate');
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
      //Uri.parse('${BaseUrl.baseUrl}/api/v1/leave/UpdateByAuthority'),
      Uri.parse('${BaseUrl.baseUrl}/api/${v.v1}/leave/UpdateByAuthority'),
    );

    // Format dates using DateFormat
    final formattedlsDate = DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(DateTime.parse(fromDate));
    final formattedleDate = DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(DateTime.parse(leDate));
    final formattedlaDate = DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(DateTime.parse(laDate));


    request.body = json.encode({
      "id": selectedLeave.id,
      "startDate": formattedlsDate,
      "endDate": formattedleDate,
      "applicationDate": formattedlaDate,
      "accepteDuration": int.parse(acceptedDays),
      "leaveTypedID": selectedLeave.leaveTypedID,
      "unAccepteDuration": int.parse(appliedDays),
      //"grandtype": 2,
      "withpay": payType,
      "appType": selectedLeave.appType,
      "companyID": selectedLeave.companyID,
      "forwardEmpCode": forwardToID,
    });

    print('Request Body: ${request.body}');


    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Edit update successful"),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
      print(await response.stream.bytesToString());
      await fetchGetWaitingLeaveForApproveSup();

      await sendEmailforEditLeavefromSup(
        employeeName,
        leaveType,
        laDate,
        fromDate,
        leDate,
        appliedDays,
        acceptedDays,
        payType,
        selectedLeave,
        forwardToID,
        employeeEmail,
        supEmployeeName,
        supEmployeeEmail,
        reporterEmployeeName,
        reporterEmployeeEmail,
      );


      await sendEmailReporterforEditLeavefromSup(
        employeeName,
        leaveType,
        laDate,
        fromDate,
        leDate,
        appliedDays,
        acceptedDays,
        payType,
        selectedLeave,
        forwardToID,
        employeeEmail,
        supEmployeeName,
        supEmployeeEmail,
        reporterEmployeeName,
        reporterEmployeeEmail,
      );

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


  Future<void> sendEmailforEditLeavefromSup(
      String employeeName,
      String leaveType,
      String laDate,
      String fromDate,
      String leDate,
      String appliedDays,
      String acceptedDays,
      String payType,
      LeaveDataforSup selectedLeave,
      String forwardToID,
      String employeeEmail,
      String supEmployeeName,
      String supEmployeeEmail,
      String reporterEmployeeName,
      String reporterEmployeeEmail,
      ) async {

    print('Employee Name employeeName');
    print('Employee Name: $employeeName');
    print('Leave Type: $leaveType');
    print('Apply Date: $laDate');
    print('From Date: $fromDate');
    print('End Date: $leDate');
    print('Applied Days: $appliedDays');
    print('Accepted Days: $acceptedDays');
    print('Pay Type: $payType');
    print('Selected Leave ID: ${selectedLeave.id}');
    print('Selected Leave Employee Code: ${selectedLeave.empCode}');

    // Print additional data
    print('Forwarded To ID: $forwardToID');
    print('Employee Email: $employeeEmail');
    print('Supervisor Employee Name: $supEmployeeName');
    print('Supervisor Employee Email: $supEmployeeEmail');
    print('Reporter Employee Name: $reporterEmployeeName');
    print('Reporter Employee Email: $reporterEmployeeEmail');

    var headers = {
      'Authorization': '${BaseUrl.authorization}',
    };

    var withpay = (payType == "0") ? "withoutpay" : "withpay";

    var request = http.MultipartRequest('POST', Uri.parse('${BaseUrl.baseUrl}/api/Email/Send'));
    request.fields.addAll({
      'ToEmail': employeeEmail, // Use reportToEmail here
      'Subject': '$supEmployeeName Edit Your $leaveType Application',
      'Body': '''Dear $employeeName,
      
      \nI hope this message finds you well. $supEmployeeName Edit Your Application $employeeName Apply to request $leaveType from $fromDate to $leDate due to $acceptedDays Days PayType $withpay.
      
      \nThank you for your understanding and support. Please let me know if there are any additional steps I should take.
      
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


  Future<void> sendEmailReporterforEditLeavefromSup(
      String employeeName,
      String leaveType,
      String laDate,
      String fromDate,
      String leDate,
      String appliedDays,
      String acceptedDays,
      String payType,
      LeaveDataforSup selectedLeave,
      String forwardToID,
      String employeeEmail,
      String supEmployeeName,
      String supEmployeeEmail,
      String reporterEmployeeName,
      String reporterEmployeeEmail,
      ) async {

    print('Employee Name employeeName');
    print('Employee Name: $employeeName');
    print('Leave Type: $leaveType');
    print('Apply Date: $laDate');
    print('From Date: $fromDate');
    print('End Date: $leDate');
    print('Applied Days: $appliedDays');
    print('Accepted Days: $acceptedDays');
    print('Pay Type: $payType');
    print('Selected Leave ID: ${selectedLeave.id}');
    print('Selected Leave Employee Code: ${selectedLeave.empCode}');

    // Print additional data
    print('Forwarded To ID: $forwardToID');
    print('Employee Email: $employeeEmail');
    print('Supervisor Employee Name: $supEmployeeName');
    print('Supervisor Employee Email: $supEmployeeEmail');
    print('Reporter Employee Name: $reporterEmployeeName');
    print('Reporter Employee Email: $reporterEmployeeEmail');

    var headers = {
      'Authorization': '${BaseUrl.authorization}',
    };

    var withpay = (payType == "0") ? "withoutpay" : "withpay";

    var request = http.MultipartRequest('POST', Uri.parse('${BaseUrl.baseUrl}/api/Email/Send'));
    request.fields.addAll({
      'ToEmail': reporterEmployeeEmail, // Use reportToEmail here
      'Subject': '$supEmployeeName Edit $employeeName $leaveType Application',
      'Body': '''Dear $reporterEmployeeName,
      
      \nI hope this message finds you well. $supEmployeeName Edited Application $employeeName Apply to request $leaveType from $fromDate to $leDate due to $acceptedDays Days PayType $withpay.
      
      \nThank you for your understanding and support. Please let me know if there are any additional steps I should take.
      
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







  Future<void> fetchRecommendEdit(
      LeaveDataforSup selectedLeave,
      String forwardToID,
      ) async {
    try {
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
        "reqTo": forwardToID,
        "reqFrom": widget.empCode,
        "remarks": "",
        "companyID": selectedLeave.companyID,
        "type": 1,
        "status": 2,
      });

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Leave application Forward successfully.'),
            backgroundColor: Colors.green,
          ),
        );

        // Refresh the page by re-fetching the leave applications
        await fetchGetWaitingLeaveForApproveSup();
      } else {
        print(response.reasonPhrase);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to Forward leave application.'),
            backgroundColor: Colors.red,
          ),
        );

        // Show an error SnackBar
        //showSnackBar('Failed to Forward leave application: ${response.reasonPhrase}', Colors.red);
      }
    } catch (error) {
      print('Error recommending leave: $error');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error recommending leave. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
      // Show an error SnackBar
      //showSnackBar('Error recommending leave. Please try again.', Colors.red);
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
