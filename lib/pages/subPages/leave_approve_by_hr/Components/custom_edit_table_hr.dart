
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:tiger_erp_hrm/Coustom_widget/custom_text_field2.dart';
import 'package:tiger_erp_hrm/LoginApiController/loginController.dart';
import 'package:tiger_erp_hrm/pages/subPages/leave_approve_by_hr/Model/model.dart';
import 'package:tiger_erp_hrm/test.dart';
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

  CustomEditTableHr({//required this.token,
    required this.userName,
    required this.empCode,
    required this.companyID,
    required this.companyName,
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






  Future<void> fromSelectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        endDate = picked;
        editendDateController.text = picked.toString().split(" ")[0];
        _updateLeaveDuration(); // Calculate and update Leave Duration
      });
    }
  }

  void _updateLeaveDuration() {
    if (fromDate != null && endDate != null) {
      final duration = endDate!.difference(fromDate!).inDays;
      editApplideDayChangeController.text = '$duration';
    } else {
      editApplideDayChangeController.text = '';
    }
  }


  Future<void> fetchPendingToApproveLeave(int leaveId, String requestFrom, String leaveDate, String startDate, String endDate) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': BaseUrl.authorization,
    };

    var request = http.Request(
      'POST',
      Uri.parse('${BaseUrl.baseUrl}/api/v1/leave/ApproveByHr'),
    );

    request.body = json.encode({
      "id": 0,
      "leaveID": leaveId,
      "empCode": requestFrom, // Include the requestFrom parameter
      "leaveDate": leaveDate, // Include the leaveDate parameter
      "startDate": startDate, // Include the startDate parameter
      "endDate": endDate, // Include the endDate parameter
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
      await fetchGetWaitingLeaveForApprove();
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


  Future<void> fetchCancelLeave(int leaveId, String remark, String statusDate) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': BaseUrl.authorization,
    };

    // Construct the URL
    String apiUrl = '${BaseUrl.baseUrl}/api/v1/leave/CancelByHr/$leaveId';
    Uri requestUri = Uri.parse(apiUrl); // Parse the URL

    print('Request URL: $requestUri'); // Print the URL

    var request = http.Request('POST', requestUri);

    request.body = json.encode({

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
      'Authorization': BaseUrl.authorization,
    };
    var request = http.Request(
      'GET', //${BaseUrl.baseUrl}/api/v1/leave/GetWaitingLeaveForApprove/1/23/${widget.empCode}
      Uri.parse('${BaseUrl.baseUrl}/api/v1/leave/GetLeaveInfoForHrApprove/${widget.companyID}'),
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
            'E.Code': item['empCode'],
            'Name': item['empName'],
            'Department': item['department'],
            'Designation': item['designation'],
            'ApplyDate': item['applicationDate'],
            'StartDate': item['startDate'],
            'EndDate': item['endDate'],
            'LeaveType': item['typeName'],
            'Days': item['accepteDuration'].toString(),
            'PayType': item['withpay'],

            'Reason': item['reason'],
            'EmgContructNo': item['emgContructNo'],
            'LeaveTypedID': item['leaveTypedID'],
            'UnAccepteDuration': item['unAccepteDuration'],
            'ReferanceEmpcode': item['referanceEmpcode'],
            'Grandtype': item['grandtype'],
            'AppType': item['appType'],
            'CompanyID': item['companyID'],
            'ApplyTo': item['applyTo'],
            'EmgAddress': item['emgAddress'],
            'UserName': item['userName'],
            'AuthorityEmpcode': item['authorityEmpcode'],

            'Pending': 'Pending, Recommended', // You can customize this button
            'Cancel': 'Cancel', // You can customize this button
            'Edit': 'Edit', // You can customize this button
            'Print': 'Print', // You can customize this button
          };
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
          const DataColumn(label: Text('E.Code',style: TextStyle(fontWeight: FontWeight.bold),)),
          const DataColumn(label: Text('Name',style: TextStyle(fontWeight: FontWeight.bold),)),
          const DataColumn(label: Text('Department',style: TextStyle(fontWeight: FontWeight.bold),)),
          const DataColumn(label: Text('Designation',style: TextStyle(fontWeight: FontWeight.bold),)),
          const DataColumn(label: Text('Apply Date',style: TextStyle(fontWeight: FontWeight.bold),)),
          const DataColumn(label: Text('Start Date',style: TextStyle(fontWeight: FontWeight.bold),)),
          const DataColumn(label: Text('End Date',style: TextStyle(fontWeight: FontWeight.bold),)),
          const DataColumn(label: Text('LeaveType',style: TextStyle(fontWeight: FontWeight.bold),)),
          const DataColumn(label: Text('Day(s)',style: TextStyle(fontWeight: FontWeight.bold),)),
          const DataColumn(label: Text('PayType',style: TextStyle(fontWeight: FontWeight.bold),)),
          const DataColumn(label: Text('Approve',style: TextStyle(fontWeight: FontWeight.bold),)),
          const DataColumn(label: Text('Cancel',style: TextStyle(fontWeight: FontWeight.bold),)),
          const DataColumn(label: Text('Edit',style: TextStyle(fontWeight: FontWeight.bold),)),
          const DataColumn(label: Text('Print',style: TextStyle(fontWeight: FontWeight.bold),)),
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
                DataCell(Text(data['E.Code'].toString())),
                DataCell(Text(data['Name'].toString())),
                DataCell(Text(data['Department'].toString())),
                DataCell(Text(data['Designation'].toString())),
                DataCell(Text(DateFormat("dd-MMM-yyyy").format(DateTime.parse("${data['ApplyDate']}")))),
                DataCell(Text(DateFormat("dd-MMM-yyyy").format(DateTime.parse("${data['StartDate']}")))),
                DataCell(Text(DateFormat("dd-MMM-yyyy").format(DateTime.parse("${data['EndDate']}")))),
                DataCell(Text(data['LeaveType'].toString())),
                DataCell(Text(data['Days'].toString())),
                DataCell(Text(data['PayType'].toString())),
                DataCell(
                  ElevatedButton(
                    onPressed: () {
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
                              decoration: InputDecoration(
                                labelText: (data['E.Code'].toString()),
                                border: const OutlineInputBorder(), // Add a border to the TextField
                              ),
                            ),
                          ],
                        ),
                        confirm: ElevatedButton(
                          onPressed: () {
                            // Retrieve the text entered in the TextFields
                            String requestFrom = data['E.Code'].toString();
                            String applyDate = data['ApplyDate'].toString();
                            String startDate = data['StartDate'].toString();
                            String endDate = data['EndDate'].toString();

                            // Process the data as needed
                            print('Request From: $requestFrom');
                            print('Apply Date: $applyDate');
                            print('Start Date: $startDate');
                            print('End Date: $endDate');

                            // Call the function with the required parameters
                            fetchPendingToApproveLeave(
                              leaveId,
                              requestFrom,
                              applyDate,
                              startDate,
                              endDate,
                            );

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
                      Get.defaultDialog(
                        title: 'Cancel Application',
                        titlePadding: const EdgeInsets.all(5), // Removed const from EdgeInsets.all(5)
                        contentPadding: const EdgeInsets.all(10), // Removed const from EdgeInsets.all(10)
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
                            String remark = remarkController.text;
                            String statusDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now().toUtc());
                            print('Remark: $remark');
                            print("check confirm button is leave Type id $leaveId");
                            fetchCancelLeave(leaveId, remark, statusDate); // Pass statusDate here
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
                      final leaveData = LeaveData(
                        empCode: data['E.Code']?.toString() ?? "",
                        empName: data['Name'].toString(),
                        applyDate: DateFormat("dd-MMM-yyyy").format(DateTime.parse("${data['ApplyDate']}")).toString(),
                        startDate: DateFormat("dd-MMM-yyyy").format(DateTime.parse("${data['StartDate']}")).toString(),
                        endDate: DateFormat("dd-MMM-yyyy").format(DateTime.parse("${data['EndDate']}")).toString(),
                        days: data['Days'].toString(),
                        payType: data['PayType'].toString(),
                        id: data['ID'],
                        reason: data['Reason']?.toString() ?? "", // Add this line
                        emgContructNo: data['EmgContructNo']?.toString() ?? "", // Add this line
                        leaveTypedID: data['LeaveTypedID'], // Add this line
                        unAccepteDuration: data['UnAccepteDuration']?.toString() ?? "", // Add this line
                        referanceEmpcode: data['ReferanceEmpcode']?.toString() ?? "", // Add this line
                        grandtype: data['Grandtype']?.toString() ?? "", // Add this line
                        appType: data['AppType']?.toString() ?? "", // Add this line
                        companyID: data['CompanyID'], // Add this line
                        applyTo: data['ApplyTo']?.toString() ?? "", // Add this line
                        emgAddress: data['EmgAddress']?.toString() ?? "", // Add this line
                        userName: data['UserName']?.toString() ?? "", // Add this line
                        authorityEmpcode: data['AuthorityEmpcode']?.toString() ?? "", // Add this line
                      );
                      print(leaveData);
                      handleEditButton(
                        leaveData,
                        data['E.Code'].toString(),
                        data['Name'].toString(),
                        DateFormat("dd-MMM-yyyy").format(DateTime.parse("${data['ApplyDate']}")).toString(),
                        DateFormat("dd-MMM-yyyy").format(DateTime.parse("${data['StartDate']}")).toString(),
                        DateFormat("dd-MMM-yyyy").format(DateTime.parse("${data['EndDate']}")).toString(),
                        data['Days'].toString(),
                        data['Days'].toString(),
                        data['LeaveType'].toString(),
                        data['PayType'].toString(),
                        data['ID'],
                      );
                    },
                    child: const Text("Edit", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                  ),
                ),
                DataCell(
                  ElevatedButton(
                    onPressed: () {
                      // Add your action for "Recommend to" here
                    },
                    child: Row(
                      children: [
                        Icon(Icons.print, color: Colors.white,),
                        Text("Print", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffb4cde3),
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
      LeaveData leaveData,
      String employeeId,
      String employeeName,
      String applyDateController,
      String fromDateController,
      String endDateController,
      String applideDayController,
      String applideDayChangeController,
      String leaveType,
      String payType,
      int leaveId,
      )
  {
    print("LeaveData properties:");
    print("EmpCode: ${leaveData.empCode}");
    print("EmpName: ${leaveData.empName}");
    print("ApplyDate: ${leaveData.applyDate}");
    print("StartDate: ${leaveData.startDate}");
    print("EndDate: ${leaveData.endDate}");
    print("Days: ${leaveData.days}");
    print("PayType: ${leaveData.payType}");
    print("ID: ${leaveData.id}");
    // Add more properties as needed...

    editEmployeeId.text = employeeId;
    editEmployeeName.text = employeeName;
    editapplyDateController.text = applyDateController;
    editfromDateController.text = fromDateController;
    editendDateController.text = endDateController;
    editApplideDayController.text = applideDayController;
    editApplideDayChangeController.text = applideDayChangeController;

    editLeaveTypeController.text = leaveType;
    editEmployeeId.text = employeeId;
    editEmployeeName.text = employeeName;
    editapplyDateController.text = applyDateController;
    editfromDateController.text = fromDateController;
    editendDateController.text = endDateController;
    editApplideDayController.text = applideDayController;
    editApplideDayChangeController.text = applideDayChangeController;

    editLeaveTypeController.text = leaveType;

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

                            String employeeId = editEmployeeId.text;
                            String editedApplyDate = editapplyDateController.text;
                            String editedFromDate = editfromDateController.text;
                            String editedEndDate = editendDateController.text;
                            String editedApplideDay = editApplideDayController.text;
                            String editedApplideDayChange = editApplideDayChangeController.text;

                            // Print or use the values as needed
                            print('Employee Id: $employeeId');
                            print('Edited Apply Date: $editedApplyDate');
                            print('Edited From Date: $editedFromDate');
                            print('Edited End Date: $editedEndDate');
                            print('Edited Applied Day: $editedApplideDay');
                            print('Edited Accepted Day: $editedApplideDayChange');
                            print('Selected Option: $selectedOption');

                            await fetchUpdateAndApproveByHr(

                              context,
                              leaveId,
                              employeeId,
                              editedApplyDate,
                              editedFromDate,
                              editedEndDate,
                              editedApplideDay,
                              editedApplideDayChange,
                              leaveData,
                              selectedOption,
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
      BuildContext context, // make sure to pass the context
      int leaveId,
      String editEmployeeId,
      String editedApplyDate,
      String editedFromDate,
      String editedEndDate,
      String editedApplideDay,
      String editedApplideDayChange,
      LeaveData leaveData,
      String selectedOption,
      ) async {
    final String updateUrl = '${BaseUrl.baseUrl}/api/v1/leave/UpdateAndApproveByHr';

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': BaseUrl.authorization,
    };

    final formattedStartDate = DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(DateTime.parse(editedFromDate));
    final formattedEndDate = DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(DateTime.parse(editedEndDate));
    final formattedApplicationDate = DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(DateTime.parse(editedApplyDate));



    var requestBody = {
      // "id": leaveId,
      // "empCode": editEmployeeId,
      // "startDate": "2022-03-12T06:38:35.543Z",//editedFromDate, // Use actual fromDate
      // "endDate": "2022-03-12T06:38:35.543Z",//editedEndDate, // Use actual endDate
      // "applicationDate": "2022-03-12T06:38:35.543Z",//editedApplyDate,  // Use actual applyDate
      // "accepteDuration": int.parse(editedApplideDayChange),
      // "leaveTypedID": leaveData.leaveTypedID,
      // "unAccepteDuration": int.parse(editedApplideDay),
      // "referanceEmpcode": widget.empCode, // Assuming widget.empCode is available
      // "grandtype": int.parse(leaveData.grandtype),
      // "yyyymmdd": "string",
      // "withpay": withpay, // Use actual withpay value
      // "appType": leaveData.appType,
      // "companyID": widget.companyID,
      // "applyTo": leaveData.applyTo,
      // "reason": leaveData.reason,
      // "emgContructNo": leaveData.emgContructNo,
      // "emgAddress": leaveData.emgAddress,
      // "userName": leaveData.userName,
      // "authorityEmpcode": leaveData.authorityEmpcode,


      "id": leaveId,
      "empCode": editEmployeeId,
      "startDate": formattedStartDate,//"2022-03-12T06:38:35.543Z",
      "endDate": formattedStartDate,//"2022-03-12T06:38:35.543Z",
      "applicationDate": formattedStartDate,//"2022-03-12T06:38:35.543Z",
      "accepteDuration": int.parse(editedApplideDayChange),
      "leaveTypedID": leaveData.leaveTypedID,
      "unAccepteDuration": int.parse(editedApplideDay),
      "referanceEmpcode": leaveData.empCode,
      "grandtype": leaveData.grandtype,
      "yyyymmdd": "string",
      "withpay": selectedOption,
      "appType": leaveData.appType,
      "companyID": widget.companyID,
      "applyTo": leaveData.applyTo,
      "reason": leaveData.reason,
      "emgContructNo": leaveData.emgContructNo,
      "emgAddress": leaveData.emgAddress,
      "userName": leaveData.userName,
      "authorityEmpcode": widget.empCode,
    };

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