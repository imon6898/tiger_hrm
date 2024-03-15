// login_controller.dart

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tiger_erp_hrm/pages/home_page/Component/dash_board.dart';
import 'package:tiger_erp_hrm/pages/authPages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiger_erp_hrm/LoginApiController/loginModel.dart';

class LoginController extends GetxController {
  final storage = FlutterSecureStorage();

  Future<void> logoutUser() async {
    try {
      await storage.deleteAll(); // Clear all data from secure storage

      Get.offAll(() => LoginPage());

      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text('Logged out successfully'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      print('Error from logoutUser: $e');
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  var isPasswordVisible = false.obs;
  var loginMessage = RxString('');

  // Future<void> loginUser({
  //   required String userName,
  //   required String password,
  //   required BuildContext context,
  // }) async {
  //   String loginUrl = '${BaseUrl.baseUrl}/api/${v.v1}/login';
  //
  //   try {
  //     var response = await http.post(
  //       Uri.parse(loginUrl),
  //       headers: {
  //         'Accept': 'application/json',
  //         'Content-Type': 'application/json',
  //         'Authorization': '${BaseUrl.authorization}',
  //       },
  //       body: jsonEncode({
  //         'userName': userName,
  //         'password': password,
  //       }),
  //     );
  //
  //     var jsonResponse = jsonDecode(response.body);
  //
  //     if (response.statusCode == 200) {
  //       var token = jsonResponse['token'].toString();
  //       var loginID = jsonResponse['loginID'].toString();
  //       var loggedInUserName = jsonResponse['userName'].toString();
  //
  //       // Create a LoginModel instance with sensitive data encrypted
  //       LoginModel userData = LoginModel(
  //         token: token,
  //         loginId: int.tryParse(loginID),
  //         userName: loggedInUserName,
  //         // You can encrypt other sensitive data like passwords before storing
  //       );
  //
  //       await saveUserData(userData);
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Logged in successfully'),
  //           backgroundColor: Colors.green,
  //           duration: Duration(seconds: 3),
  //         ),
  //       );
  //
  //       Get.off(() => DashBoard(loginModel: userData));
  //     } else {
  //       loginMessage.value = jsonResponse['message'].toString();
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text(loginMessage.value),
  //           backgroundColor: Colors.red,
  //           duration: Duration(seconds: 3),
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     print('Error from loginUser: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Something went wrong! Please try again later.'),
  //         backgroundColor: Colors.red,
  //         duration: Duration(seconds: 3),
  //       ),
  //     );
  //   }
  // }

  // Future<void> saveUserData(LoginModel userData) async {
  //   try {
  //     // Encrypt sensitive data before storing
  //     String encryptedData = jsonEncode(userData.toJson());
  //
  //     // Save encrypted data to secure storage
  //     await storage.write(key: 'userData', value: encryptedData);
  //   } catch (e) {
  //     print('Error from saveUserData: $e');
  //   }
  // }
}
//
class v {
  static const String v1 = 'v1';
}
//
// // base_url.dart
// class BaseUrl {
//   static const String baseUrl = 'http://175.29.186.86:7021';
//   static const String authorization = 'Basic YWRtaW5pc3RyYXRvcjpBQyFAIyQxMjQzdXNlcg==';
// }


class BaseUrl {
  static const String baseUrl = 'http://103.118.19.110:7021';
  static const String authorization = 'Basic dXN0YXI6QUMhQCMkMTI0M3VzZXI=';
  static const String TOKEN = 'Token';
}