import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:get/get.dart'; // Import Get package
import 'splash_screen.dart';
import 'utils/geolocator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('loginData'); // Open the Hive box for login data

  // Get the current location when the app starts
  await LocationService.get();

  FilePicker.platform;

  runApp(MyApp());
}




class MyApp extends StatelessWidget {

  MyApp({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp( // Use GetMaterialApp instead of MaterialApp
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}




// class CheckLogin extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final Box<LoginModel> box = Hive.box<LoginModel>('userBox');
//     final LoginModel? savedUser = box.get('user_data');
//
//     if (savedUser != null) {
//       return DashBoard(
//         userName: savedUser.userName,
//         empCode: savedUser.empCode,
//         reportTo: savedUser.reportTo,
//         companyID: savedUser.companyId.toString(),
//         empName: savedUser.empName,
//         companyName: savedUser.companyName,
//         location: savedUser.location,
//         gradeValue: savedUser.gradeValue,
//         gender: savedUser.gender,
//       );
//     } else {
//       return LoginPage();
//     }
//   }
// }

