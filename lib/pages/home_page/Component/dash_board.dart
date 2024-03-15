import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiger_erp_hrm/LoginApiController/loginController.dart';
import 'package:tiger_erp_hrm/LoginApiController/loginModel.dart';
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
import '../../all_attendance_pages/attendance_pages_dashboard.dart';
import '../../all_leave_pages/leave_pages_dashboard.dart';
import '../../authPages/login_page.dart';
import '../../privacypolicy/privacy_policy.dart';
import '../../subPages/leave_approve/Components/Model/model.dart';
import '../../subPages/leave_approve/Components/leave_approved_api_service/leaveApproved_apiService.dart';
import '../../subPages/leavefortour/leaveForTour.dart';
import '../../subPages/myinfo/components/controller_profile/profile_controller.dart';
import '../../subPages/myinfo/my_info.dart';
import '../../subPages/report_page/selecting_report.dart';
import '../../subPages/salaryandpayslip/salary_and_paySlip.dart';
import '../../subPages/sup_leave_approval/supervisor_leave_approval.dart';
import 'package:badges/badges.dart' as custom_badges;


class DashBoard extends StatefulWidget {
  final LoginModel? loginModel;
  final Position? location;

  const DashBoard({
    Key? key,
    this.loginModel,
    this.location,
  }) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ProfileController profileController = Get.put(ProfileController());
  final LeaveApprovalController _controller = Get.put(LeaveApprovalController());


  @override
  void initState() {
    super.initState();
    fetchProfileData();
    // Call your function to fetch data here
    fetchLeaveApprovBadgeData();
    fetchLeaveApprovByHrBadgeData();
    fetchLeaveApprovSupBadgeData();
  }

  void fetchProfileData() {
    // Extract empCode from loginModel or any other source you have
    String empCode = widget.loginModel?.empCode ?? ''; // Assuming empCode is available in loginModel

    // Call fetchProfile method from ProfileController
    profileController.fetchProfile(empCode);
  }

  void fetchLeaveApprovBadgeData() async {
    String companyID = widget.loginModel?.companyId?.toString() ?? '';
    String empCode = widget.loginModel?.empCode ?? '';

    // Call ApiService function
    int leaveDataList = await ApiLeaveApprovBadgeService.fetchGetWaitingLeaveForApprove(
      companyID: companyID,
      empCode: empCode,
    );

    _controller.fetchLeaveApprovalBadgeCount(companyID: companyID, empCode: empCode);
    // Handle your data here, e.g., update state, show in UI
    print(leaveDataList);
  }

  void fetchLeaveApprovByHrBadgeData() async {
    String companyID = widget.loginModel?.companyId?.toString() ?? '';
    String userTypeId = widget.loginModel?.userTypeId?.toString() ?? '';
    String empCode = widget.loginModel?.empCode ?? '';

    // Call ApiService function
    int leaveDataList = await ApiLeaveApprovBadgeService.fetchGetWaitingLeaveForApproveByHr(
      companyID: companyID,
      userTypeId: userTypeId,
      empCode: empCode,
    );

    _controller.fetchLeaveApprovalByHrBadgeCount(companyID: companyID, empCode: empCode, userTypeId: userTypeId);
    // Handle your data here, e.g., update state, show in UI
    print(leaveDataList);
  }

  void fetchLeaveApprovSupBadgeData() async {
    String companyID = widget.loginModel?.companyId?.toString() ?? '';
    String empCode = widget.loginModel?.empCode ?? '';

    // Call ApiService function
    int leaveDataList = await ApiLeaveApprovBadgeService.fetchGetWaitingLeaveForApproveSup(
      companyID: companyID,
      empCode: empCode,
    );

    // Handle your data here, e.g., update state, show in UI
    // Update badge count in the controller
    _controller.fetchLeaveApprovalSupBadgeCount(companyID: companyID, empCode: empCode);
    print(leaveDataList);
  }

  List<Data> _photos = [
    Data(image: 'lib/images/profilicon.png', text: 'Profile'),
    Data(image: 'lib/images/A1.png', text: 'Attendance'),
    Data(image: 'lib/images/A3.png', text: 'Leave'),
    Data(image: 'lib/images/SalarySlipp.png', text: 'Salary & PaySlip'),
    Data(image: 'lib/images/mytaskicon.png', text: 'My Tasks'),
    Data(image: 'lib/images/Privacy&policy.png', text: 'Policy'),
  ];

