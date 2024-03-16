import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tiger_erp_hrm/pages/subPages/leave_approve/Components/leave_approved_api_service/leaveApproved_apiService.dart';
import '../../../Coustom_widget/Textfield.dart';
import '../../../LoginApiController/loginController.dart';
import '../../../controller/dashboard_controller.dart';

class ChangePass extends StatefulWidget {

  const ChangePass({Key? key}) : super(key: key);

  @override
  State<ChangePass> createState() => _ChangePassState();
}

class _ChangePassState extends State<ChangePass> {
  late TextEditingController loginIDController;
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  var dashboardControl = Get.put(DashboardController());

  String errorText = '';
  bool passwordMismatch = false;
  bool passwordMatched = false;

  @override
  void initState() {
    super.initState();
    loginIDController = TextEditingController(text: dashboardControl.loginModel?.empCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff162b4a),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
        ),
        title: const Text(
          'Change Password',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontFamily: 'Kanit',
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Container(
              child: Lottie.asset(
                passwordMismatch
                    ? 'lib/images/newpassnotmatch.json'
                    : passwordMatched
                    ? 'lib/images/newpassmatch.json'
                    : 'lib/images/changepass.json',
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),
            CustomTextFields(
              labelText: 'Login ID',
              hintText: 'Login ID',
              borderColor: 0xFFBCC2C2,
              filled: false,
              disableOrEnable: true,
              controller: loginIDController,
              onChanged: (value) {
                print('Text changed: $value');
              },
            ),
            CustomTextFields(
              labelText: 'Old Password',
              hintText: 'Old Password',
              borderColor: 0xFFBCC2C2,
              filled: false,
              disableOrEnable: true,
              controller: oldPasswordController,
              onChanged: (value) {
                print('Text changed: $value');
              },
            ),
            CustomTextFields(
              labelText: 'New Password',
              hintText: 'New Password',
              borderColor: 0xFFBCC2C2,
              filled: false,
              disableOrEnable: true,
              controller: newPasswordController,
              onChanged: (value) {
                print('Text changed: $value');
                validatePasswords();
              },
            ),
            CustomTextFields(
              labelText: 'Confirm Password',
              hintText: 'Confirm Password',
              borderColor: 0xFFBCC2C2,
              filled: false,
              disableOrEnable: true,
              controller: confirmPasswordController,
              onChanged: (value) {
                print('Text changed: $value');
                validatePasswords();
              },
            ),
            if (errorText.isNotEmpty)
              Text(
                errorText,
                style: TextStyle(color: Colors.red),
              ),

            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(30),
              child: ElevatedButton(
                onPressed: () {
                  // Call the function to change the password
                  changePassword(context);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                child: Text("Change Pass"),
              ),
            )
          ],
        ),
      ),
    );
  }

  void validatePasswords() {
    if (newPasswordController.text.length < 4) {
      showErrorMessage('New Password must be at least 4 characters');
    } else if (newPasswordController.text != confirmPasswordController.text) {
      showErrorMessage('Passwords do not match');
    } else {
      clearErrorMessages();
      showSuccessMessage('Passwords match');
    }
  }

  void showErrorMessage(String message) {
    setState(() {
      errorText = message;
      passwordMismatch = true;
      passwordMatched = false;
    });
    Future.delayed(Duration(seconds: 5), () {
      clearErrorMessages();
    });
  }

  void showSuccessMessage(String message) {
    setState(() {
      errorText = message;
      passwordMismatch = false;
      passwordMatched = true;
    });
    Future.delayed(Duration(seconds: 5), () {
      clearErrorMessages();
    });
  }

  void clearErrorMessages() {
    setState(() {
      errorText = '';
      passwordMismatch = false;
      passwordMatched = false;
    });
  }



  Future<void> changePassword(BuildContext context) async {
    final url = Uri.parse('${BaseUrl.baseUrl}/api/${v.v1}/security/change-password');

    // Replace these values with your actual data
    final data = {
      "userID": loginIDController.text,
      "oldPassword": oldPasswordController.text,
      "newPassword": newPasswordController.text,
      "companyID": dashboardControl.loginModel?.companyId,
    };

    final headers = {
      'accept': '*/*',
      'Content-Type': 'application/json',
      'Authorization': '${BaseUrl.authorization}',
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData is bool && responseData == false) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Old Password Wrong. Please try again.'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          oldPasswordController.clear();
          newPasswordController.clear();
          confirmPasswordController.clear();
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Password changed successfully'),
                duration: Duration(seconds: 2),
                backgroundColor: Colors.green,
              ),
          );

        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to change password. Status code: ${response.statusCode}'),
            duration: Duration(seconds: 2),
          ),
        );

      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error during password change: $e'),
          duration: Duration(seconds: 2),
        ),
      );

    }
  }



}
