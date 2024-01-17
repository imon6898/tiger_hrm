import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiger_erp_hrm/pages/home_page/Component/dash_board.dart';
import 'package:tiger_erp_hrm/pages/authPages/login_page.dart';

import '../pages/authPages/get_employee_data/get_employeement_data.dart';
import '../utils/geolocator.dart';
import 'loginModel.dart';

class LoginController extends GetxController {
  Future<void> logoutUser() async {
    // Clear user information from local storage
    // Example using shared preferences:
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Navigate to the login page
    Get.offAll(() => LoginPage());
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  var isPasswordVisible = false.obs;
  var loginMessage = RxString('');

  Future<void> loginUser({
    required String userName,
    required String password,
    required BuildContext context,
  }) async {
    String loginUrl = '${BaseUrl.baseUrl}/api/${v.v1}/login';

    try {
      var response = await http.post(
        Uri.parse(loginUrl),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Basic SFJEb3ROZXRBcHA6aHJAMTIzNA==',
        },
        body: jsonEncode({
          'userName': userName,
          'password': password,
        }),
      );

      var jsonResponse = jsonDecode(response.body);
      print('API response: $jsonResponse');

      if (response.statusCode == 200) {
        var empCode = jsonResponse['empCode'].toString();
        var companyID = jsonResponse['companyID'].toString();
        var empName = jsonResponse['empName'].toString();
        var reportTo = jsonResponse['reportTo'].toString();
        var loginID = jsonResponse['loginID'].toString();
        var userName = jsonResponse['userName'].toString();
        var loginPassword = jsonResponse['loginPassword'].toString();
        bool isActive = jsonResponse['isActive'] == "Active";
        var companyName = jsonResponse['companyName'].toString();
        var gender = jsonResponse['gender'].toString();
        var gradeValue = jsonResponse['gradeValue'].toString();
        var department = jsonResponse['department'].toString();
        String token = jsonResponse['token'].toString();

        // Save user information in SharedPreferences
        saveUserDataToSharedPreferences(loginID,
          userName,
          empCode,
          companyID,
          empName,
          reportTo,
          loginPassword,
          isActive,
          companyName,
          gender,
          gradeValue,
          department,
          token,
        );


        // Call getEmployeeData with the obtained empCode and companyID
        Employee employee = await getEmployeeData(empCode, companyID);

        // Navigate to the dashboard
        Position? location = await checkLocation();
        String? plusCode = await LocationService.getLocationPlusCode(location!);

        // Display the location in Plus Code format
        print('Location Plus Code: $plusCode');
        // Navigate to the dashboard
        navigateToDashboard(
          context,
          userName,
          empCode,
          companyID,
          empName,
          reportTo,
          jsonResponse,
          location,
        );
        await checkLocation();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login Successful'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        // Unsuccessful login
        var errorMessage = jsonResponse['message'];
        print('Login failed: $errorMessage');

        // Show an error message to the user using a snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed: $errorMessage'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print('Error from loginUser: $e');
      // Handle any network or exception errors here
    }
  }

  Future<Position?> checkLocation() async {
    try {
      Position? location = await LocationService.get();

      if (location != null) {
        // Location is available, you can further process it if needed
        print('Location: ${location.latitude}, ${location.longitude}');
        return location;
      } else {
        // Location not available
        print('Location not available');
        // Return null or handle the absence of location as needed
        return null;
      }
    } catch (e) {
      // Handle any exceptions that might occur during location retrieval
      print('Error from checkLocation: $e');
      return null;
    }
  }


  void saveUserDataToSharedPreferences(
      String loginID,
      String userName,
      String empCode,
      String companyID,
      String empName,
      String reportTo,
      String loginPassword,
      bool isActive,
      String companyName,
      String gender,
      String gradeValue,
      String department,
      String token,
      ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('loginID', loginID);
    prefs.setString('userName', userName);
    prefs.setString('empCode', empCode);
    prefs.setString('companyID', companyID);
    prefs.setString('empName', empName);
    prefs.setString('reportTo', reportTo);
    prefs.setString('loginPassword', loginPassword);
    prefs.setBool('isActive', isActive);
    prefs.setString('companyName', companyName);
    prefs.setString('gender', gender);
    prefs.setString('gradeValue', gradeValue);
    prefs.setString('department', department);
    prefs.setString('token', token);
  }

  void navigateToDashboard(
      BuildContext context,
      String userName,
      String empCode,
      String companyID,
      String empName,
      String reportTo,
      Map<String, dynamic> jsonResponse,
      Position? location,
      ) {
    int gradeValue = int.tryParse(jsonResponse['gradeValue'].toString()) ?? 0;
    int gender = int.tryParse(jsonResponse['gender'].toString()) ?? 0;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return FutureBuilder(
            // Use a FutureBuilder to handle the asynchronous navigation
            future: Future.delayed(Duration(seconds: 2)), // Simulating some delay, you can replace it with your async operation
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Show a circular indicator while waiting
                return Scaffold(
                  body: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Hero(
                          tag: 'imageTag', // Set a unique tag for the Hero widget
                          child: Image.asset(
                            'lib/images/TigerHRMS.png',
                            height: 200, // Set your desired height
                            width: 200, // Set your desired width
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 16), // Add some spacing
                        CircularProgressIndicator(),
                      ],
                    ),

                  ),
                );
              } else {
                // After the delay, navigate to the dashboard
                return DashBoard(
                  userName: userName,
                  empCode: empCode,
                  reportTo: reportTo,
                  companyID: companyID,
                  empName: empName,
                  companyName: jsonResponse['companyName'],
                  location: location ?? Position(
                    latitude: 0.0,
                    longitude: 0.0,
                    accuracy: 0.0,
                    altitude: 0.0,
                    altitudeAccuracy: 0.0,
                    heading: 0.0,
                    headingAccuracy: 0.0,
                    speed: 0.0,
                    speedAccuracy: 0.0,
                    timestamp: DateTime.now(),
                  ), // Provide default values or handle the null case
                  gradeValue: gradeValue,
                  gender: gender,
                );
              }
            },
          );
        },
      ),
    );
  }
}


class v {
  static const String v1 = 'v1';
}


// base_url.dart
class BaseUrl {
  static const String baseUrl = 'http://175.29.186.86:7021';
  static const String authorization = 'Basic SFJEb3ROZXRBcHA6aHJAMTIzNA==';

  // static const String baseUrlST = 'http://hrm.startech.info.bd:51030';
  // static const String authorizationST = 'Basic SFJEb3ROZXRBcHA6aHJAMTIzNA==';

}


