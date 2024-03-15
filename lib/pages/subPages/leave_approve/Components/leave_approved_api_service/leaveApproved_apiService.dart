import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../../LoginApiController/loginController.dart';
import '../../../../../LoginApiController/loginModel.dart';

class ApiLeaveApprovBadgeService {
  static Future<int> fetchGetWaitingLeaveForApprove({required String companyID, required String empCode}) async {
    var headers = {
      'accept': '*/*', // Add accept header as per the curl command
      'Authorization': BaseUrl.authorization,
    };

    try {
      var uri = Uri.parse('${BaseUrl.baseUrl}/api/${v.v1}/leave/GetWaitingLeaveForApprove/$companyID/23/$empCode');
      var response = await http.get(
        uri,
        headers: headers,
      );

      print("response fetchGetWaitingLeaveForApprove: $uri");

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body) as List<dynamic>; // Decode JSON response body as a list
        int countApproved = jsonData.length; // Count the number of items in the list
        print("jsonData: $jsonData");
        return countApproved;
      } else {
        print('Request failed with status: ${response.statusCode}');
        return 10;
      }
    } catch (e) {
      print('Error: $e');
      return 0;
    }
  }


  static Future<int> fetchGetWaitingLeaveForApproveByHr({required String companyID, required String empCode, required String userTypeId}) async {
    var headers = {
      'accept': '*/*', // Add accept header as per the curl command
      'Authorization': BaseUrl.authorization,
    };

    try {
      var uri = Uri.parse('${BaseUrl.baseUrl}/api/${v.v1}/leave/GetLeaveInfoForHrApprove/$companyID');
      var response = await http.get(
        uri,
        headers: headers,
      );

      print("response fetchGetWaitingLeaveForApprove: $uri");

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body) as List<dynamic>; // Decode JSON response body as a list
        int countApprovedbyHR = jsonData.length; // Count the number of items in the list
        print("jsonData: $jsonData");
        return countApprovedbyHR;
      } else {
        print('Request failed with status: ${response.statusCode}');
        return 10;
      }
    } catch (e) {
      print('Error: $e');
      return 0;
    }
  }


  static Future<int> fetchGetWaitingLeaveForApproveSup({required String companyID, required String empCode}) async {
    var headers = {
      'Authorization': BaseUrl.authorization,
    };

    try {
      //var uri = Uri.parse('${BaseUrl.baseUrl}/api/${v.v1}/GetWaitingLeaveForRecommend/$companyID}/$empCode}'); // Updated uri according to the provided curl command
      var uri = Uri.parse('${BaseUrl.baseUrl}/api/${v.v1}/GetWaitingLeaveForRecommend/$companyID/$empCode'); // Updated uri according to the provided curl command
      var response = await http.get(
        uri,
        headers: headers,
      );

      print("response fetchGetWaitingLeaveForApproveSup: $uri");

      if (response.statusCode == 200) {

        var jsonData = json.decode(response.body) as List<dynamic>; // Decode JSON response body as a list
        int countSup = jsonData.length;

        //var jsonData = json.decode(response.body) as List<dynamic>; // Decode JSON response body as a list
        //int countSup = jsonData.where((item) => item['id'] != null).length; // Count items with 'id' field not null
        return countSup;
      } else {
        print('Request failed with status: ${response.statusCode}');
        return 0; // Return 0 count if request fails
      }
    } catch (e) {
      print('Error: $e');
      return 0; // Return 0 count in case of error
    }
  }

}

class LeaveApprovalController extends GetxController {
  var badgeCountSup = 0.obs;
  var badgeCountLeaveApproval = 0.obs;
  var badgeCountLeaveApprovalbyHR = 0.obs;
  LoginModel? loginModel;

  Rx<int> get totalLeaveBadgeCount {
    print("userTypeId print by imon2: $userTypeId");
    if (userTypeId == 9) {
      return Rx<int>(badgeCountSup.value + badgeCountLeaveApproval.value + badgeCountLeaveApprovalbyHR.value);
    } else {
      return Rx<int>(badgeCountSup.value + badgeCountLeaveApproval.value);
    }
  }


  Rx<int> userTypeId = 0.obs;

  void fetchLeaveApprovalBadgeCount({required String companyID, required String empCode}) async {
    try {
      final countApproved = await ApiLeaveApprovBadgeService.fetchGetWaitingLeaveForApprove(companyID: companyID, empCode: empCode);
      badgeCountLeaveApproval.value = countApproved;
      print("badgeCount.value: $badgeCountLeaveApproval");
    } catch (e) {
      print('Error fetching badge count: $e');
    }
  }

  void fetchLeaveApprovalByHrBadgeCount({required String companyID, required String empCode, required String userTypeId}) async {
    try {
      final countApprovedbyHR = await ApiLeaveApprovBadgeService.fetchGetWaitingLeaveForApproveByHr(
        companyID: companyID,
        userTypeId: userTypeId,
        empCode: empCode,
      );
      badgeCountLeaveApprovalbyHR.value = countApprovedbyHR;
      print("badgeCount.value: $badgeCountLeaveApprovalbyHR");

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


  void fetchLeaveApprovalSupBadgeCount({required String companyID, required String empCode}) async {
    try {
      final countSup = await ApiLeaveApprovBadgeService.fetchGetWaitingLeaveForApproveSup(companyID: companyID, empCode: empCode);
      badgeCountSup.value = countSup;
      print("badgeCountSup.value: $badgeCountSup");
    } catch (e) {
      print('Error fetching badge count: $e');
    }
  }
}

