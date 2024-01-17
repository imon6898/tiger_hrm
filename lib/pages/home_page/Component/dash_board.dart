import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tiger_erp_hrm/LoginApiController/loginController.dart';
import 'package:tiger_erp_hrm/pages/authPages/get_employee_data/get_employeement_data.dart';
import 'package:tiger_erp_hrm/pages/subPages/apply_attendence/apply_attendance.dart';
import 'package:tiger_erp_hrm/pages/subPages/approve_attend.dart';
import 'package:tiger_erp_hrm/pages/subPages/change_pass/changepass.dart';
import 'package:tiger_erp_hrm/pages/subPages/leave_apply/leave_apply.dart';
import 'package:tiger_erp_hrm/pages/subPages/leave_approve/ApproveLeaves.dart';
import 'package:tiger_erp_hrm/pages/subPages/leave_approve_by_hr/leaveApproveByHr.dart';
import 'package:tiger_erp_hrm/pages/subPages/my_tasks.dart';
import 'package:tiger_erp_hrm/test2.dart';

import '../../../Coustom_widget/neumorphic_button.dart';
import '../../subPages/leavefortour/leaveForTour.dart';
import '../../subPages/myinfo/my_info.dart';
import '../../subPages/report_page/selecting_report.dart';
import '../../subPages/sup_leave_approval/supervisor_leave_approval.dart';
// import 'package:google_fonts/google_fonts.dart';

class DashBoard extends StatefulWidget {
  final String userName;
  final String empCode;
  final String companyID;
  final String companyName;
  final int gradeValue;
  final int gender;
  final String empName;
  final String reportTo;
  final Position location;
  //final String token;

  const DashBoard({
    super.key,
    required this.userName,
    required this.empCode,
    required this.companyID,
    required this.companyName,
    required this.empName,
    required this.reportTo,
    required this.location,
    required this.gradeValue,
    required this.gender,
    //required this.token,
  });

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  List _photos = [
    Data(image: 'lib/images/A1.png', text: 'Apply Attendance'),
    Data(image: 'lib/images/A2.png', text: 'Approve Attend. by HR'),
    Data(image: 'lib/images/A2.png', text: 'Report'),
    Data(image: 'lib/images/A3.png', text: 'Leave Apply'),
    Data(image: 'lib/images/A4.png', text: 'Leave Approval'),
    Data(image: 'lib/images/A5.png', text: 'Supervisor Leave Approval'),
    Data(image: 'lib/images/A6.png', text: 'Leave Approval by HR'),
    Data(image: 'lib/images/A8.png', text: 'Leave for Tour'),
    Data(image: 'lib/images/mytaskicon.png', text: 'My Tasks'),
    Data(image: 'lib/images/A7.png', text: 'Change Password'),
    Data(image: 'lib/images/profilicon.png', text: 'Profile', ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff162b4a),
        leading: Container(
          margin: const EdgeInsetsDirectional.fromSTEB(10, 5, 5, 5),
          child: CircleAvatar(
            backgroundImage: AssetImage(
              'lib/images/ForeBgIcon.png',
            ),
            radius: 30,
          ),
        ),
        title: InkWell(
          onTap: () {
            // Show your message box here
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Container(
                    height: 100,
                      child: Center(
                          child: Text(widget.empName,
                            style: TextStyle(fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ))),
                );
              },
            );
          },
          child: Text(
            widget.empName,
            style: TextStyle(color: Colors.white, fontSize: 30, fontFamily: 'Kanit'),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: Container(
        color: Color(0xffe9f0fd),
        child: GridView.builder(
            itemCount: _photos.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, ),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: NeumorphicButton(
                  imagePath: _photos[index].image,
                  buttonText: _photos[index].text,
                  onTap: () {
                    // Handle item tap here
                    switch (_photos[index].text) {
                      case 'Apply Attendance':
                        Future.delayed(Duration(milliseconds: 60), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AttendancePage(
                               userName: widget.userName,
                               empCode: widget.empCode,
                               companyID: widget.companyID,
                               companyName: widget.companyName,
                               location: widget.location,
                            )),
                          );
                        });
                        break;
                      case 'Approve Attend. by HR':
                        Future.delayed(Duration(milliseconds: 60), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ApproveAttendPage()),
                          );
                        });

                        break;
                      case 'Report':
                        Future.delayed(Duration(milliseconds: 60), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ReportPage(
                              userName: widget.userName,
                              empCode: widget.empCode,
                              companyID: widget.companyID,
                              companyName: widget.companyName,
                            )),
                          );
                        });
                        break;
                      case 'Leave Apply':
                        Future.delayed(Duration(milliseconds: 60), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LeaveApplyPage(
                              userName: widget.userName,
                              empCode: widget.empCode,
                              companyID: widget.companyID,
                              companyName: widget.companyName,
                                gradeValue: widget.gradeValue,
                                gender: widget.gender,
                              //token: widget.token,
                            ),
                            ),
                          );
                        });

                        break;
                      case 'Leave Approval':
                        Future.delayed(Duration(milliseconds: 60), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ApproveLeavesPage(
                              userName: widget.userName,
                              empCode: widget.empCode,
                              companyID: widget.companyID,
                              companyName: widget.companyName,
                              //token: widget.token,
                            )),
                          );
                        });

                        break;
                      case 'Supervisor Leave Approval':
                        Future.delayed(Duration(milliseconds: 60), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SupApproveLeavesPage(
                              userName: widget.userName,
                              empCode: widget.empCode,
                              companyID: widget.companyID,
                              companyName: widget.companyName,
                              //token: widget.token,
                            )),
                          );
                        });

                        break;
                      case 'Leave Approval by HR':
                        Future.delayed(Duration(milliseconds: 60), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LeaveApproveByHr(
                              userName: widget.userName,
                              empCode: widget.empCode,
                              companyID: widget.companyID,
                              companyName: widget.companyName,
                              reportTo: widget.reportTo,
                            )),
                          );
                        });
                        break;

                      case 'Leave for Tour':
                        Future.delayed(Duration(milliseconds: 60), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LeaveforTour()),
                          );
                        });
                        break;

                      case 'My Tasks':
                        Future.delayed(Duration(milliseconds: 60), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MyTasksPage()),
                          );
                        });
                        break;
                      case 'Change Password':
                        Future.delayed(Duration(milliseconds: 60), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ChangePass(
                              userName: widget.userName,
                              empCode: widget.empCode,
                              companyID: widget.companyID,
                              companyName: widget.companyName,
                            )),
                          );
                        });
                        break;
                      case 'Profile':
                        Future.delayed(Duration(milliseconds: 60), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MyInfo()),
                          );
                        });
                        break;

                    // Add cases for other pages as needed
                    };
                  },
                ),
              );
            }),
      ),
      endDrawer: Drawer(
        child: Column(
          children: [
            Image.asset(
              'lib/images/TigerHRMS.png',
              width: 300,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: GestureDetector(
                onTap: () {
                  // Call the logoutUser method from LoginController
                  LoginController().logoutUser();
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.logout,
                      size: 30,
                      color: Color(0xff04a2e3),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Log Out',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Readex Pro',
                        fontWeight: FontWeight.w400,
                        color: Color(0xff04a2e3),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Data {
  String image;
  String text;

  Data({required this.image,required this.text});

}