
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:tiger_erp_hrm/Coustom_widget/custom_text_field2.dart';
import 'package:tiger_erp_hrm/LoginApiController/loginController.dart';
import 'package:tiger_erp_hrm/pages/subPages/leave_approve_by_hr/Model/model.dart';
import 'dart:convert';

import '../../../../Coustom_widget/CustomDatePickerField.dart';
import '../../../../Coustom_widget/CustomDropdownField.dart';
import '../../../../Coustom_widget/Textfield.dart';
import '../../../../Coustom_widget/coustom_text field.dart';


int leaveId=0;

class CustomEditTableHr extends StatefulWidget {
  //final String token;
  final String userName;
  final String empCode;
  final String companyID;
  final String companyName;
  final String reportTo;
  final int userTypeId;
  final Function onCancel;

  CustomEditTableHr({//required this.token,
    required this.onCancel,
    required this.userName,
    required this.empCode,
    required this.companyID,
    required this.companyName,
    required this.reportTo,
    required this.userTypeId,
  });


  @override
  _CustomEditTableHrState createState() => _CustomEditTableHrState();
}

class _CustomEditTableHrState extends State<CustomEditTableHr> {
  List<Map<String, dynamic>> tableData = [];
  bool isFetchingData = true;

  // Utility function to handle date conversion
  DateTime? parseApiDate(String dateString) {
    if (dateString == "0001-01-01T00:00:00") {
      return null; // Return null for the special case
    }
    return DateTime.parse(dateString);
  }


  String selectedOption = '1';
  List<String> options = ['1', '0'];

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

  TextEditingController editEmployeeTypeName = TextEditingController();
  TextEditingController editEmployeeId = TextEditingController();
  TextEditingController editEmployeeName = TextEditingController();
  TextEditingController editapplyDateController = TextEditingController();
  TextEditingController editfromDateController = TextEditingController();
  TextEditingController editendDateController = TextEditingController();
  TextEditingController editApplideDayController = TextEditingController();
  TextEditingController editApplideDayChangeController = TextEditingController();
  TextEditingController edittypeNameController = TextEditingController();

  TextEditingController editEmployeeEmail = TextEditingController();
  TextEditingController editEmployeeReportToEmail = TextEditingController();
  TextEditingController editEmployeeReportToEmpName = TextEditingController();




  DateTime? fromDate;
  DateTime? endDate;