  @override
  Widget build(BuildContext context) {
    String userName = widget.loginModel?.userName ?? 'N/A';
    String empCode = widget.loginModel?.empCode ?? 'N/A';
    int? companyId = widget.loginModel?.companyId;
    String companyName = widget.loginModel?.companyName ?? 'N/A';
    String empName = widget.loginModel?.empName ?? 'N/A';
    String empMail = widget.loginModel?.empMail ?? 'N/A';
    String reportTo = widget.loginModel?.reportTo ?? 'N/A';
    String recommendToEmail = widget.loginModel?.recommendToEmail ?? 'N/A';
    int? gradeValue = widget.loginModel?.gradeValue;
    int? gender = widget.loginModel?.gender;
    int? userTypeId = widget.loginModel?.userTypeId;
    Position? location = widget.location;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: const Color(0xff162b4a),
        leading: Container(
          margin: const EdgeInsetsDirectional.fromSTEB(10, 5, 5, 5),
          child: CircleAvatar(
            backgroundImage: AssetImage('lib/images/theDailyStariconBlack.png'),
            radius: 30,
          ),
        ),
        title: InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Container(
                    height: 100,
                    child: Center(
                      child: Text(
                        widget.loginModel?.userName ?? "",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
          child: Text(
            userName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontFamily: 'Kanit',
            ),
            textAlign: TextAlign.center,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.menu_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
          ),
        ],
      ),
      body: Container(
        color: Color(0xffe9f0fd),
        child: GridView.builder(
          itemCount: _photos.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: _photos[index].text == 'Profile'
                  ? Obx(() {
                if (profileController.profiles.isNotEmpty &&
                    profileController.profiles[0].photo != null) {
                  return NeumorphicButton(
                    imagePathMemory: profileController.profiles.isNotEmpty && profileController.profiles[0].photo != null
                        ? profileController.profiles[0].photo! // Base64 string
                        : _photos[index].image, // Asset path
                    buttonText: _photos[index].text,
                    onTap: () => _handleButtonTap(_photos[index].text),
                  );


                } else {
                  return NeumorphicButton(
                    imagePathAsset: _photos[index].image,
                    buttonText: _photos[index].text,
                    onTap: () => _handleButtonTap(_photos[index].text),
                  );
                }
              })
                  : _photos[index].text == 'Leave'
                  ? _buildButtonWithBadge(_photos[index], userName, empCode, companyId, companyName, reportTo, gradeValue, gender, userTypeId)
                  : NeumorphicButton(
                imagePathAsset: _photos[index].image,
                buttonText: _photos[index].text,
                onTap: () => _handleButtonTap(_photos[index].text),
              ),
            );
          },
        ),
      ),

    endDrawer: Drawer(
        child: Column(
          children: [
            Image.asset(
              'lib/images/DSHRMSlogo.png',
              width: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.symmetric( horizontal: 10,vertical: 24),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _logout,
                    child: Card(
                      color: Colors.transparent,
                      elevation: 0,
                      child: SizedBox(
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _navigateToChangePassword,
                    child: Card(
                      color: Colors.transparent,
                      elevation: 0,
                      child: SizedBox(
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.change_circle_outlined,
                                size: 30,
                                color: Color(0xff04a2e3),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Change Password',
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
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildButtonWithBadge(Data data, String userName, String empCode, int? companyId, String companyName, String reportTo, int? gradeValue, int? gender, int? userTypeId) {
    return Obx(() {
      int badgeCount = 0;

        switch (data.text) {
          case 'Leave':
            badgeCount = _controller.totalLeaveBadgeCount.value;
            break;
          default:
            break;
        }

        if (badgeCount > 0) {
          return custom_badges.Badge(
            badgeContent: Text('$badgeCount', style: TextStyle(color: Colors.white, fontSize: 18)),
            badgeStyle: BadgeStyle(badgeColor: Colors.red),
            position: BadgePosition.topEnd(top: -8, end: -2),
            child: NeumorphicButton(
              imagePathAsset: data.image,
              buttonText: data.text,
              onTap: () => _handleButtonTap(data.text),
            ),
          );
        } else {
          return NeumorphicButton(
            imagePathAsset: data.image,
            buttonText: data.text,
            onTap: () => _handleButtonTap(data.text),
          );
        }
      },
    );
  }

  void _handleButtonTap(String buttonText) {
    switch (buttonText) {
      case 'Profile':
        _navigateToProfile();
        break;
      case 'Attendance':
        _navigateToAttendance();
        break;
      case 'Leave':
        _navigateToLeave();
        break;
      case 'Salary & PaySlip':
        _navigateToSalaryAndPaySlip();
        break;
      case 'My Tasks':
        _navigateToMyTasks();
        break;
      case 'Policy':
        _navigateToPrivacypolicy();
        break;
    }
  }

  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyInfo(empCode: widget.loginModel?.empCode ?? '',),
      ),
    );
  }

  void _navigateToAttendance() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AttendancePagesDashBoard(
          loginModel: widget.loginModel,
          location: widget.location,
        ),
      ),
    );
  }

  void _navigateToLeave() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LeavePagesDashBoard(
          loginModel: widget.loginModel,
        ),
      ),
    );
  }

  void _navigateToMyTasks() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyTasksPage(),
      ),
    );
  }

  void _navigateToSalaryAndPaySlip() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SalaryAndPaySlip(
          userName: widget.loginModel?.userName ?? '',
          empCode: widget.loginModel?.empCode ?? '',
          companyID: widget.loginModel?.companyId?.toString() ?? '',
          companyName: widget.loginModel?.companyName ?? '',
          gradeValue: widget.loginModel?.gradeValue?.toString() ?? '',
        ),
      ),
    );
  }


  void _navigateToPrivacypolicy() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PrivacyPolicy(),
      ),
    );
  }

  Future<void> _logout() async {
    await Hive.close();
    await Hive.deleteBoxFromDisk('loginData');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Get.offAll(() => LoginPage());
  }

  void _navigateToChangePassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangePass(
          userName: widget.loginModel?.userName ?? '',
          empCode: widget.loginModel?.empCode ?? '',
          companyID: widget.loginModel?.companyId?.toString() ?? '',
          companyName: widget.loginModel?.companyName ?? '',
        ),
      ),
    );
  }
}

class Data {
  String image;
  String text;

  Data({required this.image, required this.text});
}
