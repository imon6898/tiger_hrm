import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiger_erp_hrm/pages/authPages/login_page.dart';
import 'package:tiger_erp_hrm/pages/home_page/Component/dash_board.dart';

import 'LoginApiController/loginController.dart';
import 'utils/geolocator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocationService.locationPermissionCheck();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? savedUserName = prefs.getString('userName');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/loginPage', // Always start with the login page
      getPages: [
        GetPage(
          name: '/loginPage',
          page: () => LoginPage(),
        ),
      ],
    );
  }
}