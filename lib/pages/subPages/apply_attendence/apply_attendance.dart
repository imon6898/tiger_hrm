// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:math' as math;
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
  final Position location;
  const AttendancePage(
      {
        super.key,
        required this.empCode,
        required this.companyID,
        required this.companyName,
        required this.userName,
        required this.location
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
          '${BaseUrl.baseUrl}/api/${v.v1}/GetEmployment/${widget.empCode}/${widget.companyID}'),
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
      backgroundColor: Color(0xfff7f9fd),
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(30, 0, 20, 5),
                      child: Text(
                        'Remarks',
                        style: TextStyle(
                          fontFamily: 'Readex Pro',
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(30, 0, 20, 0),
                    child: TextField(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Color(0xFFBCC2C2)),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Color(0xFFBCC2C2)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.blueAccent),
                        ),
                        hintText: 'Remarks',
                      ),
                      controller: TextEditingController(
                        text: 'Location: ${widget.location?.latitude ?? 0.0}, ${widget.location?.longitude ?? 0.0}',
                      ),
                      readOnly: true,
                    ),
                  ),
                ],
              ),
            ),


            ElevatedButton(
              onPressed: () {
                // Replace officeLat and officeLon with your office location coordinates
                double officeLat = 23.7460321;
                double officeLon = 90.3906891;

                // Calculate the distance between current location and office location
                double distance = calculateDistance(
                  widget.location.latitude,
                  widget.location.longitude,
                  officeLat,
                  officeLon,
                );

                // Check if the distance is less than or equal to 100 meters
                if (distance <= 50.0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Location matches!'),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 3),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Location does not match!'),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              },
              child: Text('Press Me'),
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

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const int earthRadius = 6371000; // Radius of the earth in meters
    double dLat = (lat2 - lat1) * (math.pi / 180.0);
    double dLon = (lon2 - lon1) * (math.pi / 180.0);
    double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1 * (math.pi / 180.0)) *
            math.cos(lat2 * (math.pi / 180.0)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    double distance = earthRadius * c;
    return distance;
  }

}