  Future<void> fromSelectDate() async {
    DateTime initialDatePickerDate = editfromDateController.text.isEmpty
        ? DateTime.now()
        : DateFormat('dd-MMM-yyyy').parse(editfromDateController.text);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDatePickerDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        fromDate = picked;
        editfromDateController.text = DateFormat('dd-MMM-yyyy').format(picked);
        _updateLeaveDuration(); // Calculate and update Leave Duration
      });
    }
  }


  Future<void> endSelectDate() async {
    DateTime initialDatePickerDate = editendDateController.text.isEmpty
        ? DateTime.now()
        : DateFormat('dd-MMM-yyyy').parse(editendDateController.text);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDatePickerDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        endDate = picked;
        editendDateController.text = DateFormat('dd-MMM-yyyy').format(picked);
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


  Future<void> fetchPendingToApproveLeave(
      int leaveId,
      String requestFrom,
      String empName,
      String empEmail,
      String typeName,
      String days,
      String recommandToEmail,
      String recommandedName,
      String reportToEmail,
      String reportToEmpName,
      String applyDate,
      String startDate,
      String endDate,
      ) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': '${BaseUrl.authorization}',
    };

    var request = http.Request(
      'POST',
      Uri.parse('${BaseUrl.baseUrl}/api/${v.v1}/leave/ApproveByHr'),
    );


    request.body = json.encode({
    "id": 0,
    "leaveID": leaveId,
    "empCode": requestFrom, // Use the provided empCode parameter
    "leaveDate": applyDate,
    "startDate": startDate,
    "endDate": endDate
    });

    print("requestbody: $request");

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
      await fetchGetWaitingLeaveForApprove();

      await sendEmailForLeaveApprovedfromHR(
        leaveId,
        requestFrom,
        empName,
        empEmail,
        typeName,
        days,
        recommandToEmail,
        recommandedName,
        reportToEmail,
        reportToEmpName,
        applyDate,
        startDate,
        endDate,
      );
      widget.onCancel();
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


  Future<void> sendEmailForLeaveApprovedfromHR(
      int leaveId,
      String requestFrom,
      String empName,
      String empEmail,
      String typeName,
      String days,
      String recommandToEmail,
      String recommandedName,
      String reportToEmail,
      String reportToEmpName,
      String applyDate,
      String startDate,
      String endDate,
      ) async {

    startDate = DateFormat('dd/MMM/yyyy').format(DateTime.parse(startDate));
    endDate = DateFormat('dd/MMM/yyyy').format(DateTime.parse(endDate));

    var headers = {
      'Authorization': '${BaseUrl.authorization}',
    };
    var request = http.MultipartRequest('POST', Uri.parse('${BaseUrl.baseUrl}/api/Email/Send'));
    request.fields.addAll({
      'ToEmail': empEmail, // Use reportToEmail here
      'Subject': '$reportToEmpName Approved Your $typeName Application',
      'Body': '''Dear $empName,
      
      \nI hope this message finds you well. $reportToEmpName already Approved  This Application $empName(ID: $requestFrom) Apply to request $typeName from $startDate to $endDate due to $days Days.
      
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



  Future<void> fetchCancelLeave(
      int leaveId,
      String remark,
      String statusDate,
      String requestFrom,
      String empName,
      String empEmail,
      String typeName,
      String days,
      String recommandToEmail,
      String recommandedName,
      String reportToEmail,
      String reportToEmpName,
      String applyDate,
      String startDate,
      String endDate,
      ) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': '${BaseUrl.authorization}',
    };

    // Construct the URL
    String apiUrl = '${BaseUrl.baseUrl}/api/${v.v1}/UpdateRecommand';
    Uri requestUri = Uri.parse(apiUrl); // Parse the URL

    print('Request URL: $requestUri'); // Print the URL

    var request = http.Request('POST', requestUri);

    request.body = json.encode({

      "id": leaveId,
      "reqFrom": widget.empCode,
      "reqTo": forwardToIDController.text,
      "companyID": widget.companyID,
      "remarks": remark,
      "type": 3,
      "status": -1,

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

      // Refresh the page by re-fetching the leave applications
      await fetchGetWaitingLeaveForApprove();

      await sendEmailForLeaveCancelfromHR(
        leaveId,
        requestFrom,
        empName,
        empEmail,
        typeName,
        days,
        recommandToEmail,
        recommandedName,
        reportToEmail,
        reportToEmpName,
        applyDate,
        startDate,
        endDate,
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


  Future<void> sendEmailForLeaveCancelfromHR(
  int leaveId,
  String requestFrom,
  String empName,
  String empEmail,
  String typeName,
  String days,
  String recommandToEmail,
  String recommandedName,
  String reportToEmail,
  String reportToEmpName,
  String applyDate,
  String startDate,
  String endDate,
  ) async {
  // Format the startDate and endDate here
  startDate = DateFormat('dd/MMM/yyyy').format(DateTime.parse(startDate));
  endDate = DateFormat('dd/MMM/yyyy').format(DateTime.parse(endDate));

  var headers = {
  'Authorization': '${BaseUrl.authorization}',
  };
  var request = http.MultipartRequest('POST', Uri.parse('${BaseUrl.baseUrl}/api/Email/Send'));
  request.fields.addAll({
  'ToEmail': empEmail, // Use reportToEmail here
  'Subject': '$reportToEmpName Approved Your $typeName Application',
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
    applyDateController.text = DateTime.now().toString().split(" ")[0];
    print('User Type IDUser Type ID: ${widget.userTypeId}');

    List<String> selectedOption = options;

    if (widget.userTypeId == 9) {
      // Fetch data using a different method or API endpoint
      fetchGetWaitingLeaveForApprove();
    } else {
      // Fetch data using the default method
      fetchDataDefaultMethod(); // Replace with the actual method to fetch data
    }
  }

  Future<Container> fetchDataDefaultMethod() async {
    // Replace this with the actual logic to fetch data when userTypeId is not 9
    // For example, you can fetch some default data or show a placeholder.
    // Here, I'm using a placeholder Container with a Lottie animation.
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Lottie.asset(
            'lib/images/nodata.json', // Replace with the path to your Lottie animation file
          ),
        ),
      ),
    );
  }


  Future<void> fetchGetWaitingLeaveForApprove() async {
    try {
    var headers = {
      'Authorization': '${BaseUrl.authorization}',
    };
    var request = http.Request(
      'GET', //${BaseUrl.baseUrl}/api/${v.v1}/leave/GetWaitingLeaveForApprove/1/23/${widget.empCode}
      Uri.parse('${BaseUrl.baseUrl}/api/${v.v1}/leave/GetLeaveInfoForHrApprove/${widget.companyID}'),
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
        tableData = data.asMap().entries.map((entry) {
          final index = entry.key + 1; // Calculate the serial number
          final item = entry.value;
          leaveId=item['id'];
          print("this is leave Type id:$leaveId");
          return {
            'ID' : item['id'],
            'SN': index.toString(), // Serial number
            'empCode': item['empCode'],
            'Name': item['empName'],
            'TypeName': item['typeName'],
            'empEmail': item['empEmail'],
            'Department': item['department'],
            'Designation': item['designation'],
            'ApplyDate': item['laDate'],
            'StartDate': item['lsDate'],
            'EndDate': item['leDate'],
            'Days': item['accepteDuration'].toString(),
            'PayType': item['withpay'],

            'Reason': item['reason'],
            'EmgContructNo': item['emgContructNo'],
            'leaveTypedID': item['leaveTypedID'],
            'UnAccepteDuration': item['unAccepteDuration'],
            'ReferanceEmpcode': item['referanceEmpcode'],
            'Grandtype': item['grandtype'],
            'AppType': item['appType'],
            'CompanyID': item['companyID'],
            'ApplyTo': item['applyTo'],
            'EmgAddress': item['emgAddress'],
            'UserName': item['userName'],
            'AuthorityEmpcode': item['authorityEmpcode'],
            'recommandToEmail': item['recommandToEmail'],
            'recommandedName': item['recommandedName'],
            'reportToEmail': item['reportToEmail'],
            'reportToEmpName': item['reportToEmpName'],

            'Pending': 'Pending, Recommended', // You can customize this button
            'Cancel': 'Cancel', // You can customize this button
            'Edit': 'Edit', // You can customize this button
            'Print': 'Print', // You can customize this button
          };
        }).toList();
        tableData.forEach((item) {
          print("tueing:$item");
        });
        isFetchingData = false;
      });
    } else {
      isFetchingData = false;
      throw Exception('Failed to load data from the API');
    }
    } catch (e) {
      print('Error fetching data: $e');
      // Handle the exception or log more details
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isFetchingData) {
      // Show loading indicator while fetching data
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (tableData.isEmpty) {
      // Show default message when no data is available
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
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
    }
    else{
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
          const DataColumn(label: Text('#SN',style: TextStyle(fontWeight: FontWeight.bold),)),
          const DataColumn(label: Text('Leave Id',style: TextStyle(fontWeight: FontWeight.bold),)),
          const DataColumn(label: Text('empCode',style: TextStyle(fontWeight: FontWeight.bold),)),
          const DataColumn(label: Text('Name',style: TextStyle(fontWeight: FontWeight.bold),)),
          const DataColumn(label: Text('Department',style: TextStyle(fontWeight: FontWeight.bold),)),
          const DataColumn(label: Text('Designation',style: TextStyle(fontWeight: FontWeight.bold),)),
          const DataColumn(label: Text('Apply Date',style: TextStyle(fontWeight: FontWeight.bold),)),
          const DataColumn(label: Text('Start Date',style: TextStyle(fontWeight: FontWeight.bold),)),
          const DataColumn(label: Text('End Date',style: TextStyle(fontWeight: FontWeight.bold),)),
          const DataColumn(label: Text('typeName',style: TextStyle(fontWeight: FontWeight.bold),)),
          const DataColumn(label: Text('Day(s)',style: TextStyle(fontWeight: FontWeight.bold),)),
          const DataColumn(label: Text('PayType',style: TextStyle(fontWeight: FontWeight.bold),)),
          const DataColumn(label: Text('Approve',style: TextStyle(fontWeight: FontWeight.bold),)),
          const DataColumn(label: Text('Cancel',style: TextStyle(fontWeight: FontWeight.bold),)),
          const DataColumn(label: Text('Edit',style: TextStyle(fontWeight: FontWeight.bold),)),
        ],
        rows: tableData
            .map((data) {
          final int index = tableData.indexOf(data);
          final Color rowColor = getRowColor(index);
          // Parse the dates using the utility function
          final DateTime? applicationDate = parseApiDate(data['ApplyDate'].toString());
          final DateTime? startDate = parseApiDate(data['StartDate'].toString());
          final DateTime? endDate = parseApiDate(data['EndDate'].toString());

          // Create the data rows
          return DataRow(
              color: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                return rowColor; // Set the background color based on row index
              }),
              cells: [
                DataCell(Text(data['SN'].toString())),
                DataCell(Text(data['ID'].toString())),
                DataCell(Text(data['empCode'].toString())),
                DataCell(Text(data['Name'].toString())),
                DataCell(Text(data['Department'].toString())),
                DataCell(Text(data['Designation'].toString())),
                DataCell(Text(DateFormat("dd-MMM-yyyy").format(DateTime.parse("${data['ApplyDate']}")))),
                DataCell(Text(DateFormat("dd-MMM-yyyy").format(DateTime.parse("${data['StartDate']}")))),
                DataCell(Text(DateFormat("dd-MMM-yyyy").format(DateTime.parse("${data['EndDate']}")))),
                DataCell(Text(data['TypeName'].toString())),
                DataCell(Text(data['Days'].toString())),
                DataCell(Text(data['PayType'].toString())),
                DataCell(
                  ElevatedButton(
                    onPressed: () {
                      Get.defaultDialog(
                        title: 'Approved Application ${data['ID']}',
                        titlePadding: const EdgeInsets.all(5),
                        contentPadding: const EdgeInsets.all(10),
                        content: Column(
                          children: [
                            const Text('Are you sure you want to Approve?'),
                            const SizedBox(height: 10),
                            TextField(
                              decoration: InputDecoration(
                                labelText: (data['empCode'].toString()),
                                border: const OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                        confirm: ElevatedButton(
                          onPressed: () {
                            // Retrieve the text entered in the TextFields
                            String requestFrom = data['empCode'].toString();
                            String empName = data['Name'].toString();
                            String empEmail = data['empEmail'].toString();
                            String typeName = data['typeName'].toString();
                            String days = data['Days'].toString();
                            String recommandToEmail = data['recommandToEmail'].toString();
                            String recommandedName = data['recommandedName'].toString();
                            String reportToEmail = data['reportToEmail'].toString();
                            String reportToEmpName = data['reportToEmpName'].toString();
                            String applyDate = data['ApplyDate'].toString();
                            String startDate = data['StartDate'].toString();
                            String endDate = data['EndDate'].toString();
                            //String applyDate = DateFormat('yyyy/MM/dd').format(DateTime.parse(data['applyDate'].toString()));
                            //String startDate = DateFormat('dd/MMM/yyyy').format(DateTime.parse(data['StartDate']));
                            //endDate = DateFormat('dd/MMM/yyyy').format(DateTime.parse(data['EndDate']));


                            // Retrieve the leaveId from the data
                            int leaveId = data['ID'];

                            // Process the data as needed
                            print('Leave ID: $leaveId');
                            print('Request From: $requestFrom');
                            print('Apply Date: $applyDate');
                            print('Start Date: $startDate');
                            print('End Date: $endDate');

                            // Call the function with the required parameters
                            fetchPendingToApproveLeave(
                              leaveId,
                              requestFrom,
                              empName,
                              empEmail,
                              typeName,
                              days,
                              recommandToEmail,
                              recommandedName,
                              reportToEmail,
                              reportToEmpName,
                              applyDate,
                              startDate,
                              endDate,
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
                    child: const Text("Pending", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                    ),
                  ),
                ),
                DataCell(
                  ElevatedButton(
                    onPressed: () {
                      Get.defaultDialog(
                        title: 'Cancel Application ${data['ID']}',
                        titlePadding: EdgeInsets.all(5),
                        contentPadding: EdgeInsets.all(10),
                        content: Column(
                          children: [
                            const Text('Are you sure you want to Cancel?'),
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

                            String requestFrom = data['empCode'].toString();
                            String empName = data['Name'].toString();
                            String empEmail = data['empEmail'].toString();
                            String typeName = data['typeName'].toString();
                            String days = data['Days'].toString();
                            String recommandToEmail = data['recommandToEmail'].toString();
                            String recommandedName = data['recommandedName'].toString();
                            String reportToEmail = data['reportToEmail'].toString();
                            String reportToEmpName = data['reportToEmpName'].toString();
                            String applyDate = data['applyDate'].toString();
                            //String applyDate = DateFormat('dd/MMM/yyyy').format(DateTime.parse(data['applyDate']));
                            String startDate = DateFormat('dd/MMM/yyyy').format(DateTime.parse(data['StartDate']));
                            String endDate = DateFormat('dd/MMM/yyyy').format(DateTime.parse(data['EndDate']));

                            String remark = remarkController.text;
                            String statusDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now().toUtc());

// Retrieve the leaveId from the data
                            int leaveId = data['ID'];

                            print('Request From: $requestFrom');
                            print('Employee Name: $empName');
                            print('Employee Email: $empEmail');
                            print('Leave Type: $typeName');
                            print('Days: $days');
                            print('Recommended To Email: $recommandToEmail');
                            print('Recommended To Name: $recommandedName');
                            print('Report To Email: $reportToEmail');
                            print('Report To Employee Name: $reportToEmpName');
                            print('Apply Date: $applyDate');
                            print('Start Date: $startDate');
                            print('End Date: $endDate');
                            print('Remark: $remark');
                            print('Status Date: $statusDate');
                            print('Leave ID: $leaveId');

                            fetchCancelLeave(
                              leaveId,
                              remark,
                              statusDate,
                              requestFrom,
                              empName,
                              empEmail,
                              typeName,
                              days,
                              recommandToEmail,
                              recommandedName,
                              reportToEmail,
                              reportToEmpName,
                              applyDate,
                              startDate,
                              endDate,
                            ); // Pass statusDate here
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
                    child: const Text("Cancel", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
                DataCell(
                  ElevatedButton(
                    onPressed: () {
                      final leaveDataforHR = LeaveDataForHR(
                        empCode: data['empCode']?.toString() ?? "",
                        empName: data['Name'].toString(),
                        empEmail: data['empEmail'].toString(),
                        applyDate: DateFormat("dd-MMM-yyyy").format(DateTime.parse("${data['ApplyDate']}")).toString(),
                        startDate: DateFormat("dd-MMM-yyyy").format(DateTime.parse("${data['StartDate']}")).toString(),
                        endDate: DateFormat("dd-MMM-yyyy").format(DateTime.parse("${data['EndDate']}")).toString(),
                        days: data['Days'].toString(),
                        payType: data['PayType'].toString(),
                        id: data['ID'],
                        reason: data['Reason']?.toString() ?? "",
                        emgContructNo: data['EmgContructNo']?.toString() ?? "",
                        typeName: data['TypeName']?.toString() ?? '',
                        leaveTypedID: data['leaveTypedID'],
                        unAccepteDuration: data['UnAccepteDuration']?.toString() ?? "",
                        referanceEmpcode: data['ReferanceEmpcode']?.toString() ?? "",
                        grandtype: data['Grandtype']?.toString() ?? "",
                        appType: data['AppType']?.toString() ?? "",
                        companyID: data['CompanyID'],
                        applyTo: data['ApplyTo']?.toString() ?? "",
                        emgAddress: data['EmgAddress']?.toString() ?? "",
                        userName: data['UserName']?.toString() ?? "",
                        authorityEmpcode: data['AuthorityEmpcode']?.toString() ?? "",
                        recommandToEmail: data['recommandToEmail']?.toString() ?? "",
                        recommandedName: data['recommandedName']?.toString() ?? "",
                        reportToEmail: data['reportToEmail']?.toString() ?? "",
                        reportToEmpName: data['reportToEmpName']?.toString() ?? "",
                      );

                      print(leaveDataforHR);

                      // Retrieve the leaveId from the data
                      int leaveId = data['ID'];

                      // Call the function with the required parameters
                      handleEditButton(
                        leaveDataforHR,
                        data['empCode'].toString(),
                        data['Name'].toString(),
                        data['empEmail'].toString(),
                        DateFormat("dd-MMM-yyyy").format(DateTime.parse("${data['ApplyDate']}")).toString(),
                        DateFormat("dd-MMM-yyyy").format(DateTime.parse("${data['StartDate']}")).toString(),
                        DateFormat("dd-MMM-yyyy").format(DateTime.parse("${data['EndDate']}")).toString(),
                        data['Days'].toString(),
                        data['Days'].toString(),
                        data['TypeName'].toString(),
                        data['PayType'].toString(),
                        data['reportToEmpName'].toString(),
                        data['reportToEmail'].toString(),
                        leaveId, // Pass leaveId here
                      );
                    },
                    child: const Text("Edit", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
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

  void handleEditButton(
      LeaveDataForHR leaveData,
      String employeeId,
      String employeeName,
      String empEmail,
      String applyDateController,
      String fromDateController,
      String endDateController,
      String applideDayController,
      String applideDayChangeController,
      String typeName,
      String payType,
      String reportToEmpName,
      String reportToEmail,
      int leaveId,
      )
  {
    print("LeaveData properties:");
    print("EmpCode: ${leaveData.empCode}");
    print("EmpName: ${leaveData.empName}");
    print("empEmail: ${leaveData.empEmail}");
    print("ApplyDate: ${leaveData.applyDate}");
    print("StartDate: ${leaveData.startDate}");
    print("EndDate: ${leaveData.endDate}");
    print("Days: ${leaveData.days}");
    print("PayType: ${leaveData.payType}");
    print("reportToEmail: ${leaveData.reportToEmail}");
    print("reportToEmpName: ${leaveData.reportToEmpName}");
    print("ID: ${leaveData.id}");
    // Add more properties as needed...

    editEmployeeEmail.text = empEmail;
    editEmployeeReportToEmail.text = reportToEmail;
    editEmployeeReportToEmpName.text = reportToEmpName;

    editEmployeeTypeName.text = payType;
    editEmployeeId.text = employeeId;
    editEmployeeName.text = employeeName;
    editapplyDateController.text = applyDateController;
    editfromDateController.text = fromDateController;
    editendDateController.text = endDateController;
    editApplideDayController.text = applideDayController;
    editApplideDayChangeController.text = applideDayChangeController;

    edittypeNameController.text = typeName;
    editEmployeeId.text = employeeId;
    editEmployeeName.text = employeeName;
    editapplyDateController.text = applyDateController;
    editfromDateController.text = fromDateController;
    editendDateController.text = endDateController;
    editApplideDayController.text = applideDayController;
    editApplideDayChangeController.text = applideDayChangeController;



    String editedEmployeeId = editEmployeeId.text;
    String editedEmployeeName = editEmployeeName.text;
    String editedApplyDate = editapplyDateController.text;
    String editedFromDate = editfromDateController.text;
    String editedEndDate = editendDateController.text;
    String editedApplideDay = editApplideDayController.text;
    String editedApplideDayChange = editApplideDayChangeController.text;


    var selectedOption;

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) =>  Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            // Set the maximum height of the BottomSheet
            height: MediaQuery.of(context).size.height * 0.6, // Adjust the percentage as needed

            decoration: BoxDecoration(
              color: Color(0xBCE8E8FF),
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
                        padding: EdgeInsets.all(8.0),
                        child: Text("Edit Application", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),),
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
                  borderColor: 0xFFBCC2C2,
                  filled: true,
                  disableOrEnable: false,
                  controller: edittypeNameController,
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
                          child: Text('Duration', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black),),
                        )
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
                      labelText: 'Accept Duration',
                      hintText: 'Accept',
                      borderColor: 0xFFBCC2C2,
                      filled: false,
                      disableOrEnable: false,
                      controller: editApplideDayChangeController,
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
                      selectedOption: payType,
                      leaveId: leaveId,
                      onOptionChanged: (option) {
                        selectedOption = option;
                        print("selectedOption: $selectedOption");
                        // Update the selected option here if needed
                        // You can also save it in a variable for further use
                        // Example: selectedOption = option;
                      },
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Row(
                    children: [
                      ElevatedButton(onPressed: (){
                        Navigator.pop(context);

                      }, child: const Text('Cancel')),
                      Spacer(),
                      ElevatedButton(
                          onPressed: () async {
                            // Handle button confirmation
                            String employeeTypeName = edittypeNameController.text;
                            String employeeId = editEmployeeId.text;
                            String employeeName = editEmployeeName.text; // Added line
                            String employeeEmail = editEmployeeEmail.text;
                            String employeeReporterEmail = editEmployeeReportToEmail.text;
                            String employeeReporterName = editEmployeeReportToEmpName.text;
                            String editedApplyDate = editapplyDateController.text;
                            String editedFromDate = editfromDateController.text;
                            String editedEndDate = editendDateController.text;
                            String editedApplideDay = editApplideDayController.text;
                            String editedApplideDayChange = editApplideDayChangeController.text;

                            // Print or use the values as needed
                            print("testtest");
                            print('Employee Type Name: $employeeTypeName');
                            print('Employee Id: $employeeId');
                            print('Employee Name: $employeeName');
                            print('Employee Email: $employeeEmail');
                            print('Employee Reporter Email: $employeeReporterEmail');
                            print('Employee Reporter Name: $employeeReporterName');
                            print('Edited Apply Date: $editedApplyDate');
                            print('Edited From Date: $editedFromDate');
                            print('Edited End Date: $editedEndDate');
                            print('Edited Applied Day: $editedApplideDay');
                            print('Edited Accepted Day: $editedApplideDayChange');

                            await fetchUpdateAndApproveByHr(
                              context,
                              leaveId,
                              employeeTypeName,
                              employeeId,
                              employeeName,
                              employeeEmail,
                              employeeReporterEmail,
                              employeeReporterName,
                              editedApplyDate,
                              editedFromDate,
                              editedEndDate,
                              editedApplideDay,
                              editedApplideDayChange,
                              leaveData,
                            );
                            Navigator.pop(context);
                            await fetchGetWaitingLeaveForApprove();
                          },
                          child: const Text('confirm')
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
  Map<String, dynamic>? selectedLeaveData;


  Future<void> fetchUpdateAndApproveByHr(
      BuildContext context,
      int leaveId,
      String employeeTypeName,
      String employeeId,
      String employeeName,
      String employeeEmail,
      String employeeReporterEmail,
      String employeeReporterName,
      String editedApplyDate,
      String editedFromDate,
      String editedEndDate,
      String editedApplideDay,
      String editedApplideDayChange,
      LeaveDataForHR leaveData,
      ) async {

    print('print allllllllll');
    print("Inside fetchUpdateAndApproveByHr:");
    print('Employee Type Name: $employeeTypeName');
    print('Employee Id: $employeeId');
    print('Employee Name: $employeeName');
    print('Employee Email: $employeeEmail');
    print('Employee Reporter Email: $employeeReporterEmail');
    print('Employee Reporter Name: $employeeReporterName');
    print('Edited Apply Date: $editedApplyDate');
    print('Edited From Date: $editedFromDate');
    print('Edited End Date: $editedEndDate');
    print('Edited Applied Day: $editedApplideDay');
    print('Edited Accepted Day: $editedApplideDayChange');


    final String updateUrl = '${BaseUrl.baseUrl}/api/${v.v1}/leave/UpdateByAuthority';

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': '${BaseUrl.authorization}',
    };

    final formattedStartDate = DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(DateFormat('dd-MMM-yyyy').parse(editedFromDate));
    final formattedEndDate = DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(DateFormat('dd-MMM-yyyy').parse(editedEndDate));
    final formattedApplicationDate = DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(DateFormat('dd-MMM-yyyy').parse(editedApplyDate));

    print('Formatted Start Date: $formattedStartDate');
    print('Formatted End Date: $formattedEndDate');
    print('Formatted Application Date: $formattedApplicationDate');


    var requestBody = {

      "id": leaveId,
      "startDate": formattedStartDate,
      "endDate": formattedEndDate,
      "applicationDate": formattedApplicationDate,
      "accepteDuration": int.parse(editedApplideDayChange),
      "leaveTypedID": leaveData.leaveTypedID,
      "unAccepteDuration": int.parse(editedApplideDay),
      "grandtype": 1,
      "withpay": selectedOption,
      "appType": leaveData.appType,
      "companyID": 1,//leaveData.companyID,
      "forwardEmpCode": "",

    };

    print('print all: $requestBody');

    var request = http.Request('POST', Uri.parse(updateUrl));
    request.headers.addAll(headers);
    request.body = json.encode(requestBody);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Edit update successful and approved"),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );

      await sendEmailReporterforEditLeavefromHR(
        context,
        leaveId,
        leaveData,
        selectedOption,
        employeeTypeName,
        employeeId,
        employeeName,
        employeeEmail,
        employeeReporterEmail,
        employeeReporterName,
        editedApplyDate,
        editedFromDate,
        editedEndDate,
        editedApplideDay,
        editedApplideDayChange,
      );

      final responseBody = await response.stream.bytesToString();
      print("Response body data: $responseBody");
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


  Future<void> sendEmailReporterforEditLeavefromHR(
      BuildContext context,
      int leaveId,
      LeaveDataForHR leaveData,
      String selectedOption,
      String employeeTypeName,
      String employeeId,
      String employeeName,
      String employeeEmail,
      String employeeReporterEmail,
      String employeeReporterName,
      String editedApplyDate,
      String editedFromDate,
      String editedEndDate,
      String editedApplideDay,
      String editedApplideDayChange,
      ) async {


    var headers = {
      'Authorization': '${BaseUrl.authorization}',
    };

    var withpay = (selectedOption == "0") ? "withoutpay" : "withpay";

    var request = http.MultipartRequest('POST', Uri.parse('${BaseUrl.baseUrl}/api/Email/Send'));
    request.fields.addAll({
      'ToEmail': '${leaveData.empEmail}', // Use reportToEmail here
      'Subject': '${leaveData.reportToEmpName} Edit & Approved your ${leaveData.typeName} Application',
      'Body': '''Dear ${leaveData.empName},
      
      \nI hope this message finds you well. ${leaveData.reportToEmpName} Edit & Approved your Application ${leaveData.empName} Apply to request ${leaveData.typeName} from $editedFromDate to $editedEndDate due to $editedApplideDayChange Days PayType $withpay.
      
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
        Text('His/Har PayType: $selectedOption'),
        Text('leaveId: ${widget.leaveId}'),
      ],
    );
  }
}