import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../LoginApiController/loginModel.dart';
import '../pages/subPages/leave_approve/Components/leave_approved_api_service/leaveApproved_apiService.dart';

class DashboardController extends GetxController {
  var badgeCountSup = 0.obs;
  var badgeCountLeaveApproval = 0.obs;
  var badgeCountLeaveApprovalByHR = 0.obs;
  LoginModel? loginModel;
  Position? currentLocation;

  Rx<int> get totalLeaveBadgeCount {
    print("userTypeId print by imon2: $userTypeId");
    if (userTypeId == 9) {
      return Rx<int>(badgeCountSup.value + badgeCountLeaveApproval.value + badgeCountLeaveApprovalByHR.value);
    } else {
      return Rx<int>(badgeCountSup.value + badgeCountLeaveApproval.value);
    }
  }


  Rx<int> userTypeId = 0.obs;

  void fetchLeaveApprovalBadgeCount() async {
    String companyID = loginModel?.companyId?.toString() ?? '';
    String empCode = loginModel?.empCode ?? '';
    try {
      final countApproved = await ApiLeaveApproveBadgeService.fetchGetWaitingLeaveForApprove(companyID: companyID, empCode: empCode);
      badgeCountLeaveApproval.value = countApproved;
      print("badgeCount.value: $badgeCountLeaveApproval");
    } catch (e) {
      print('Error fetching badge count: $e');
    }
  }

  void fetchLeaveApprovalByHrBadgeCount() async {
    String companyID = loginModel?.companyId?.toString() ?? '';
    String userTypeId = loginModel?.userTypeId?.toString() ?? '';
    String empCode = loginModel?.empCode ?? '';

    try {
      final countApprovedbyHR = await ApiLeaveApproveBadgeService.fetchGetWaitingLeaveForApproveByHr(
        companyID: companyID,
        userTypeId: userTypeId,
        empCode: empCode,
      );
      badgeCountLeaveApprovalByHR(countApprovedbyHR);
      print("badgeCount.value: $badgeCountLeaveApprovalByHR");

      // Update the userTypeId value
      this.userTypeId.value = int.parse(userTypeId);

      print("userTypeId print by imon: ${this.userTypeId}");

      // After fetching the count, update the totalLeaveBadgeCount
      updateTotalLeaveBadgeCount();
    } catch (e) {
      print('Error fetching badge count: $e');
    }
  }

  void updateTotalLeaveBadgeCount() {
    totalLeaveBadgeCount.refresh(); // Refresh the value of totalLeaveBadgeCount
  }


  void fetchLeaveApprovalSupBadgeCount() async {
    String companyID = loginModel?.companyId?.toString() ?? '';
    String empCode = loginModel?.empCode ?? '';
    try {
      final countSup = await ApiLeaveApproveBadgeService.fetchGetWaitingLeaveForApproveSup(companyID: companyID, empCode: empCode);
      badgeCountSup.value = countSup;
      print("badgeCountSup.value: $badgeCountSup");
    } catch (e) {
      print('Error fetching badge count: $e');
    }
  }
}