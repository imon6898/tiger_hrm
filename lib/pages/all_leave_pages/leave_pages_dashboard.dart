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
import '../subPages/leave_approve/Components/Model/model.dart';
import '../subPages/leave_approve/Components/leave_approved_api_service/leaveApproved_apiService.dart';

class LeavePagesDashBoard extends StatefulWidget {
  final LoginModel? loginModel;

  const LeavePagesDashBoard({
    Key? key,
    this.loginModel,
  }) : super(key: key);

  @override
  State<LeavePagesDashBoard> createState() => LeavePages_DashBoardState();
}

class LeavePages_DashBoardState extends State<LeavePagesDashBoard> {
  List<Data> _photos = [
    Data(image: 'lib/images/A3.png', text: 'Leave\nApply'),
    Data(image: 'lib/images/A5.png', text: 'Supervisor\nLeave Approval'),
    Data(image: 'lib/images/A4.png', text: 'Leave\nApproval'),
    Data(image: 'lib/images/A6.png', text: 'Leave Approval\nby HR'),
    Data(image: 'lib/images/A8.png', text: 'Leave\nfor Tour'),
  ];

  @override
  Widget build(BuildContext context) {
    String userName = widget.loginModel?.userName ?? 'N/A';
    String empCode = widget.loginModel?.empCode ?? 'N/A';
    int? companyId = widget.loginModel?.companyId;
    String companyName = widget.loginModel?.companyName ?? 'N/A';
    String reportTo = widget.loginModel?.reportTo ?? 'N/A';
    int? gradeValue = widget.loginModel?.gradeValue;
    int? gender = widget.loginModel?.gender;
    int? userTypeId = widget.loginModel?.userTypeId;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff162b4a),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white,),
        ),
        title: Text(
          "Leave Page",
          style: TextStyle(color: Colors.white, fontSize: 30, fontFamily: 'Kanit'),
          textAlign: TextAlign.center,
        ),
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
              child: _buildButtonWithBadge(_photos[index], userName, empCode, companyId, companyName, reportTo, gradeValue, gender, userTypeId),
            );
          },
        ),
      ),
    );
  }

  Widget _buildButtonWithBadge(Data data, String userName, String empCode, int? companyId, String companyName, String reportTo, int? gradeValue, int? gender, int? userTypeId) {
    return GetBuilder<LeaveApprovalController>(
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
              badgeCount = controller.badgeCountLeaveApprovalbyHR.value; // Set badge count only if userTypeId is 9
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
            badgeContent: Text('$badgeCount', style: TextStyle(color: Colors.white, fontSize: 18),),
            badgeStyle: BadgeStyle(badgeColor: Colors.red,),
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
    Future.delayed(Duration(milliseconds: 60), () {
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
    Future.delayed(Duration(milliseconds: 60), () {
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
    Future.delayed(Duration(milliseconds: 60), () {
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
    Future.delayed(Duration(milliseconds: 60), () {
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
            onCancel: () async {
              final LeaveApprovalController controller = Get.put(LeaveApprovalController());
              
              String companyID = controller.loginModel?.companyId?.toString() ?? '';
              String userTypeId = controller.loginModel?.userTypeId?.toString() ?? '';
              String empCode = controller.loginModel?.empCode ?? '';

              // Call ApiService function
              int leaveDataList = await ApiLeaveApprovBadgeService.fetchGetWaitingLeaveForApproveByHr(
                companyID: companyID,
                userTypeId: userTypeId,
                empCode: empCode,
              );

              controller.fetchLeaveApprovalByHrBadgeCount(companyID: companyID, empCode: empCode, userTypeId: userTypeId);
              // Handle your data here, e.g., update state, show in UI
              print(leaveDataList);
            },
          ),
        ),
      );
    });
  }

  void _navigateToLeaveForTour() {
    Future.delayed(Duration(milliseconds: 60), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LeaveforTour()),
      );
    });
  }
}

class Data {
  String image;
  String text;

  Data({required this.image,required this.text});
}
