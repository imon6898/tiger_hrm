import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tiger_erp_hrm/pages/home_page/Component/dash_board.dart';
import 'package:tiger_erp_hrm/LoginApiController/loginModel.dart';
import 'package:tiger_erp_hrm/pages/authPages/login_page.dart';





void main() async {runApp(MyApp());}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/loginPage',
      routes: {
        '/loginPage': (context) => LoginPage(),
        // Pass the loginData when navigating to the Dashboard
        '/dashboard': (context) {
          //final loginData = Get.arguments as LoginModel; // Retrieve loginData
          return
            DashBoard(
              userName: "",
              companyName: '',
              empCode: '',
              companyID: '',
            );

        },
      },
    );
  }
}