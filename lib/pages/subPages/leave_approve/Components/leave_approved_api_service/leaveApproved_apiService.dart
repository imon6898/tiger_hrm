import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../../LoginApiController/loginController.dart';
import '../../../../../LoginApiController/loginModel.dart';

class ApiLeaveApproveBadgeService {

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

