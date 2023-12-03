import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiger_erp_hrm/pages/home_page/Component/dash_board.dart';
import 'package:tiger_erp_hrm/pages/authPages/login_page.dart';

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

    //String baseUrl = 'http://175.29.186.86:7021'; // Your API base URL
    //String loginUrl = '$baseUrl/api/v1/login';
    String loginUrl = '${BaseUrl.baseUrl}/api/v1/login';

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
        var jsonResponse = jsonDecode(response.body);
        //var token = jsonResponse['token'];
        var userName = jsonResponse['userName'];
        var empCode = jsonResponse['empCode'];
        var companyID = jsonResponse['companyID'];
        var companyName = jsonResponse['companyName'];

        // Store values in local storage

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DashBoard(
              userName: userName,
              empCode: empCode.toString(),
              companyID: companyID.toString(),
              companyName: companyName,

              //token: token,
            ),
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
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print('Error from loginUser: $e');
      // Handle any network or exception errorshere
    }
  }

}





// base_url.dart
class BaseUrl {
  static const String baseUrl = 'http://175.29.186.86:7021';
  static const String authorization = 'Basic SFJEb3ROZXRBcHA6aHJAMTIzNA==';

  static const String baseUrlST = 'http://hrm.startech.info.bd:51030';
  static const String authorizationST = 'Basic SFJEb3ROZXRBcHA6aHJAMTIzNA==';

}


