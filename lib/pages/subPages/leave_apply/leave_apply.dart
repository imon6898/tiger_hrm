// ignore_for_file: prefer_const_constructors, prefer_final_fields, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:intl/intl.dart';
import 'package:tiger_erp_hrm/Coustom_widget/coustom_text%20field.dart';
import 'package:tiger_erp_hrm/LoginApiController/loginController.dart';
import '../../../Coustom_widget/fileSelector.dart';
import 'components/getLeaveInfo_model.dart';




class LeaveApplyPage extends StatefulWidget {
  final String userName;
  final String empCode;
  final String companyID;
  final String companyName;
  final int gradeValue;
  final int gender;
  //final String token;
  const LeaveApplyPage({Key? key,
    required this.userName,
    required this.empCode,
    required this.companyID,
    required this.companyName,
    required this.gradeValue,
    required this.gender,
    //required this.token,
  }) : super(key: key);

  @override
  State<LeaveApplyPage> createState() => _LeaveApplyPageState();
}
List<String> options = ['Active', 'Inactive'];
class _LeaveApplyPageState extends State<LeaveApplyPage> {

  bool isFetchingDataGetLeaveInfo = true;
  List<GetLeaveInfoModels1> getLeaveInfoLists = [];
  List<GetLeaveInfoStatusModels3> getLeaveInfoStatus3 = [];

  SingleValueDropDownController itemController = SingleValueDropDownController();
  FocusNode searchFocusNode = FocusNode();
  FocusNode textFieldFocusNode = FocusNode();
  List<DropDownValueModel> periodList = [];
  late String selectedCategoryId = "";

  TextEditingController employeeIdController = TextEditingController();
  TextEditingController employeeNameController = TextEditingController();
  TextEditingController designationController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController empMailController = TextEditingController();

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
  bool isExpandedYourDetails = false;
  bool isExpandedApplyTo = false;
  bool isExpandedApplyToSup = false;
  bool isExpandedDutieswillbeperformedby = false;
  bool isExpandedApplication = false;
  List<GetLeaveInfoModel> getLeaveInfoList = [];


  TextEditingController applyToEmployeeIdController = TextEditingController();
  TextEditingController applyToEmployeeNameController = TextEditingController();
  TextEditingController applyToEmployeedesignationController = TextEditingController();
  TextEditingController applyToEmployeeReportToEmailController = TextEditingController();

  TextEditingController applyToEmployeeIdSupController = TextEditingController();
  TextEditingController applyToEmployeeNameSupController = TextEditingController();
  TextEditingController applyToEmployeedesignationSupController = TextEditingController();
  TextEditingController applyToEmployeeRecommendToEmailSupController = TextEditingController();

  TextEditingController dutiesEmployeeIdController = TextEditingController();
  TextEditingController dutiesEmployeeNameController = TextEditingController();
  TextEditingController dutiesEmployeeDesignationController = TextEditingController();


  DateTime? parseApiDate(String dateString) {
    if (dateString == "0001-01-01T00:00:00") {
      return null; // Return null for the special case
    }
    return DateTime.parse(dateString);
  }


