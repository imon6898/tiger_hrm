import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tiger_erp_hrm/LoginApiController/loginModel.dart';
import 'package:tiger_erp_hrm/pages/subPages/leave_apply/leave_apply.dart';
import 'package:tiger_erp_hrm/pages/subPages/leave_approve/ApproveLeaves.dart';
import 'package:tiger_erp_hrm/pages/subPages/leave_approve_by_hr/leaveApproveByHr.dart';
import 'package:tiger_erp_hrm/pages/subPages/sup_leave_approval/supervisor_leave_approval.dart';
import 'package:tiger_erp_hrm/pages/subPages/leavefortour/leaveForTour.dart';
import '../../Coustom_widget/neumorphic_button.dart';
import 'package:badges/badges.dart' as custom_badges;
import '../../LoginApiController/loginController.dart';
import '../../LoginApiController/loginModel.dart';
import '../../controller/dashboard_controller.dart';
import '../subPages/leave_approve/Components/Model/model.dart';
import '../subPages/leave_approve/Components/leave_approved_api_service/leaveApproved_apiService.dart';

class LeavePagesDashBoard extends StatefulWidget {

  const LeavePagesDashBoard({Key? key}) : super(key: key);

  @override
  State<LeavePagesDashBoard> createState() => LeavePages_DashBoardState();
}

class LeavePages_DashBoardState extends State<LeavePagesDashBoard> {

  final List<Data> _photos = [
    Data(image: 'lib/images/A3.png', text: 'Leave\nApply'),
    Data(image: 'lib/images/A5.png', text: 'Supervisor\nLeave Approval'),
    Data(image: 'lib/images/A4.png', text: 'Leave\nApproval'),
    Data(image: 'lib/images/A6.png', text: 'Leave Approval\nby HR'),
    Data(image: 'lib/images/A8.png', text: 'Leave\nfor Tour'),
  ];