  void fetchEmployeeData() async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': '${BaseUrl.authorization}',
    };

    var response = await http.get(
      Uri.parse(
        '${BaseUrl.baseUrl}/api/${v.v1}/GetEmployment/${widget.empCode}/${widget.companyID}',
      ),
      headers: headers,
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        // Assuming you want the first item from the list
        Map<String, dynamic> firstItem = data[0];
        setState(() {
          employeeIdController.text = firstItem['empCode'] ?? '';
          employeeNameController.text = firstItem['empName'] ?? '';
          designationController.text = firstItem['designation'] ?? '';
          departmentController.text = firstItem['department'] ?? '';
          empMailController.text = firstItem['empMail'] ?? '';

          applyToEmployeeIdController.text = firstItem['reportTo'] ?? '';
          applyToEmployeeNameController.text = firstItem['reportToEmpName'] ?? '';
          applyToEmployeedesignationController.text = firstItem['reportToDesignation'] ?? '';
          applyToEmployeeReportToEmailController.text = firstItem['reportToEmail'] ?? '';

          applyToEmployeeIdSupController.text = firstItem['recommendTo'] ?? '';
          applyToEmployeeNameSupController.text = firstItem['recommendToEmpName'] ?? '';
          applyToEmployeedesignationSupController.text = firstItem['recommendToDesignation'] ?? '';
          applyToEmployeeRecommendToEmailSupController.text = firstItem['recommendToEmail'] ?? '';
        });
      }
    } else {
      print('Failed to fetch employee data: ${response.reasonPhrase}');
    }
  }


  Future<void> submitLeaveApplication(int leaveTypeId,selectedLeaveTypeName, List<File> selectedFiles) async {
    final uri = Uri.parse('${BaseUrl.baseUrl}/api/${v.v1}/leave/leave-apply');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': '${BaseUrl.authorization}',
    };

    // Check if recommendTo is null or not
    final grandtype = applyToEmployeeIdSupController.text.isEmpty ? "2" : "0";

    final toEmail = applyToEmployeeRecommendToEmailSupController.text.isNotEmpty
        ? applyToEmployeeRecommendToEmailSupController.text
        : applyToEmployeeReportToEmailController.text;

    final toEmailName = applyToEmployeeNameSupController.text.isNotEmpty
        ? applyToEmployeeNameSupController.text
        : applyToEmployeeNameController.text;

    print('toEmail: $toEmail');
    print('toEmailName: $toEmailName');

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
      "grandtype": grandtype,
      //"yyyymmdd": _applyDateController.text,
      "withpay": currentOptions == 'Active' ? "1" : "0",
      "appType": "0",
      "companyID": widget.companyID,
      "applyTo": applyToEmployeeIdController.text,
      "reason": _reasonController.text,
      "emgContructNo": _emergencyContactNoController.text,
      "emgAddress": _emergencyAddressController.text,
      //"userName": employeeNameController.text,
      //"authorityEmpcode": "0",
      "recommendTo": applyToEmployeeIdSupController.text,

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
    print('Request Body: ${requestBody}');

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

        await sendEmailforLeaveApply(
            employeeNameController.text,
            employeeIdController.text,
            applyToEmployeeNameSupController.text,
            applyToEmployeeRecommendToEmailSupController.text,

            toEmail,
            toEmailName,

            applyToEmployeeNameController.text,
            applyToEmployeeReportToEmailController.text,

            dutiesEmployeeNameController.text,
            _reasonController.text,
            _fromDateController.text,
            _endDateController.text,
            int.parse(updateLeaveDuration.text),
            selectedLeaveTypeName,
            _selectedFiles);

        print("sendEmail: ${await sendEmailforLeaveApply}");

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

  List<File> _selectedFiles = [];

  Future<void> sendEmailforLeaveApply(
      employeeNameController,
      employeeIdController,
      applyToEmployeeNameSupController,
      applyToEmployeeRecommendToEmailSupController,

      toEmail,
      toEmailName,
      applyToEmployeeNameController,
      applyToEmployeeReportToEmailController,

      dutiesEmployeeNameController,
      _reasonController,
      _fromDateController,
      _endDateController,
      updateLeaveDuration,
      selectedLeaveTypeName,
      List<File> attachments
      ) async {

    print("toEmailsent:$toEmail");

    var headers = {
      'Authorization': '${BaseUrl.authorization}',
    };
    var request = http.MultipartRequest('POST', Uri.parse('${BaseUrl.baseUrl}/api/Email/Send'));
    request.fields.addAll({
      'ToEmail': toEmail,
      'Subject': '$selectedLeaveTypeName Application',
      'Body': '''Dear $toEmailName,
      
      \nI hope this message finds you well. $employeeNameController(ID: $employeeIdController) Apply to request $selectedLeaveTypeName from $_fromDateController to $_endDateController due to $updateLeaveDuration Days. $_reasonController.
      
      \nThank you for your understanding and support. Please let me know if there are any additional steps I should take.
      
      \nBest regards,
      \nDS HRMS''',
    });
    for (var attachment in attachments) {
      request.files.add(await http.MultipartFile.fromPath('Attachments', attachment.path));
    }

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }


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
      final duration = endDate!.difference(fromDate!).inDays + 1;
      updateLeaveDuration.text = '$duration';
    } else {
      updateLeaveDuration.text = '';
    }
  }

  String? selectedLeaveType;
  bool isDropdownVisible = false;

  Future<void> fetchLeaveTypes() async {
    try {
      var url = '${BaseUrl.baseUrl}/api/${v.v1}/leave/get-leave-type/${widget.gradeValue}/${widget.gender}';
      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': '${BaseUrl.authorization}',
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

  Future<void> fetchGetLeaveInfo() async {
    try {
      var headers = {
        'Authorization': '${BaseUrl.authorization}',
      };
      var request = http.Request(
        'GET',
        Uri.parse('${BaseUrl.baseUrl}/api/${v.v1}/leave/Get-Leave-Info/${widget.empCode}/${widget.companyID}'),
      );
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      setState(() {
        isFetchingDataGetLeaveInfo = true;
      });

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        print("this is get Data from: $responseBody");

        final List<dynamic> data = json.decode(responseBody);

        setState(() {
          getLeaveInfoList = data.map((item) {
            return GetLeaveInfoModel(
              id: item['id'] ?? 0,
              applyDate: item['applicationDate'] ?? '',
              startDate: item['startDate'] ?? '',
              endDate: item['endDate'] ?? '',
              days: item['accepteDuration'].toString(),
            );
          }).toList();
          isFetchingDataGetLeaveInfo = false;
        });
      } else {
        isFetchingDataGetLeaveInfo = false;
        throw Exception('Failed to load data from the API');
      }
    } catch (error) {
      print('Error fetching data: $error');
      // Handle the error appropriately, e.g., show a snackbar or display an error message.
    }
  }

  Future<void> fetchGetLeaveInfo1(String selectedCategoryId) async {
    try {
      var headers = {
        'Authorization': '${BaseUrl.authorization}',
      };
      var request = http.Request(
        'GET',
        Uri.parse('${BaseUrl.baseUrl}/api/${v.v1}/leave/Get-Leave-Status/${widget.empCode}/${widget.companyID}/$selectedCategoryId'),
      );
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      setState(() {
        isFetchingDataGetLeaveInfo = true;
      });

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        print("this is get Data from:: $responseBody");

        final List<dynamic> dataGetLeaveInfo = json.decode(responseBody);

        setState(() {
          getLeaveInfoLists = dataGetLeaveInfo.map((item) {
            return GetLeaveInfoModels1(
              typeName: item['typeName'] ?? '',
              tOtalLeave: item['tOtalLeave'].toString(),
              maxDays: item['maxDays'].toString(),
              accepteDuration: item['accepteDuration'].toString(),
              balance: item['balance'].toString(),
            );
          }).toList();
          isFetchingDataGetLeaveInfo = false;
        });
      } else {
        isFetchingDataGetLeaveInfo = false;
        throw Exception('Failed to load dataGetLeaveInfo from the API');
      }
    } catch (error) {
      print('Error fetching dataGetLeaveInfo: $error');
      // Handle the error appropriately, e.g., show a snackbar or display an error message.
    }
  }

  Future<void> fetchPeriodList() async {
    var headers = {
      'Authorization': '${BaseUrl.authorization}',
    };

    var request = http.Request(
      'GET',
      Uri.parse('${BaseUrl.baseUrl}/api/${v.v1}/salary/get-period-list/1'),
    );
    request.headers.addAll(headers);

    try {
      http.Response response = await http.Response.fromStream(
        await http.Client().send(request),
      );
      if (response.statusCode == 200) {
        // Parse the JSON response
        List<dynamic> data = jsonDecode(response.body);

        // Extract periodName and id from each item in the response
        List<DropDownValueModel> fetchedList = data
            .map((item) => DropDownValueModel(
          name: item['periodName'],
          value: item['id'].toString(),
        ))
            .toList();

        setState(() {
          periodList = fetchedList;
        });
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
        print(response.reasonPhrase);
      }
    } catch (error) {
      print('Error during API request: $error');
    }
  }

  Future<void> fetchGetLeaveInfoStatus3() async {
    try {
      var headers = {
        'Authorization': '${BaseUrl.authorization}',
      };
      var request = http.Request(
        'GET',
        Uri.parse('${BaseUrl.baseUrl}/api/${v.v1}/leave/getLeaveInfoStatus/${widget.empCode}/${widget.companyID}'),
      );
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      setState(() {
        isFetchingDataGetLeaveInfo = true;
      });

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        print("this is get Data from:: $responseBody");

        final List<dynamic> dataGetLeaveInfo = json.decode(responseBody);

        setState(() {
          getLeaveInfoStatus3 = dataGetLeaveInfo.map((item) {
            return GetLeaveInfoStatusModels3(
              typeName: item['typeName'] ?? '',
              applicationDate: item['applicationDate'] ?? '',
              accepteDuration: item['accepteDuration'].toString(),
              remarks: item['remarks'] ?? '',
              empName: item['empName'] ?? '',
              status: item['status'] ?? '',
            );
          }).toList();
          isFetchingDataGetLeaveInfo = false;
        });
      } else {
        isFetchingDataGetLeaveInfo = false;
        throw Exception('Failed to load dataGetLeaveInfo from the API');
      }
    } catch (error) {
      print('Error fetching dataGetLeaveInfo: $error');
      // Handle the error appropriately, e.g., show a snackbar or display an error message.
    }
  }

  @override
  void initState() {
    super.initState();
    fetchLeaveTypes();

    fetchEmployeeData();
    fetchGetLeaveInfo();

    fetchGetLeaveInfo1(selectedCategoryId);
    fetchPeriodList();
    fetchGetLeaveInfoStatus3();

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
          'Leave Apply',
          textAlign: TextAlign.center,
        ),
    ),
      body: SingleChildScrollView(
          child: Container(
            color: Color(0xfff7f9fd),
            child: Column(
             children: [
                SizedBox(height: 10,),

               GestureDetector(
                 onTap: () {
                   setState(() {
                     isExpandedApplyTo  = !isExpandedApplyTo ;
                   });
                 },
                 child: Padding(
                   padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                   child: Container(
                     height: 50,
                     width: MediaQuery.of(context).size.width,
                     decoration: BoxDecoration(
                       border: Border.all(width: 2),
                       borderRadius: BorderRadius.circular(10),
                     ),
                     child: Center(
                       child: Row(
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
                     ),
                   ),
                 ),
               ),

               Padding(
                 padding: const EdgeInsets.only(top: 8.0),
                 child: AnimatedContainer(
                   //color: Colors.yellow,
                   duration: Duration(milliseconds: 700),
                   height: isExpandedApplyTo  ? 320 : 0,
                   width: MediaQuery.of(context).size.width,
                   child: isExpandedApplyTo
                       ? SingleChildScrollView(
                     child: Column(
                       children: [

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

                       ],
                     ),
                   )
                       : null,
                 ),
               ),

               GestureDetector(
                 onTap: () {
                   setState(() {
                     isExpandedApplication  = !isExpandedApplication ;
                   });
                 },
                 child: Padding(
                   padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                   child: Container(
                     height: 50,
                     width: MediaQuery.of(context).size.width,
                     decoration: BoxDecoration(
                       border: Border.all(width: 2),
                       borderRadius: BorderRadius.circular(10),
                     ),
                     child: Center(
                       child: Row(
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
                     ),
                   ),
                 ),
               ),

               Padding(
                 padding: const EdgeInsets.only(top: 8.0),
                 child: AnimatedContainer(
                   //color: Colors.yellow,
                   duration: Duration(milliseconds: 800),
                   height: isExpandedApplication  ? 500 : 0,
                   width: MediaQuery.of(context).size.width,
                   child: isExpandedApplication
                       ? SingleChildScrollView(
                         child: Column(
                           children: [

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
                                   ? '${(endDate!.difference(fromDate!).inDays + 1)} ${endDate!.difference(fromDate!).inDays == 0 ? 'day' : 'days'}'
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

                             Padding(
                               padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                               child: FileSelector(
                                 onFilesSelected: (files) {
                                   print('Attached file(s): $files');
                                   _selectedFiles = files;
                                   // Handle the selected files here
                                   // You can update the state or perform any other action as needed
                                 },
                               ),
                             ),


                           ],
                         ),
                       )
                       : null,
                 ),
               ),

               GestureDetector(
                 onTap: () {
                   setState(() {
                     isExpandedDutieswillbeperformedby  = !isExpandedDutieswillbeperformedby ;
                   });
                 },
                 child: Padding(
                   padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                   child: Container(
                     height: 50,
                     width: MediaQuery.of(context).size.width,
                     decoration: BoxDecoration(
                       border: Border.all(width: 2),
                       borderRadius: BorderRadius.circular(10),
                     ),
                     child: Center(
                       child: Row(
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
                     ),
                   ),
                 ),
               ),

               Padding(
                 padding: const EdgeInsets.only(top: 8.0),
                 child: AnimatedContainer(
                   //color: Colors.yellow,
                   duration: Duration(milliseconds: 700),
                   height: isExpandedDutieswillbeperformedby ? 320 : 0,
                   width: MediaQuery.of(context).size.width,
                   child: isExpandedDutieswillbeperformedby
                       ? SingleChildScrollView(
                     child: Column(
                       children: [

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

                       ],
                     ),
                   )
                       : null,
                 ),
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
                           int selectedLeaveTypeId = leaveTypes![0]['typeee'] as int;
                           String selectedLeaveTypeName = leaveTypes![0]['typeName'] as String;
                           submitLeaveApplication(selectedLeaveTypeId, selectedLeaveTypeName, _selectedFiles); // Pass _selectedFiles
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
               ),

               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 10),
                 child: Column(
                   children: [
                     Container(
                       height: 100,
                       padding: EdgeInsets.only(left: 0),
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.end,
                         children: [
                           DropDownTextField(
                             textFieldDecoration: InputDecoration(
                               contentPadding: EdgeInsets.symmetric(vertical:10,horizontal: 20),
                               enabledBorder: OutlineInputBorder(
                                 borderSide: BorderSide(width: 2, color: Color(0xFFBCC2C2)),
                               ),
                               disabledBorder: OutlineInputBorder(
                                 borderSide: BorderSide(width: 2, color: Color(0xFFBCC2C2)),
                               ),
                               focusedBorder: OutlineInputBorder(
                                 borderSide: BorderSide(width: 2, color: Colors.blueAccent),
                               ),
                               hintText: 'Select Month',
                               labelText: 'Select Month',
                               border: InputBorder.none,
                             ),

                             controller: itemController,
                             clearOption: false,
                             textFieldFocusNode: textFieldFocusNode,
                             searchFocusNode: searchFocusNode,
                             dropDownItemCount: 4,
                             searchShowCursor: false,
                             enableSearch: true,
                             dropDownList: periodList,
                             onChanged: (val) {
                               // Extract and store the ID from the selected value
                               selectedCategoryId = val.value;
                               print('Selected value: $val');
                               fetchGetLeaveInfo1(selectedCategoryId);
                             },
                           ),
                         ],
                       ),
                     ),
                     Container(
                       width: MediaQuery.of(context).size.width,
                       child: SingleChildScrollView(
                         scrollDirection: Axis.horizontal,
                         child: Padding(
                           padding: const EdgeInsets.symmetric(horizontal: 0.0),
                           child: DataTable(
                             border: TableBorder.all(color: Colors.black),
                             headingRowColor: MaterialStateColor.resolveWith((states) => Colors.blue),
                             columns: [
                               DataColumn(label: Text('#SN')),
                               DataColumn(label: Text('Leave Type')),
                               DataColumn(label: Text('Total')),
                               DataColumn(label: Text('Avalied')),
                               DataColumn(label: Text('Balance')),
                             ],
                             rows: List<DataRow>.generate(
                               getLeaveInfoLists.length,
                                   (index) => DataRow(
                                 cells: [
                                   DataCell(Text((index + 1).toString())),
                                   DataCell(Text(getLeaveInfoLists[index].typeName)),
                                   DataCell(Text(getLeaveInfoLists[index].tOtalLeave.toString())),
                                   DataCell(Text(getLeaveInfoLists[index].accepteDuration.toString())),
                                   DataCell(Text(getLeaveInfoLists[index].balance.toString())),
                                 ],
                               ),
                             ),
                           ),
                         ),
                       ),
                     ),
                   ],
                 ),
               ),

               Padding(
                 padding: const EdgeInsets.all(10),
                 child: SingleChildScrollView(
                   scrollDirection: Axis.horizontal,
                   child: DataTable(
                     border: TableBorder.all(color: Colors.black),
                     headingRowColor: MaterialStateColor.resolveWith((states) => Colors.blue),
                     columns: [
                       DataColumn(label: Text('#SN')),
                       DataColumn(label: Text('Apply Date')),
                       DataColumn(label: Text('Start Date')),
                       DataColumn(label: Text('End Date')),
                       DataColumn(label: Text('Duration')),
                     ],
                     rows: List<DataRow>.generate(
                       getLeaveInfoList.length,
                           (index) => DataRow(
                         cells: [
                           DataCell(Text((index + 1).toString())),
                           DataCell(Text(getLeaveInfoList[index].applyDate != null ? DateFormat("dd-MMM-yyyy").format(DateTime.tryParse(getLeaveInfoList[index].applyDate!) ?? DateTime.now()) : "")),
                           DataCell(Text(getLeaveInfoList[index].startDate != null ? DateFormat("dd-MMM-yyyy").format(DateTime.tryParse(getLeaveInfoList[index].startDate!) ?? DateTime.now()) : "")),
                           DataCell(Text(getLeaveInfoList[index].endDate != null ? DateFormat("dd-MMM-yyyy").format(DateTime.tryParse(getLeaveInfoList[index].endDate!) ?? DateTime.now()) : "")),
                           DataCell(Text(getLeaveInfoList[index].days != null ? getLeaveInfoList[index].days.toString() : "")),
                         ],
                       ),
                     ),
                   ),
                 ),
               ),

               /*GestureDetector(
                 onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => TestWidget(
                     empCode: widget.empCode,
                     companyID: widget.companyID,
                   )));
                 },
                 child: Text("imon"),
               ),*/


               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                 child: SingleChildScrollView(
                   scrollDirection: Axis.horizontal,
                   child: DataTable(
                     border: TableBorder.all(color: Colors.black),
                     headingRowColor: MaterialStateColor.resolveWith((states) => Colors.blue),
                     columns: [
                       DataColumn(label: Text('#SN')),
                       DataColumn(label: Text('Leave Type')),
                       DataColumn(label: Text('Application Date')),
                       DataColumn(label: Text('Duration')),
                       DataColumn(label: Text('Remark')),
                       DataColumn(label: Text('Last Position')),
                       DataColumn(label: Text('Status')),
                     ],
                     rows: List<DataRow>.generate(
                       getLeaveInfoStatus3.length,
                           (index) => DataRow(
                         cells: [
                           DataCell(Text((index + 1).toString())),
                           DataCell(Text(getLeaveInfoStatus3[index].typeName)),
                           DataCell(Text(DateFormat("dd-MMM-yyyy").format(DateTime.parse(getLeaveInfoStatus3[index].applicationDate)))),
                           //DataCell(Text(getLeaveInfoStatus3[index].applicationDate)),
                           DataCell(Text(getLeaveInfoStatus3[index].accepteDuration.toString())),
                           DataCell(Text(getLeaveInfoStatus3[index].remarks)),
                           DataCell(Text(getLeaveInfoStatus3[index].empName)),
                           DataCell(Text(getLeaveInfoStatus3[index].status)),
                         ],
                       ),
                     ),
                   ),
                 ),
               ),


        ],
      ),
          )),
    );
  }

}

class GetLeaveInfoModels1 {
  final String typeName;
  final String tOtalLeave;
  final String maxDays;
  final String accepteDuration;
  final String balance;

  GetLeaveInfoModels1({
    required this.typeName,
    required this.tOtalLeave,
    required this.maxDays,
    required this.accepteDuration,
    required this.balance,
  });

  factory GetLeaveInfoModels1.fromJson(Map<String, dynamic> json) {
    return GetLeaveInfoModels1(
      typeName: json['typeName'] ?? '',
      tOtalLeave: json['tOtalLeave'] ?? '',
      maxDays: json['maxDays'] ?? '',
      accepteDuration: json['accepteDuration'] ?? '',
      balance: json['balance'].toString(),
    );
  }

  @override
  String toString() {
    return 'LeaveDatafor{'
        'typeName: $typeName, '
        'tOtalLeave: $tOtalLeave, '
        'maxDays: $maxDays, '
        'accepteDuration: $accepteDuration, '
        'balance: $balance, ';
  }
}