  var dashboardControl = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    String userName = dashboardControl.loginModel?.userName ?? 'N/A';
    String empCode = dashboardControl.loginModel?.empCode ?? 'N/A';
    int? companyId = dashboardControl.loginModel?.companyId;
    String companyName = dashboardControl.loginModel?.companyName ?? 'N/A';
    String reportTo = dashboardControl.loginModel?.reportTo ?? 'N/A';
    int? gradeValue = dashboardControl.loginModel?.gradeValue;
    int? gender = dashboardControl.loginModel?.gender;
    int? userTypeId = dashboardControl.loginModel?.userTypeId;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff162b4a),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white,),
        ),
        title: const Text(
          "Leave Page",
          style: TextStyle(color: Colors.white, fontSize: 30, fontFamily: 'Kanit'),
          textAlign: TextAlign.center,
        ),
      ),
      body: Container(
        color: const Color(0xffe9f0fd),
        child: GridView.builder(
          itemCount: _photos.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: _buildButtonWithBadge(_photos[index], userName, empCode, companyId, companyName, reportTo, gradeValue, gender, userTypeId),
            );
          },
        ),
      ),
    );
  }

  Widget _buildButtonWithBadge(Data data, String userName, String empCode, int? companyId, String companyName, String reportTo, int? gradeValue, int? gender, int? userTypeId) {
    return GetBuilder<DashboardController>(
      builder: (controller) {
        int badgeCount = 0;

        switch (data.text) {
          case 'Leave\nApply':
            badgeCount = 0; // You can set the badge count for 'Leave Apply' button if needed
            break;
          case 'Supervisor\nLeave Approval':
            badgeCount = controller.badgeCountSup.value;
            print("badgeCountsup::: $badgeCount");
            break;
          case 'Leave\nApproval':
            badgeCount = controller.badgeCountLeaveApproval.value;
            print("Leave Approval badgeCount:: $badgeCount");
            break;
          case 'Leave Approval\nby HR':
            if (userTypeId == 9) {
              badgeCount = controller.badgeCountLeaveApprovalByHR.value; // Set badge count only if userTypeId is 9
              print("Leave Approval by HR badgeCount:: $badgeCount");
            }
            break;
          case 'Leave\nfor Tour':
            badgeCount = 0; // You can set the badge count for 'Leave for Tour' button if needed
            break;
          default:
            break;
        }

        if (badgeCount > -0) {
          return custom_badges.Badge(
            badgeContent: Text('$badgeCount', style: const TextStyle(color: Colors.white, fontSize: 18),),
            badgeStyle: const BadgeStyle(badgeColor: Colors.red,),
            position: BadgePosition.topEnd(top: -8, end: -2),
            child: _buildButton(data, userName, empCode, companyId, companyName, reportTo, gradeValue, gender, userTypeId),
          );
        } else {
          return _buildButton(data, userName, empCode, companyId, companyName, reportTo, gradeValue, gender, userTypeId);
        }
      },
    );
  }

  Widget _buildButton(Data data, String userName, String empCode, int? companyId, String companyName, String reportTo, int? gradeValue, int? gender, int? userTypeId) {
    return NeumorphicButton(
      imagePathAsset: data.image,
      buttonText: data.text,
      onTap: () {
        _handleButtonClick(data, userName, empCode, companyId, companyName, reportTo, gradeValue, gender, userTypeId);
      },
    );
  }

  void _handleButtonClick(Data data, String userName, String empCode, int? companyId, String companyName, String reportTo, int? gradeValue, int? gender, int? userTypeId) {
    switch (data.text) {
      case 'Leave\nApply':
        _navigateToLeaveApply(userName, empCode, companyId, companyName, gradeValue, gender);
        break;
      case 'Supervisor\nLeave Approval':
        _navigateToSupervisorLeaveApproval(userName, empCode, companyId, companyName);
        break;
      case 'Leave\nApproval':
        _navigateToLeaveApproval(userName, empCode, companyId, companyName);
        break;
      case 'Leave Approval\nby HR':
        _navigateToLeaveApprovalByHR(userName, empCode, companyId, companyName, reportTo, userTypeId);
        break;
      case 'Leave\nfor Tour':
        _navigateToLeaveForTour();
        break;
    }
  }

  void _navigateToLeaveApply(String userName, String empCode, int? companyId, String companyName, int? gradeValue, int? gender) {
    Future.delayed(const Duration(milliseconds: 60), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LeaveApplyPage(
            userName: userName,
            empCode: empCode,
            companyID: companyId?.toString() ?? '',
            companyName: companyName,
            gradeValue: gradeValue ?? 0,
            gender: gender ?? 0,
          ),
        ),
      );
    });
  }

  void _navigateToSupervisorLeaveApproval(String userName, String empCode, int? companyId, String companyName) {
    Future.delayed(const Duration(milliseconds: 60), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SupApproveLeavesPage(
            userName: userName,
            empCode: empCode,
            companyID: companyId?.toString() ?? '',
            companyName: companyName,
          ),
        ),
      );
    });
  }

  void _navigateToLeaveApproval(String userName, String empCode, int? companyId, String companyName) {
    Future.delayed(const Duration(milliseconds: 60), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ApproveLeavesPage(
            userName: userName,
            empCode: empCode,
            companyID: companyId?.toString() ?? '',
            companyName: companyName,
          ),
        ),
      );
    });
  }

  void _navigateToLeaveApprovalByHR(String userName, String empCode, int? companyId, String companyName, String reportTo, int? userTypeId) {
    Future.delayed(const Duration(milliseconds: 60), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LeaveApproveByHr(
            userName: userName,
            empCode: empCode,
            companyID: companyId?.toString() ?? '',
            companyName: companyName,
            reportTo: reportTo ?? "",
            userTypeId: userTypeId ?? 0,
          ),
        ),
      );
    });
  }

  void _navigateToLeaveForTour() {
    Future.delayed(const Duration(milliseconds: 60), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LeaveforTour()),
      );
    });
  }
}

class Data {
  String image;
  String text;

  Data({required this.image,required this.text});
}
